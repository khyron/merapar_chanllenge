# IAC Challenge. 

### HTML Page Serving Solution with Dynamic Content 

## Solution Overview 
The solution selected for the chanllenge is a serverless solution on AWS that serves an HTML page with dynamically configurable content. The architecture uses Infrastructure as Code (Terraform) to provision and manage all resources.

### Architecture Components
1. **AWS Lambda** - Python-based function that generates the HTML response
2. **API Gateway (HTTP API)** - Provides the public HTTPS endpoint
3. **SSM Parameter Store** - Stores the dynamic string value
4. **IAM Roles and Policies** - Secure access control between services
5. **Terraform Modules** - Reusable, maintainable infrastructure code

## How It Works

1. User accesses the API Gateway URL (same URL regardless of content)
2. API Gateway triggers the Lambda function
3. Lambda reads the dynamic string from SSM Parameter Store
4. Lambda generates HTML with the retrieved string
5. Response is returned through API Gateway to the user

```
├── main.tf                 # Root configuration
├── variables.tf            # Root variables
├── outputs.tf              # Root outputs
├── providers.tf            # AWS / Archive provider config
│
├── modules/
│   │
│   ├── archive/
│   │   ├── main.tf         # Creates Lambda zip
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── ssm/
│   │   ├── main.tf         # SSM Parameter Store
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── iam/
│   │   ├── main.tf         # IAM roles & policies
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── lambda/
│   │   ├── main.tf         # Lambda function
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── apigateway/
│       ├── main.tf         # API Gateway & permissions
│       ├── variables.tf
│       └── outputs.tf
│
└── lambda/                  # Python source code
    └── app.py               # Lambda handler
```


## Resource Dependency Graph
```
    ┌─────────────┐
    │   Archive   │
    │   Module    │
    └──────┬──────┘
           │
           │ lambda_zip_path
           │ lambda_zip_hash
           ▼
    ┌─────────────┐     ┌─────────────┐
    │     IAM     │     │     SSM     │
    │   Module    │     │   Module    │
    └──────┬──────┘     └──────┬──────┘
           │                   │
           │ role_arn          │ parameter_name
           ▼                   ▼
    ┌─────────────┐     ┌─────────────┐
    │   Lambda    │◄────┤   Lambda    │
    │   Module    │     │  (depends)  │
    └──────┬──────┘     └─────────────┘
           │
           │ invoke_arn
           │ function_name
           ▼
    ┌─────────────┐     ┌────────────────┐
    │ API Gateway │────►│  Permission    │
    │   Module    │     │ (auto-created) │
    └──────┬──────┘     └────────────────┘
           │
           │ api_url
           │ execution_arn
           ▼
    ┌─────────────┐
    │   Outputs   │
    └─────────────┘
```

## Deployment Workflow
```
┌─────────────────────────────────────────────────────────────────┐
│                      TERRAFORM APPLY                            │
│                                                                 │
│   ┌──────────────┐    ┌──────────────┐    ┌──────────────┐      │
│   │   terraform  │    │   terraform  │    │   terraform  │      │
│   │    init      │───►│    plan      │───►│    apply     │      │
│   └──────────────┘    └──────────────┘    └──────┬───────┘      │
│                                                  │              │
└─────────────────────────────────────────────────────────────────┘
                                                   │
                                                   ▼
┌───────────────────────────────────────────────────────────────────────┐
│                    AWS RESOURCE CREATION ORDER                        │
│                                                                       │
│   ┌─────────────────────────────────────────────────────────┐         │
│   │  STEP 1: Archive Module                                 │         │
│   │  └── Creates lambda.zip from Python code                │         │
│   └─────────────────────────────────────────────────────────┘         │
│                              │                                        │
│                              ▼                                        │
│   ┌─────────────────────────────────────────────────────────┐         │
│   │  STEP 2: IAM Module                                     │         │
│   │  └── Creates IAM role for Lambda                        │         │
│   └─────────────────────────────────────────────────────────┘         │
│                              │                                        │
│                              ▼                                        │
│   ┌─────────────────────────────────────────────────────────┐         │
│   │  STEP 3: SSM Module                                     │         │
│   │  └── Creates SSM parameter for dynamic string           │         │
│   └─────────────────────────────────────────────────────────┘         │
│                              │                                        │
│                              ▼                                        │
│   ┌─────────────────────────────────────────────────────────┐         │
│   │  STEP 4: Lambda Module                                  │         │
│   │  ├── Uploads code from archive                          │         │
│   │  ├── Attaches IAM role                                  │         │
│   │  └── Injects SSM parameter name as env var              │         │
│   └─────────────────────────────────────────────────────────┘         │
│                              │                                        │
│                              ▼                                        │
│   ┌─────────────────────────────────────────────────────────┐         │
│   │  STEP 5: API Gateway Module                             │         │
│   │  ├── Creates HTTP API                                   │         │
│   │  ├── Creates integration to Lambda                      │         │
│   │  ├── Sets up route (GET /)                              │         │
│   │  ├── Creates deployment stage                           │         │
│   │  └── CREATES LAMBDA PERMISSION (auto)                   │         │
│   └─────────────────────────────────────────────────────────┘         │
│                              │                                        │
│                              ▼                                        │
│   ┌───────────────────────────────────────────────────────────────┐   │
│   │  FINAL OUTPUT                                                 │   │
│   │  └── api_url = https://xxxx.execute-api.region.amazonaws.com  │   │
│   └───────────────────────────────────────────────────────────────┘   │
└───────────────────────────────────────────────────────────────────────┘
```
### Decision Making

