cat <<EOF > install-apache.sh
#!/bin/bash
DEPLOYMENT_VERSION="default-value"
yum update -y
yum install -y httpd
aws s3 cp s3://simplewebappbucket/my-webapp.war
echo "Downloaded Succesfully"
cp ./my-webapp.war /var/www/html/
echo "Copied Succesfully"
systemctl start httpd
echo "started Succesfully"
systemctl enable httpd
echo "Deployed Succesfully"
EOF
