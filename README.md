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

### Decision Making

**Cloud Platform Choice: AWS**

- AWS offers the most mature serverless ecosystem
- Extensive Terraform provider support
- Free tier eligible for demonstration purposes
- Industry standard, widely adopted

**Compute Service: Lambda**

- Cost-effective: Pay only per request, no idle costs
- Scalability: Automatic scaling, no configuration needed
- Maintenance: No server management, patching, or capacity planning
- Simplicity: Focus on code, not infrastructure
- Perfect for: Lightweight HTTP responses, ideal for this use case

**API Layer: API Gateway HTTP API**

- Lower cost: ~70% cheaper than REST API 
- Lower latency: Optimized for simple proxy use cases
- Simpler: Fewer features = easier to configure
- Native Lambda integration
- Automatic deployments

**Configuration Storage: SSM Parameter Store**

- No re-deployment required: Parameter changes don't need code deployment
- Serverless: Fully managed, no infrastructure to maintain
- Cost-effective: Free tier eligible
- Simple API: Easy to integrate with Lambda
- Versioning: Built-in parameter version history


**Module Structure Design**

- Reusability: Modules can be used in other projects
- Separation of concerns: Each module has clear responsibility
- Testability: Modules can be tested independently
- Maintainability: Easier to update and debug
- Team collaboration: Multiple people can work on different modules
- Standardization: Enforces best practices across modules

**Lambda Runtime : Python**

- Simplicity: Python is easy to read and write
- AWS SDK: boto3 support
- Cold starts: Reasonable cold start times
- String handling: Excellent for HTML string manipulation
- SSM integration: Simple parameter store client

  

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