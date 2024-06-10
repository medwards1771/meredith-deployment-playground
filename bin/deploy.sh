#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

# Set SSH_AUTH_SOCK so that ssh can find the buildkite-agent bind address
export SSH_AUTH_SOCK=/var/lib/buildkite-agent/.ssh/ssh-agent.sock

echo "Deploy changes to production"

scp -r flaskr ubuntu@ec2-18-117-132-196.us-east-2.compute.amazonaws.com:tmp/

ssh ubuntu@ec2-18-117-132-196.us-east-2.compute.amazonaws.com << 'EOF'
set -euo pipefail

mv tmp/flaskr meredith-deploy-playground/

sudo systemctl stop flaskr
sudo systemctl start flaskr
# Make this fail if the status is not OK
EOF