#!/bin/bash


export AWS_DEFAULT_REGION=us-east-2


# create EC2 instance
aws ec2 run-instances \
    --image-id ami-01e39fec38ed82bc1 \
    --count 1 \
    --instance-type t2.micro \
    --key-name Jenkins2-Key-Pair \
    --user-data $(DEPLOYMENT_VERSION="default-value"
                    yum update -y
                    yum install -y httpd
                    aws s3 cp s3://simplewebappbucket/my-webapp.war
                    echo "Downloaded Succesfully"
                    cp ./my-webapp.war /var/www/html/
                    echo "Copied Succesfully"
                    systemctl start httpd
                    echo "started Succesfully"
                    systemctl enable httpd
                    echo "Deployed Succesfully")
   # --user-data "$USER_DATA_BASE64" \
    #--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=MyApacheServer}]'

# create target group
aws elbv2 create-target-group \
    --name my-targets \
    --protocol HTTP \
    --port 80 \
    --target-type instance \
    --vpc-id vpc-009aa2f325fd297d1
    
     # register target group
    aws elbv2 register-targets \
    --target-group-arn arn:aws:elasticloadbalancing:us-east-2:590183815392:targetgroup/my-targets/c1d2b1b0754f535c \
    --targets Id=i-060698fe224b7be6e Id=i-060698fe224b7be6e
    

    #create load balancer

    aws elbv2 create-load-balancer --name my-load-balancer  \
--subnets subnet-04b311b955ec3aa0a subnet-0cc0f4e901dc45c10 --security-groups sg-0b23907abc15b2290

   
    # create listener
    aws elbv2 create-listener --load-balancer-arn arn:aws:elasticloadbalancing:us-east-2:590183815392:loadbalancer/app/my-load-balancer/2a136064ae62ffb7 \
--protocol HTTP --port 80  \
--default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:us-east-2:590183815392:targetgroup/my-targets/c1d2b1b0754f535c
 
    
