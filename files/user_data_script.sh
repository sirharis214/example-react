#!/bin/bash

# Function to check and handle errors
check_error() {
    if [ $? -ne 0 ]; then
        echo "Error occurred. Exiting script."
        exit 1
    fi
}

# Update the system and install necessary packages
sudo yum update
check_error

sudo yum -y install nginx
check_error

sudo service nginx start

sudo yum install https://rpm.nodesource.com/pub_21.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y
check_error

sudo yum install nodejs -y --setopt=nodesource-nodejs.module_hotfixes=1
check_error

sudo yum -y install git
check_error

# Clone the repository
cd /home/ec2-user
git clone -b feature/init https://github.com/sirharis214/example-react
check_error

cd /home/ec2-user/example-react/example-app/

# Install npm packages and build
sudo npm install
check_error

sudo npm run build
check_error

# Create directory and copy build files
sudo mkdir -p /var/www/build
check_error

sudo cp -r /home/ec2-user/example-react/example-app/build/* /var/www/build/
check_error

# Check if the www-data user exists
if id "www-data" >/dev/null 2>&1; then
    echo "www-data user exists."
else
    # Create the www-data user
    sudo adduser --system --no-create-home www-data
    echo "www-data user created."
fi

# Set ownership for the directory
sudo chown -R www-data:www-data /var/www/build
check_error

# Define the content for the react.conf file
CONFIG_CONTENT="server {
    listen 80;

    location / {
        root /var/www/build;
        index index.html;
        try_files \$uri \$uri/ /index.html;
    }
}"

# Define the path to the Nginx conf.d directory
NGINX_CONF_DIR="/etc/nginx/conf.d"
CONFIG_FILE="$NGINX_CONF_DIR/react.conf"

# Check if the react.conf file exists
if [ -e "$CONFIG_FILE" ]; then
    # Update the content of the existing file
    echo "$CONFIG_CONTENT" | sudo tee "$CONFIG_FILE" > /dev/null
    echo "The content of react.conf has been updated."
else
    # Create the react.conf file if it doesn't exist
    echo "$CONFIG_CONTENT" | sudo tee "$CONFIG_FILE" > /dev/null
    echo "The react.conf file has been created at $NGINX_CONF_DIR."
fi

# Reload Nginx
sudo service nginx reload
check_error

echo "Script executed successfully."
