# NCTL Manifest Scan Configuration Example

This file provides examples and configuration details for the NCTL Manifest Security Scan workflow.

## 🔑 **Required GitHub Secrets Configuration**

### **Repository Settings → Secrets and Variables → Actions**

| Secret Name | Value | Description |
|-------------|-------|-------------|
| `NIRMATA_TOKEN` | `DGJqPuqOpt...` | Your Nirmata API access token |
| `NIRMATA_URL` | `https://www.nirmata.io` | Nirmata Control Hub URL |
| `NIRMATA_USERID` | `user@example.com` | Your Nirmata user email |

## 📁 **Expected Repository Structure**

```
sample-workflow/
├── .github/
│   └── workflows/
│       ├── nctl-manifest-scan.yaml    # This workflow file
│       └── README.md                   # Workflow documentation
├── manifests/
│   ├── kubernetes/
│   │   ├── pod-security-violations.yaml
│   │   ├── rbac-violations.yaml
│   │   ├── statefulset-violations.yaml
│   │   └── workload-security-violations.yaml
│   ├── docker/
│   │   └── Dockerfile
│   ├── terraform/
│   │   └── main.tf
│   └── README.md
└── README.md
```

## 🎯 **Policy Sets Used**

### **Available Policy Sets**
The workflow scans against these embedded policy sets:

- **`pss-baseline`**: Pod Security Standards baseline
- **`pss-restricted`**: Pod Security Standards restricted
- **`rbac-best-practices`**: RBAC best practices

### **Policy Coverage**
- **Kubernetes YAML**: Pod Security Standards, RBAC policies
- **Dockerfiles**: Container security best practices
- **Terraform**: Infrastructure security policies

## 🔍 **Expected Scan Results**

### **Sample Scan Output Structure**
```
Starting manifest security scan...
Scanning manifests folder: /home/runner/work/sample-workflow/sample-workflow/manifests

Files to be scanned:
manifests/kubernetes/pod-security-violations.yaml
manifests/kubernetes/rbac-violations.yaml
manifests/kubernetes/statefulset-violations.yaml
manifests/kubernetes/workload-security-violations.yaml

Running NCTL scan with PSS and RBAC policies...
Scan completed with violations or errors

Scan Summary:
- Policies evaluated: 15
- Violations found: 8
```

### **Violation Examples**

#### **PSS-Baseline Violations**
```
❌ Pod Security Standards Baseline
  - privileged: true (should be false)
  - runAsUser: 0 (should be > 0)
  - hostPID: true (should be false)
```

#### **RBAC Violations**
```
❌ RBAC Best Practices
  - ClusterRole with excessive permissions
  - ServiceAccount with privileged annotations
  - RoleBinding to privileged users
```

## 🔗 **NCH Integration URLs**

### **Generated Links Format**
The workflow automatically generates these URLs:

```bash
# Base URL
NCH_BASE_URL="https://www.nirmata.io/webclient"

# Repository-specific URLs
REPO_URL="https://github.com/username/sample-workflow"

# Final URLs
VIOLATIONS_URL="$NCH_BASE_URL/#clusters/policyReport/repositoryDetails?repo=$REPO_URL&backurl=clustersPolicyReport"
EXCEPTIONS_URL="$NCH_BASE_URL/#clusters/policyReport/repositoryDetails?repo=$REPO_URL&backurl=clustersPolicyReport"
REMEDIATIONS_URL="$NCH_BASE_URL/#clusters/policyReport/repositoryDetails?repo=$REPO_URL&backurl=clustersPolicyReport"
```

### **Example URLs**
```
https://www.nirmata.io/webclient/#clusters/policyReport/repositoryDetails?repo=https%3A%2F%2Fgithub.com%2Fusername%2Fsample-workflow&backurl=clustersPolicyReport
```

## 📊 **Workflow Outputs**

### **GitHub Actions Outputs**
```yaml
outputs:
  scan_status: 'success' | 'violations'
  violation_count: '8'
  policy_count: '15'
```

### **Artifacts Generated**
- `scan-results.txt`: Complete scan output
- `.nctl/`: NCTL configuration and cache
- Workflow summary with NCH links

## 🚀 **Manual Trigger Options**

### **Workflow Dispatch Inputs**
```yaml
workflow_dispatch:
  inputs:
    scan_type:
      description: 'Type of scan to perform'
      required: true
      default: 'all'
      type: choice
      options:
        - all                    # All policy sets
        - pss-baseline          # Only PSS baseline
        - pss-restricted        # Only PSS restricted
        - rbac-best-practices   # Only RBAC policies
```

### **Usage Examples**
```bash
# Trigger from GitHub CLI
gh workflow run nctl-manifest-scan.yaml -f scan_type=pss-baseline

# Trigger from GitHub UI
# Actions → NCTL Manifest Security Scan → Run workflow → Select scan_type
```

## 🔧 **NCTL Command Examples**

### **Manual Testing**
```bash
# Login to NCH
nctl login --url https://www.nirmata.io --userid user@example.com --token <token>

# Test scan with specific policy sets
nctl scan repository --policy-sets pss-baseline,pss-restricted,rbac-best-practices --policies manifests

# Check available policy sets
nctl get policy-sets

# View NCTL version
nctl version
```

### **Expected Commands in Workflow**
```bash
# Install NCTL
uses: nirmata/action-install-nctl-scan@v0.0.6

# Login
nctl login --url $NIRMATA_URL --userid $NIRMATA_USERID --token $NIRMATA_TOKEN

# Scan repository
nctl scan repository \
  --policy-sets pss-baseline,pss-restricted,rbac-best-practices \
  --policies manifests
```

## 📈 **Performance Considerations**

### **Scan Duration**
- **Small manifests**: 30-60 seconds
- **Medium manifests**: 1-3 minutes
- **Large manifests**: 3-10 minutes

### **Resource Usage**
- **Memory**: 512MB-1GB
- **CPU**: 1-2 cores
- **Network**: Moderate (NCH communication)

## 🚨 **Error Handling**

### **Common Error Scenarios**
1. **Authentication Failure**: Invalid token or user ID
2. **Network Issues**: Cannot reach NCH
3. **Policy Set Issues**: Unavailable policy sets
4. **File Access**: Cannot read manifest files

### **Recovery Actions**
- Verify GitHub secrets
- Check NCH connectivity
- Review manifest file permissions
- Check NCTL installation

## 📝 **Customization Options**

### **Modifying Policy Sets**
```yaml
# In the workflow file, change the --policy-sets parameter
nctl scan repository \
  --policy-sets pss-baseline,dockerfile-best-practices \
  --policies manifests
```

### **Adding Custom Policies**
```yaml
# Add local policy files
nctl scan repository \
  --policy-sets pss-baseline \
  --policies manifests,./custom-policies
```

### **Changing Scan Triggers**
```yaml
# Modify the paths filter
on:
  push:
    paths:
      - 'manifests/**'
      - 'security/**'  # Add additional paths
```

## 🔍 **Monitoring and Debugging**

### **Workflow Logs**
- Check GitHub Actions logs for detailed output
- Review NCTL installation and authentication steps
- Monitor scan progress and results

### **NCH Integration**
- Verify scan results appear in NCH
- Check policy violation reports
- Monitor exception requests

### **Performance Metrics**
- Track scan duration
- Monitor violation trends
- Analyze policy coverage
