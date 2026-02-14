# Post‑setup checklist — Terraform → Ansible → WireGuard → Kubeconfig

Commands and checks to perform after infrastructure bootstrap. Follow in order.

---

## 1) Environment & prerequisites 🔧
- Ensure AWS credentials / profile are available (or Terraform role is configured).
- Have `sops`, `terraform`, `ansible`, `wg-quick` and `kubectl` installed locally.
- Working directory: repository root.

Recommended shell (example):

```bash
cd /home/ferdinand/services/infrastructure-live
export AWS_PROFILE=elite-devops     # if you use profiles
export TF_VAR_aws_profile=$AWS_PROFILE
```

---

## 2) Create / recreate infrastructure with Terraform ✅
1. Initialize and plan:

```bash
terraform -chdir=terraform/k3s-cluster init
terraform -chdir=terraform/k3s-cluster plan -out=tfplan
```

2. Apply (creates EC2 / SG / EIP etc.):

```bash
terraform -chdir=terraform/k3s-cluster apply -input=false -auto-approve tfplan
```

3. Get the instance/public IPs after apply:

```bash
terraform -chdir=terraform/k3s-cluster output public_ipv4        # public IP
terraform -chdir=terraform/k3s-cluster output elastic_ipv4        # elastic IP (if used)
```

Save the `elastic_ipv4` / `public_ipv4` value for inventory updates.

---

## 3) Update Ansible inventory (hosts.yml) 🔁
Replace `ansible_host` with the new public/elastic IP from Terraform outputs.

Example (single command):

```bash
NEW_IP=$(terraform -chdir=terraform/k3s-cluster output -raw elastic_ipv4)
# update inventory
python - <<'PY'
from pathlib import Path
p=Path('ansible/inventory/hosts.yml')
s=p.read_text()
s=s.replace('ansible_host: 3.224.202.215','ansible_host: '+'''%s''')
p.write_text(s)
print('hosts.yml updated')
PY
```

(Or edit `ansible/inventory/hosts.yml` by hand.)

---

## 4) Add client peer + secrets (WireGuard) 🔐
- Add client `public_key`, `allowed_ips` and optional `preshared_key` to
  `ansible/inventory/group_vars/all/secrets.sops.yaml` under `wireguard_peers`.

Example snippet (paste into SOPS file):

```yaml
wireguard_peers:
  - public_key: <CLIENT_PUBLIC_KEY>
    allowed_ips: 10.52.0.2/32
    preshared_key: <PSK>   # optional but recommended
```

- Edit & re-encrypt with sops (interactive):

```bash
sops ansible/inventory/group_vars/all/secrets.sops.yaml   # edit + save
# or re-encrypt file edited in plaintext
sops -e -i ansible/inventory/group_vars/all/secrets.sops.yaml
```

---

## 5) Run Ansible to configure the server (dry-run then apply) ⚙️
1. Dry‑run (recommended):

```bash
ansible-playbook -i ansible/inventory ansible/site.yml --limit k3s-server --check
```

2. Apply for real:

```bash
ansible-playbook -i ansible/inventory ansible/site.yml --limit k3s-server
```

Notes:
- If you only want to run WireGuard, tag the playbook or run the role directly.
- Troubleshooting: run `ansible -i ansible/inventory k3s-server -m ping` to verify connectivity.

---

## 6) WireGuard — client setup (your laptop) 🔐🔌
1. Prepare the client config file (we store an example at `wg-clients/client1.conf`).
   - Edit `Endpoint = <SERVER_PUBLIC_IP>:51820` → replace `<SERVER_PUBLIC_IP>` with the EIP/public IP from Terraform.
   - Ensure `PrivateKey` is the client private key and `PublicKey` in the Peer block is the server public key.

2. Bring up the interface on your laptop:

```bash
sudo wg-quick up /path/to/client1.conf
# verify
sudo wg show
ping -c 3 10.52.0.1       # ping server WireGuard IP
```

3. If connecting via WireGuard to reach Kubernetes, use the WireGuard server IP for kubeconfig (see below).

---

## 7) Fetch / fix kubeconfig (K3s) 🧭
1. Copy kubeconfig from the server to repo (replace <IP> with server IP):

```bash
scp ubuntu@<SERVER_PUBLIC_IP>:/etc/rancher/k3s/k3s.yaml kubernetes/k3s.yaml
```

2. Edit `kubernetes/k3s.yaml` server address depending on how you'll connect:
- If connecting directly over the public internet: set `server: https://<PUBLIC_IP>:6443`
- If connecting over the VPN: set `server: https://<WIREGUARD_IP>:6443` (preferred for security)

Example (replace in-place):

```bash
# use WireGuard IP when connected to VPN
sed -i 's|server: .*|server: https://10.52.0.1:6443|' kubernetes/k3s.yaml
chmod 600 kubernetes/k3s.yaml
export KUBECONFIG=$(pwd)/kubernetes/k3s.yaml
kubectl get nodes -A
```

---

## 8) Useful verification commands ✅
- Terraform outputs: `terraform -chdir=terraform/k3s-cluster output -json`
- Check Ansible connection: `ansible -i ansible/inventory k3s-server -m ping`
- Check WireGuard: `sudo wg show` (server) / `wg-quick show client1` (client)
- Kubernetes health: `kubectl get pods -A`, `kubectl get nodes`

---

## 9) Common post‑setup gotchas & tips 💡
- Keep `secrets.sops.yaml` encrypted with `sops` — never commit plaintext.
- Security Group: allow UDP/51820 from client IP(s) and SSH only from admin CIDRs.
- If Ansible can't SSH: verify `ansible_host` in `ansible/inventory/hosts.yml` and your SSH key (`~/.ssh/id_ed25519`).
- Use WireGuard when possible — it's the intended access path for admin traffic.

---

## 10) Quick checklist (one‑liner summary) ✅
1) terraform apply → 2) update `hosts.yml` → 3) sops edit & encrypt secrets → 4) ansible-playbook apply → 5) copy kubeconfig & edit server address → 6) bring up client WG

---

If needed, a `scripts/` helper can be added to automate `terraform -> inventory -> ansible -> kubeconfig` steps.
