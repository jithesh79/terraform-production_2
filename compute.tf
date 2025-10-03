resource "aws_launch_template" "app_lt" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  key_name      = var.key_name
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }
  network_interfaces {
    security_groups = [aws_security_group.ec2_sg.id]
    associate_public_ip_address = false
  }

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install nginx1 -y
systemctl enable nginx
systemctl start nginx
echo "<h1>${var.project_name} running on \$(hostname)</h1>" > /usr/share/nginx/html/index.html
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-ec2"
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  name                      = "${var.project_name}-asg"
  min_size                  = var.asg_min
  max_size                  = var.asg_max
  desired_capacity           = var.asg_desired
  vpc_zone_identifier       = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  health_check_type         = "EC2"
  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.tg.arn]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-ec2"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_lb.this]
}
