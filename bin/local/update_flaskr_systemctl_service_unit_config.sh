#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

scp bin/flaskr.service ubuntu@ec2-18-117-132-196.us-east-2.compute.amazonaws.com:/tmp/flaskr.service

# connect to meredith-deploy-playground ec2 instance and run commands in EOF block
ssh ubuntu@ec2-18-117-132-196.us-east-2.compute.amazonaws.com << 'EOF'
set -euo pipefail

echo "Move systemd unit file to Ubuntu init system"
sudo mv /tmp/flaskr.service /etc/systemd/system/flaskr.service

echo "stop flaskr, reload daemons, start flaskr, and enable flaskr since flaskr.service file changed on disk"
sudo systemctl stop flaskr
sudo systemctl daemon-reload
sudo systemctl start flaskr
sudo systemctl enable flaskr

echo "Check flaskr service status"
sudo systemctl status flaskr
EOF