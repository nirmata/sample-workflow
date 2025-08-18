# NCTL Manifest Security Scan Workflow

This GitHub Actions workflow automatically scans Kubernetes manifests, Dockerfiles, and Terraform files in the `manifests/` folder against Kyverno security policies and exports the results to Nirmata Control Hub (NCH).

## 🎯 **Purpose**

The workflow scans manifest files against three key policy sets:
- **PSS-Baseline**: Pod Security Standards baseline policies
- **PSS-Restricted**: Pod Security Standards restricted policies  
- **RBAC-Best-Practices**: Role-Based Access Control best practices

## 🚀 **Features**

### **Automated Scanning**
- Triggers on pushes/PRs to `manifests/` folder
- Manual trigger with policy set selection
- Comprehensive policy violation detection

### **NCH Integration**
- Automatic results export to Nirmata Control Hub
- Direct links to violation reports
- Policy exception creation workflow
- AI-powered remediation suggestions

### **GitHub Integration**
- PR comments with scan results
- Workflow failure on critical violations
- Detailed scan reports and artifacts

## 📋 **Prerequisites**

### **Required GitHub Secrets**
Set these secrets in your repository settings (`Settings > Secrets and variables > Actions`):

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `NIRMATA_TOKEN` | Your Nirmata API access token | `DGJqPuqOpt...` |
| `NIRMATA_URL` | Nirmata Control Hub URL | `https://www.nirmata.io` |
| `NIRMATA_USERID` | Your Nirmata user email | `user@example.com` |

### **Repository Structure**
Ensure your repository has a `manifests/` folder containing:
```
manifests/
├── kubernetes/          # Kubernetes YAML files
│   ├── *.yaml
│   └── *.yml
├── docker/              # Dockerfile files
│   └── Dockerfile*
├── terraform/           # Terraform files
│   └── *.tf
└── README.md
```

## 🔧 **Setup Instructions**

### **1. Add the Workflow File**
Copy the `nctl-manifest-scan.yaml` file to `.github/workflows/` in your repository.

### **2. Configure GitHub Secrets**
1. Go to your repository → `Settings` → `Secrets and variables` → `Actions`
2. Add the three required secrets listed above
3. Ensure the secrets are accessible to the workflow

### **3. Verify Repository Structure**
Ensure your `manifests/` folder contains the files you want to scan.

### **4. Test the Workflow**
- Push changes to the `manifests/` folder, or
- Use the manual trigger (`workflow_dispatch`) from the Actions tab

## 📊 **Workflow Triggers**

### **Automatic Triggers**
- **Push**: Any commit to `main`, `master`, or `develop` branches that modifies `manifests/**`
- **Pull Request**: Any PR targeting `main`, `master`, or `develop` that modifies `manifests/**`

### **Manual Trigger**
- **Workflow Dispatch**: Manual execution with policy set selection
  - `all`: Scan with all policy sets (default)
  - `pss-baseline`: Only PSS baseline policies
  - `pss-restricted`: Only PSS restricted policies
  - `rbac-best-practices`: Only RBAC policies

## 🔍 **Scan Process**

### **1. Environment Setup**
- Checkout repository code
- Install NCTL scan tool
- Authenticate with Nirmata Control Hub

### **2. Policy Scanning**
- Scan all files in `manifests/` folder
- Apply PSS and RBAC policy sets
- Generate comprehensive violation report

### **3. Results Processing**
- Parse scan output for violations
- Generate summary report
- Export results to NCH
- Create PR comments (if applicable)

## 📈 **Output and Results**

### **GitHub Actions Summary**
- Scan summary with policy and violation counts
- Detailed violation information
- NCH integration links

### **Artifacts**
- `scan-results.txt`: Complete scan output
- `.nctl/`: NCTL configuration and cache files

### **NCH Integration**
- **View Violations**: Direct link to policy violation reports
- **Create Exceptions**: Request policy exceptions for legitimate violations
- **View Remediations**: Access AI-powered remediation suggestions

## 🔗 **NCH Links**

After each scan, the workflow provides three direct links:

### **1. View Policy Violations**
```
https://www.nirmata.io/webclient/#clusters/policyReport/repositoryDetails?repo=<repo-url>&backurl=clustersPolicyReport
```

### **2. Create Policy Exception**
```
https://www.nirmata.io/webclient/#clusters/policyReport/repositoryDetails?repo=<repo-url>&backurl=clustersPolicyReport
```

### **3. View Remediations**
```
https://www.nirmata.io/webclient/#clusters/policyReport/repositoryDetails?repo=<repo-url>&backurl=clustersPolicyReport
```

## ⚠️ **Policy Violations**

### **PSS-Baseline Violations**
Common violations include:
- Running containers as root
- Using privileged containers
- Mounting sensitive host paths
- Using dangerous capabilities

### **PSS-Restricted Violations**
Stricter policies including:
- No privileged containers
- No host network/process namespace
- Read-only root filesystem
- No dangerous capabilities

### **RBAC Violations**
Access control issues such as:
- Overly permissive ClusterRoles
- Excessive permissions
- Missing namespace restrictions
- Insecure ServiceAccount configurations

## 🚨 **Workflow Failure**

The workflow will fail if:
- Critical security violations are detected
- NCTL authentication fails
- Required secrets are missing
- Repository structure is invalid

## 🔧 **Troubleshooting**

### **Common Issues**

#### **Authentication Failures**
- Verify `NIRMATA_TOKEN` is valid and not expired
- Check `NIRMATA_URL` is correct
- Ensure `NIRMATA_USERID` matches your NCH account

#### **Scan Failures**
- Check `manifests/` folder structure
- Verify files have correct extensions (`.yaml`, `.yml`, `.tf`, `Dockerfile*`)
- Review NCTL installation logs

#### **Missing Results**
- Check workflow artifacts
- Verify NCH integration is working
- Review scan output logs

### **Debug Information**
The workflow includes comprehensive debugging:
- NCTL environment verification
- Policy set availability
- File discovery and scanning
- Detailed error reporting

## 📚 **Additional Resources**

- [Nirmata Documentation](https://docs.nirmata.io/)
- [NCTL Installation Guide](https://downloads.nirmata.io/nctl/downloads/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Kyverno Policies](https://github.com/nirmata/kyverno-policies)

## 🤝 **Support**

For issues with:
- **Workflow execution**: Check GitHub Actions logs
- **NCTL functionality**: Review Nirmata documentation
- **Policy violations**: Use NCH integration links
- **NCH access**: Contact your Nirmata administrator

## 📝 **Changelog**

### **v1.0.0**
- Initial workflow implementation
- PSS and RBAC policy scanning
- NCH integration and reporting
- PR comment automation
- Comprehensive error handling
