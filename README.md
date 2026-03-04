# Azure DevOps CI/CD Pipeline with Terraform & Automated Testing

This project demonstrates a complete CI/CD pipeline using Azure DevOps, Terraform for infrastructure provisioning, and comprehensive automated testing with Postman, JMeter, and Selenium.

## 📋 Table of Contents

- [Architecture Overview](#architecture-overview)
- [Prerequisites](#prerequisites)
- [Infrastructure Components](#infrastructure-components)
- [Test Suites](#test-suites)
- [Setup Instructions](#setup-instructions)
- [Pipeline Configuration](#pipeline-configuration)
- [Log Analytics Integration](#log-analytics-integration)
- [Running Tests Locally](#running-tests-locally)

## 🏗️ Architecture Overview

### Infrastructure (Terraform)
- **Resource Group**: Container for all Azure resources
- **Virtual Network**: Network with 10.5.0.0/16 CIDR
- **Network Security Group**: Security rules for SSH (22) and App (5000)
- **Public IP**: Dynamic public IP for VM
- **App Service**: Free tier (F1) for hosting FakeRestAPI
- **Virtual Machine**: Ubuntu 18.04 LTS (Standard_B1s)
- **Log Analytics Workspace**: Centralized logging with 30-day retention

### Testing Layers
1. **Integration Tests** (Postman): API functional testing
2. **Performance Tests** (JMeter): Stress and endurance testing
3. **UI Tests** (Selenium): Functional UI automation

## 🔧 Prerequisites

### Required Tools
- **Terraform**: v1.0.0 or higher
- **Azure CLI**: Latest version
- **Python**: 3.7.6 or higher
- **Node.js**: 14.x (for Newman/Postman CLI)
- **Java**: JDK 8+ (for JMeter)

### Azure Resources
- Active Azure subscription
- Azure DevOps organization and project
- Azure service connection in Azure DevOps
- Storage account for Terraform state (backend)

### Environment Variables
```bash
# Azure Authentication
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_TENANT_ID="your-tenant-id"

# Log Analytics (for local log upload)
export LOG_ANALYTICS_WORKSPACE_ID="your-workspace-id"
export LOG_ANALYTICS_SHARED_KEY="your-shared-key"
```

## 🏛️ Infrastructure Components

### Terraform Modules

#### Resource Group
```hcl
module.resource_group
├── Location: East US (configurable)
└── Name: myResourceGroup (from tfvars)
```

#### Network
```hcl
module.network
├── Virtual Network: 10.5.0.0/16
├── Subnet: 10.5.1.0/24
└── Network Interface for VM
```

#### App Service
```hcl
module.appservice
├── App Service Plan: Free (F1 tier)
├── App Service: Hosts FakeRestAPI
└── Outputs: name, hostname, id
```

#### Virtual Machine
```hcl
module.vm
├── OS: Ubuntu 18.04 LTS
├── Size: Standard_B1s
├── Admin User: adminuser (SSH key auth)
└── Network: Connected to subnet
```

#### Log Analytics
```hcl
module.loganalytics
├── SKU: PerGB2018
├── Retention: 30 days
└── Outputs: workspace_id, shared_key
```

## 🧪 Test Suites

### 1. Postman Integration Tests

**Location**: `automatedtesting/postman/`

**Test Collection**: `StarterAPIs.json`
- **Data Validation Tests** (6 tests)
  - Create, Read, Update, Delete operations for Activities, Books, Authors
  - Response status code validation
  - Response body schema validation
  
- **Regression Tests** (7 tests)
  - GET all items with pagination
  - Search functionality
  - Invalid ID handling
  - Backward compatibility checks

**Environment**: `TestEnvironment.json`
```json
{
  "baseUrl": "https://your-app-service.azurewebsites.net"
}
```

**Run Locally**:
```bash
cd automatedtesting/postman
npm install -g newman
newman run StarterAPIs.json -e TestEnvironment.json
```

### 2. JMeter Performance Tests

**Location**: `automatedtesting/jmeter/`

#### Stress Test (`StressTest.jmx`)
- **Load**: 50 concurrent users (30 Activities + 20 Books)
- **Duration**: 60 seconds
- **Endpoints**: 6 API endpoints
- **Ramp-up**: 10 seconds
- **Purpose**: Test system under high load

#### Endurance Test (`EnduranceTest.jmx`)
- **Load**: 18 concurrent users (10 Activities + 8 Books/Authors)
- **Duration**: 300+ seconds (configurable)
- **Endpoints**: 8 API endpoints
- **Ramp-up**: 30 seconds
- **Purpose**: Test system stability over time

**Run Locally**:
```bash
cd automatedtesting/jmeter

# Stress Test
jmeter -n -t StressTest.jmx \
  -JBASE_URL=https://your-app.azurewebsites.net \
  -l stress-results.jtl \
  -e -o stress-report/

# Endurance Test
jmeter -n -t EnduranceTest.jmx \
  -JBASE_URL=https://your-app.azurewebsites.net \
  -JDURATION=300 \
  -l endurance-results.jtl \
  -e -o endurance-report/
```

### 3. Selenium UI Tests

**Location**: `automatedtesting/selenium/`

**Test Script**: `login.py`

**Test Cases**:
1. `test_successful_login()`: Valid credentials login
2. `test_invalid_login()`: Invalid credentials handling
3. `test_locked_user()`: Locked user account handling
4. `test_add_to_cart()`: Add product to cart workflow

**Logging**:
- Timestamped log files in `log/` directory
- Format: `selenium-test-YYYYMMDD-HHMMSS.log`
- Levels: INFO for test execution, ERROR for failures

**Run Locally**:
```bash
cd automatedtesting/selenium
pip install selenium

# With browser UI
python3 login.py

# Headless mode
export HEADLESS=1
python3 login.py
```

## 🚀 Setup Instructions

### 1. Clone Repository
```bash
git clone <repository-url>
cd "Project Starter Resources"
```

### 2. Configure Terraform Variables

**File**: `terraform/terraform.tfvars`
```hcl
# Azure Authentication
subscription_id = "your-subscription-id"
client_id       = "your-client-id"
client_secret   = "your-client-secret"
tenant_id       = "your-tenant-id"

# Resource Configuration
location            = "East US"
resource_group      = "myResourceGroup"
application_type    = "myApplication"
virtual_network_name = "myApplication-vnet"
address_space       = ["10.5.0.0/16"]
address_prefix_test = "10.5.1.0/24"

# VM Configuration
admin_username      = "adminuser"

# Log Analytics
workspace_name      = "myApplication-log-analytics"
```

### 3. Configure Terraform Backend

**File**: `terraform/main.tf`
```hcl
terraform {
  backend "azurerm" {
    storage_account_name = "your-tfstate-storage"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    access_key           = "your-storage-access-key"
  }
}
```

### 4. Generate SSH Key for VM

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_azure -N ""
```

Place the public key in `terraform/modules/vm/id_rsa.pub`

### 5. Initialize Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## ⚙️ Pipeline Configuration

### Azure DevOps Setup

#### 1. Create Service Connection
- Navigate to **Project Settings** → **Service connections**
- Create new **Azure Resource Manager** connection
- Name it (e.g., `myServiceConnection`)
- Select subscription and resource group

#### 2. Update Pipeline Variables

**File**: `azure-pipelines.yaml`

Update the following variables:
```yaml
variables:
  azureServiceConnection: 'myServiceConnection'  # Your service connection name
  resourceGroup: 'myResourceGroup'               # Your resource group
  location: 'East US'                            # Your Azure region
  terraformVersion: '1.0.0'                      # Terraform version
```

#### 3. Create Pipeline
- Go to **Pipelines** → **New Pipeline**
- Select your repository
- Choose **Existing Azure Pipelines YAML file**
- Select `azure-pipelines.yaml`
- Save and run

### Pipeline Stages

The pipeline consists of 7 stages:

1. **ProvisionInfrastructure**: Deploy Azure resources with Terraform
2. **Build**: Build and archive FakeRestAPI and test artifacts
3. **Deploy**: Deploy FakeRestAPI to App Service
4. **IntegrationTest**: Run Postman API tests
5. **PerformanceTest**: Run JMeter stress and endurance tests
6. **UITest**: Run Selenium functional tests and upload logs
7. **DestroyInfrastructure**: (Optional) Tear down infrastructure

### Pipeline Features

- ✅ Parallel job execution for performance tests
- ✅ Test results publishing (JUnit format)
- ✅ Artifact publishing for all test reports and logs
- ✅ Conditional infrastructure destruction
- ✅ Automatic Log Analytics ingestion
- ✅ Cross-stage variable passing for dynamic configuration

## 📊 Log Analytics Integration

### Selenium Log Ingestion

The pipeline automatically uploads Selenium test logs to Azure Log Analytics after each test run.

#### Upload Script

**Location**: `automatedtesting/selenium/upload_logs_to_azure.py`

**Features**:
- Parses timestamped log files
- Converts logs to JSON format
- Uses Azure Log Analytics Data Collector API
- Supports environment variable configuration
- Handles multiple log formats

**Environment Variables**:
```bash
LOG_ANALYTICS_WORKSPACE_ID="your-workspace-id"
LOG_ANALYTICS_SHARED_KEY="your-shared-key"
LOG_TYPE="SeleniumTest"  # Optional, creates SeleniumTest_CL table
```

#### Querying Logs in Azure Portal

Navigate to **Log Analytics Workspace** → **Logs** and run:

```kusto
// View recent Selenium test logs
SeleniumTest_CL
| where TimeGenerated > ago(1h)
| order by TimeGenerated desc

// Filter by test level
SeleniumTest_CL
| where Level == "ERROR"
| project TimeGenerated, Message, Source

// Summarize tests by status
SeleniumTest_CL
| summarize Count=count() by Level
| render piechart
```

#### Manual Log Upload

```bash
cd automatedtesting/selenium

# Set environment variables
export LOG_ANALYTICS_WORKSPACE_ID="your-workspace-id"
export LOG_ANALYTICS_SHARED_KEY="your-shared-key"

# Upload specific log file
python3 upload_logs_to_azure.py log/selenium-test-20240101-120000.log

# Upload latest log file (automatic detection)
python3 upload_logs_to_azure.py
```

## 🔬 Running Tests Locally

### Prerequisites

Install required dependencies:

```bash
# Python dependencies
pip install selenium requests

# Node.js dependencies (Newman)
npm install -g newman newman-reporter-junitfull

# Download JMeter
wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.4.1.tgz
tar -xzf apache-jmeter-5.4.1.tgz
```

### Run All Tests

```bash
# Set App Service URL
export APP_URL="https://your-app.azurewebsites.net"

# Run Postman tests
cd automatedtesting/postman
newman run StarterAPIs.json \
  --env-var "baseUrl=$APP_URL" \
  -r cli,junitfull

# Run JMeter Stress Test
cd ../jmeter
./apache-jmeter-5.4.1/bin/jmeter -n \
  -t StressTest.jmx \
  -JBASE_URL=$APP_URL \
  -l stress-results.jtl \
  -e -o stress-report/

# Run Selenium tests
cd ../selenium
export HEADLESS=1
python3 login.py

# Upload logs to Azure
export LOG_ANALYTICS_WORKSPACE_ID="your-workspace-id"
export LOG_ANALYTICS_SHARED_KEY="your-shared-key"
python3 upload_logs_to_azure.py
```

## 📁 Project Structure

```
Project Starter Resources/
├── azure-pipelines.yaml          # Azure DevOps pipeline definition
├── StarterAPIs.json              # Legacy API collection
├── README.md                     # This file
├── automatedtesting/
│   ├── jmeter/
│   │   ├── Starter.jmx          # Legacy JMeter file
│   │   ├── StressTest.jmx       # High-load stress test
│   │   ├── EnduranceTest.jmx    # Extended duration test
│   │   └── fakerestapi/         # FakeRestAPI application
│   ├── postman/
│   │   ├── StarterAPIs.json     # Postman test collection (13 tests)
│   │   └── TestEnvironment.json # Environment variables
│   └── selenium/
│       ├── login.py             # Selenium test suite (4 tests)
│       ├── upload_logs_to_azure.py  # Log Analytics upload script
│       └── log/                 # Generated log files
└── terraform/
    ├── main.tf                  # Main Terraform configuration
    ├── input.tf                 # Input variables
    ├── terraform.tfvars         # Variable values (sensitive)
    ├── output.tf                # Output values
    └── modules/
        ├── resource_group/      # Resource group module
        ├── network/             # VNet and subnet module
        ├── networksecuritygroup/ # NSG module
        ├── publicip/            # Public IP module
        ├── appservice/          # App Service module
        ├── vm/                  # Virtual Machine module
        └── loganalytics/        # Log Analytics module
```

## 🔒 Security Considerations

1. **Sensitive Data**: Never commit `terraform.tfvars` to version control
2. **SSH Keys**: Store SSH keys securely, use Azure Key Vault
3. **Service Connections**: Use managed identities when possible
4. **Secrets**: Store secrets in Azure DevOps Library or Key Vault
5. **NSG Rules**: Review and restrict network access as needed

## 🐛 Troubleshooting

### Terraform Issues

**Error**: "Backend configuration not found"
```bash
# Solution: Configure backend in main.tf or use local backend
terraform init -reconfigure
```

**Error**: "Permission denied (publickey)"
```bash
# Solution: Verify SSH key is correctly placed
cat terraform/modules/vm/id_rsa.pub
```

### Pipeline Issues

**Error**: "Service connection not found"
- Verify service connection name in pipeline variables
- Check service connection has proper permissions

**Error**: "No hosted parallelism available"
- Request free tier parallelism from Microsoft
- Or use self-hosted agents

### Test Issues

**Selenium**: "ChromeDriver version mismatch"
```bash
# Solution: Update ChromeDriver to match Chrome version
CHROME_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d'.' -f1)
wget https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION
```

**JMeter**: "Out of memory"
```bash
# Solution: Increase JMeter heap size
export JVM_ARGS="-Xms512m -Xmx2048m"
```

## 📈 Monitoring and Alerts

### Azure Monitor

Set up alerts for:
- App Service response time > 3 seconds
- App Service CPU > 80%
- VM CPU > 90%
- Log Analytics data ingestion failures

### Log Analytics Queries

```kusto
// Failed Selenium tests
SeleniumTest_CL
| where Level == "ERROR"
| summarize FailureCount=count() by bin(TimeGenerated, 1h)
| render timechart

// Performance metrics
AppServiceHTTPLogs
| where TimeGenerated > ago(1d)
| summarize AvgResponseTime=avg(TimeTaken) by bin(TimeGenerated, 5m)
| render timechart
```

## 📚 Additional Resources

- [Azure DevOps Documentation](https://docs.microsoft.com/en-us/azure/devops/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Newman CLI Documentation](https://learning.postman.com/docs/running-collections/using-newman-cli/command-line-integration-with-newman/)
- [Apache JMeter Documentation](https://jmeter.apache.org/usermanual/index.html)
- [Selenium Python Documentation](https://selenium-python.readthedocs.io/)
- [Azure Log Analytics REST API](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/data-collector-api)

## 📝 License

This project is for educational purposes as part of Azure DevOps training.

## 👥 Contributing

Contributions are welcome! Please follow these steps:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

**Last Updated**: 2024
**Version**: 1.0.0
