# Cilium migration plan (replacing Flannel in K3s)

This document defines a phased plan to move from K3s default Flannel networking to Cilium, with security-first defaults and rollback safety.

## Goals

- Replace Flannel with Cilium as the cluster CNI.
- Enforce Kubernetes `NetworkPolicy` through Cilium policy engine.
- Improve network observability with Hubble.
- Keep migration low-risk through staged rollout and explicit rollback points.

## Current state (baseline)

- K3s is installed by Ansible.
- Cluster/service CIDRs are managed through inventory (`k3s_cluster_cidr`, `k3s_service_cidr`).
- `k3s_disable_network_policy` is already enabled to avoid double policy controllers in K3s.
- Flannel interfaces can be cleaned up during reinstall workflows.

## Target architecture

1. Run K3s without Flannel (`flannel-backend: none`).
2. Install Cilium immediately after K3s control-plane readiness.
3. Enable Hubble (relay/UI optional) for flow visibility and troubleshooting.
4. Use Cilium network policies as the single source of truth for east-west traffic control.

## Phased implementation

### Phase 1 — Preparation

- Pin Cilium version and maintain a compatibility matrix with the pinned K3s version.
- Define baseline Cilium values:
  - `kubeProxyReplacement: false` (safer initial mode).
  - Hubble enabled with TLS.
  - Prometheus metrics enabled.
- Prepare mandatory baseline policies:
  - Default deny per namespace.
  - Explicit DNS egress allow.
  - Explicit kube-api server access where required.

### Phase 2 — Controlled rollout

- Update K3s config to disable Flannel (`flannel-backend: none`) on a non-production environment first.
- Install Cilium with pinned Helm values and wait for Cilium DaemonSet readiness before deploying workloads.
- Validate:
  - Node-to-pod and pod-to-service connectivity.
  - DNS resolution.
  - Existing ingress/egress flows required by platform components (Argo CD, Vault, monitoring).

### Phase 3 — Hardening and policy enforcement

- Move from permissive to namespace-level default deny policies.
- Enforce least-privilege egress from application namespaces.
- Enable and retain Hubble flow logs for incident response and compliance evidence.
- Add policy verification checks in CI (manifest lint + policy presence checks).

### Phase 4 — Rollback readiness

- Keep a documented rollback runbook:
  - Re-enable Flannel backend in K3s config.
  - Remove Cilium components in controlled order.
  - Restart K3s and validate baseline networking.
- Define clear rollback triggers:
  - Persistent Cilium DaemonSet unready state.
  - Critical platform communication failures not resolved within change window.

## Security best practices checklist

- [ ] Version pinning for K3s + Cilium (no floating latest tags).
- [ ] Default deny network policy posture in all non-system namespaces.
- [ ] Strictly scoped egress (DNS, required internal services, approved external endpoints only).
- [ ] Hubble TLS enabled and access to UI/API restricted.
- [ ] Audit and alerting wired for Cilium policy drops/denies.
- [ ] Change executed through staged environments with rollback test before production rollout.
