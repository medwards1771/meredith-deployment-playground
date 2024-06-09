#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

# Set SSH_AUTH_SOCK so that ssh can find the buildkite-agent bind address
export SSH_AUTH_SOCK=/var/lib/buildkite-agent/.ssh/ssh-agent.sock

scp -r requirements.txt ubuntu@ec2-18-117-132-196.us-east-2.compute.amazonaws.com:meredith-deploy-playground/

# connect to meredith-deploy-playground ec2 instance and run commands in EOF block
ssh ubuntu@ec2-18-117-132-196.us-east-2.compute.amazonaws.com << 'EOF'
set -euo pipefail

echo "The current working directory is: $PWD"
echo "You are logged in as: $(whoami)"

echo "Install flask and its dependencies on web server"
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools python3-venv


echo "Activate virtual environment"
cd meredith-deploy-playground
python3 -m venv .venv
# shellcheck source=/dev/null
source .venv/bin/activate

echo "Install flask app requirements with pip"
pip install -r requirements.txt
EOF