**Cloud Platform Choice: AWS**

* AWS offers the most mature serverless ecosystem
* Extensive Terraform provider support
* Free tier eligible for demonstration purposes
* Industry standard, widely adopted

**Compute Service: Lambda**

* Cost-effective: Pay only per request, no idle costs
* Scalability: Automatic scaling, no configuration needed
* Maintenance: No server management, patching, or capacity planning
* Simplicity: Focus on code, not infrastructure
* Perfect for: Lightweight HTTP responses, ideal for this use case

**API Layer: API Gateway HTTP API**

* Lower cost: ~70% cheaper than REST API 
* Lower latency: Optimized for simple proxy use cases
* Simpler: Fewer features = easier to configure
* Native Lambda integration
* Automatic deployments

**Configuration Storage: SSM Parameter Store**

* No re-deployment required: Parameter changes don't need code deployment
* Serverless: Fully managed, no infrastructure to maintain
* Cost-effective: Free tier eligible
* Simple API: Easy to integrate with Lambda
* Versioning: Built-in parameter version history


**Module Structure Design**

* Reusability: Modules can be used in other projects
* Separation of concerns: Each module has clear responsibility
* Testability: Modules can be tested independently
* Maintainability: Easier to update and debug
* Team collaboration: Multiple people can work on different modules
* Standardization: Enforces best practices across modules

**Lambda Runtime : Python**

* Simplicity: Python is easy to read and write
* AWS SDK: boto3 support
* Cold starts: Reasonable cold start times
* String handling: Excellent for HTML string manipulation
* SSM integration: Simple parameter store client

  

# How to Modify the Dynamic String
### AWS Console

Go to AWS Systems Manager > Parameter Store  
Find /challenge/dynamic_string  
Click "Edit" and change the value  
Save changes  
Refresh the API endpoint - content updates immediately  

## AWS CLI
```# Update the parameter
aws ssm put-parameter \
  --name "/challenge/dynamic_string" \
  --value "your new value" \
  --type String \
  --overwrite
  ```
## Test the endpoint
`curl $(terraform output -raw api_url)`

# Deployment Instructions

```
# Initialize Terraform
terraform init

# Review the plan
terraform plan -out=tfplan.out

# Deploy infrastructure
terraform apply tfplan.out

# Get the API URL
terraform output api_url

# Test it
curl $(terraform output -raw api_url)
```




# Future Enhancements
 

## Security Enhancements

* Add AWS WAF for DDoS protection and IP-based filtering  
* Require API keys for access  
* Add HTTPS with custom domain and SSL certificate  
* Restrict access to specific VPC or IP ranges  
* Definition of Security groups / networks 


## Performance Optimizations

* CloudFront CDN
* Lambda Reserved Concurrency
* Response Caching
* Lambda SnapStart (to improve cold starts)

## Monitoring and Observability

* CloudWatch Dashboards
* Set up alarms for errors and latency
* Enhanced structured logging with CloudWatch Logs Insights
* SLA Monitoring (External uptime monitoring)

## CI/CD Pipeline

* Automated testing on PR (GitHub Actions)
* Blue/Green Deployments
* Automated API testing after deployment
* Security Scanning for IaC security

## Multi-Environment Support

* Separate environments with variable promotion (Dev/QA/UAT/Prod)
* Environment-specific domains - api.dev.example.com, api.prod.example.com
* Separate SSM parameters per environment


## Enhanced Dynamic Content

* Input validation and sanitization

## Infrastructure Improvements

* Store Terraform state in S3 with DynamoDB locking
* Terragrunt to reduce code duplication across environments
* Lambda power tuning for optimal cost/performance
* Configure API Gateway throttling and burst limits (Auto-scaling)

## Disaster Recovery

* Multi-region
* Route53 Failover
* Backup Parameter Store
* Recovery Automation