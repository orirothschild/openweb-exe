#!/bin/bash

# Check if the IP address is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <LOAD_BALANCER_IP>"
  exit 1
fi

LOAD_BALANCER_IP=$1
DOMAIN="tools.devops-openweb.com/todo"

# Backup the current /etc/hosts file
sudo cp /etc/hosts /etc/hosts.bak

# Check if the domain already exists in /etc/hosts
if grep -q "$DOMAIN" /etc/hosts; then
  echo "Updating existing entry for $DOMAIN in /etc/hosts"
  # Update the existing entry
  sudo sed -i "/$DOMAIN/c\\$LOAD_BALANCER_IP $DOMAIN" /etc/hosts
else
  echo "Adding new entry for $DOMAIN in /etc/hosts"
  # Append the new entry
  echo "$LOAD_BALANCER_IP $DOMAIN" | sudo tee -a /etc/hosts
fi

echo "The /etc/hosts file has been updated successfully."
