#Create CloudWatch dashboard to monitor the EC2 performance CPU,Memory
resource "aws_cloudwatch_dashboard" "ec2_dashboard" {
  dashboard_name = "iVolve-dashboard"
  dashboard_body = <<-JSON
  {
    "widgets": [
      {
        "type": "metric",
        "x": 0,
        "y": 0,
        "width": 6,
        "height": 6,
        "properties": {
          "metrics": [
            ["AWS/EC2", "CPUUtilization", "InstanceId", "${var.ec2_id}"],
            ["AWS/EC2", "MemoryUtilization", "InstanceId", "${var.ec2_id}"]
          ],
          "region": "${var.cloudwatch_region}",
          "title": "EC2 Metrics",
          "period": 300
        }
      }
    ]
  }
  JSON
}


#Create SNS to send mail
resource "aws_sns_topic" "cloudwatch_sns_topic" {
  name = "iVolve-sns"
}


#Configure SNS 
resource "aws_sns_topic_subscription" "cloudwatch_sns_subscription" {
  topic_arn = aws_sns_topic.cloudwatch_sns_topic.arn
  protocol  = "email"
  endpoint  = var.sns_email
}



#Set CloudWatch alarm for cpu
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_alarm" {
  alarm_name          = "iVolve-EC2CPUMetricAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarm when CPU utilization is greater than 80% for 2 periods"

  dimensions = {
    InstanceId = var.ec2_id
  }

  alarm_actions = [aws_sns_topic.cloudwatch_sns_topic.arn]
}


#Set CloudWatch alarm for memory
resource "aws_cloudwatch_metric_alarm" "ec2_memory_alarm" {
  alarm_name          = "iVolve-EC2MemoryMetricAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"  
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alarm when Memory utilization is greater than 80% for 2 periods"

  dimensions = {
    InstanceId = var.ec2_id
  }

  alarm_actions = [aws_sns_topic.cloudwatch_sns_topic.arn]
}
