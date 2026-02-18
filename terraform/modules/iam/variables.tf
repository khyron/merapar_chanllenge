variable "role_name" {
  description = "IAM role name"
  type        = string
}

variable "policy_arns" {
  description = "List of policy ARNs to attach to the role"
  type        = list(string)
}
