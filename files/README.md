# Sample Manifests with Security Violations

This directory contains sample manifest files that intentionally violate various Kyverno security policies. These files are designed for testing and educational purposes to demonstrate common security anti-patterns.

## ⚠️ WARNING

**These manifests are intentionally insecure and should NEVER be used in production environments. They are designed solely for testing Kyverno policy enforcement and understanding security violations.**

## Directory Structure

```
manifests/
├── kubernetes/                # Kubernetes manifest violations
│   ├── pod-security-violations.yaml
│   ├── workload-security-violations.yaml
│   ├── statefulset-violations.yaml
│   └── rbac-violations.yaml
└── README.md
```

## Policy Violations by Category

### 1. Pod Security Violations (`kubernetes/pod-security-violations.yaml`)

- **Privileged containers**: Running containers with `privileged: true`
- **Root user execution**: Running containers as root (`runAsUser: 0`)
- **Host access**: Mounting host filesystem and using host networking
- **Capabilities**: Adding dangerous capabilities like `ALL`
- **Seccomp profiles**: Using `Unconfined` seccomp profile

### 2. Workload Security Violations (`kubernetes/workload-security-violations.yaml`)

- **Hardcoded secrets**: Environment variables with plaintext credentials
- **Insecure configurations**: ConfigMaps with hardcoded passwords
- **Resource exposure**: Secrets mounted without proper access controls
- **Root execution**: Containers running as root user

### 3. StatefulSet Violations (`kubernetes/statefulset-violations.yaml`)

- **Database credentials**: Hardcoded database passwords
- **Privileged capabilities**: Adding `SYS_ADMIN` and `NET_ADMIN` capabilities
- **Insecure configurations**: PostgreSQL configuration allowing all connections
- **Root execution**: Running database containers as root

### 4. RBAC Violations (`kubernetes/rbac-violations.yaml`)

- **Overly permissive roles**: ClusterRole and Role with `*` resources and verbs
- **Privileged bindings**: Binding overly permissive roles to default service accounts
- **IAM role annotations**: Service accounts with privileged AWS IAM roles


## Testing Kyverno Policies

These manifests can be used to test the following Kyverno policy categories:

1. **Pod Security Policies** - Test enforcement of container security standards

## Usage Examples

### Test Pod Security Policies
```bash
kubectl apply -f kubernetes/pod-security-violations.yaml
```

## Remediation

Each violation demonstrates a security anti-pattern. To fix these issues:

1. **Remove privileged access**: Use non-root users and minimal capabilities
2. **Secure configurations**: Use Kubernetes secrets and external secret management
3. **Restrict RBAC**: Follow principle of least privilege
4. **Secure networking**: Use private subnets and restrictive security groups
5. **Image security**: Pin versions, use multi-stage builds, and security scanning

## Related Kyverno Policies

These manifests are designed to test policies from:
- [Pod Security Policies](https://github.com/nirmata/kyverno-policies/tree/main/pod-security)
- [Dockerfile Best Practices](https://github.com/nirmata/kyverno-policies/tree/main/dockerfile-best-practices)
- [Workload Security](https://github.com/nirmata/kyverno-policies/tree/main/workload-security)
- [RBAC Best Practices](https://github.com/nirmata/kyverno-policies/tree/main/rbac-best-practices)

## Contributing

When adding new violation examples:
1. Ensure they clearly demonstrate a specific security anti-pattern
2. Add appropriate comments explaining the violation
3. Update this README with the new violation details
4. Test that the violation is properly detected by relevant Kyverno policies
