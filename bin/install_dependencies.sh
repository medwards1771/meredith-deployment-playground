#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

# Set SSH_AUTH_SOCK so that ssh can find the buildkite-agent bind address
export SSH_AUTH_SOCK=/var/lib/buildkite-agent/.ssh/ssh-agent.sock

scp -r requirements.txt ubuntu@ec2-18-117-132-196.us-east-2.compute.amazonaws.com:meredith-deployment-playground/

echo "You are logged in as: $(whoami)"
echo "The current working directory is: $PWD"

ssh ubuntu@ec2-18-117-132-196.us-east-2.compute.amazonaws.com << 'EOF'
cd meredith-deployment-playground
python3 -m venv .venv
# shellcheck source=/dev/null
source .venv/bin/activate
python3 -m pip install -r requirements.txt
EOF