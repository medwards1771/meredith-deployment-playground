#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

export SSH_AUTH_SOCK=/var/lib/buildkite-agent/.ssh/ssh-agent.sock

echo "Deploy changes to production"
scp index.html ubuntu@ec2-18-117-132-196.us-east-2.compute.amazonaws.com:/usr/share/nginx/html/index.html