variable "ec2_id" {
  description = "EC2 instance ID to monitor"
  type        = string
}


variable "cloudwatch_region" {
  description = "Region of CloudWatch"
  type        = string  
}


variable "sns_email" {
  description = "email that will recieve mails from SNS"
  type        = string  
}
