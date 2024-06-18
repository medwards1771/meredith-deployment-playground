#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`	        Expand and print each command before executing
# `o pipefail`	Ensure Bash pipelines (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

# Set SSH_AUTH_SOCK so that ssh can find the buildkite-agent bind address
export SSH_AUTH_SOCK=/var/lib/buildkite-agent/.ssh/ssh-agent.sock

echo "Deploy changes to production"

# something seems a lil weird about using EOF to run scripts on nginx instance. look into alternatives, princess!
ssh ubuntu@ec2-18-117-132-196.us-east-2.compute.amazonaws.com << 'EOF'
set -euxo pipefail

docker compose up --detach --pull always web
EOF
# ssh'd onto instance running nginx, ran `docker login` there to log in to Docker