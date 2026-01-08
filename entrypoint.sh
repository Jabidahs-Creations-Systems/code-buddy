#!/bin/bash

# Exit on error
set -e

# Read input parameters
OWNER="$1"
REPOSITORY="$2"
PULL_REQUEST_NUMBER="$3"
GITHUB_TOKEN="$4"
CODE_BUDDY_KEY="$5"
STACK="$6"
TOTAL_COMMENTS="$7"

# Validate required parameters
if [ -z "$OWNER" ] || [ -z "$REPOSITORY" ] || [ -z "$PULL_REQUEST_NUMBER" ] || [ -z "$GITHUB_TOKEN" ] || [ -z "$CODE_BUDDY_KEY" ] || [ -z "$STACK" ]; then
  echo "Error: Missing required parameters"
  echo "Usage: entrypoint.sh <owner> <repository> <pull_request_number> <github_token> <code_buddy_key> <stack> [total_comments]"
  exit 1
fi

# Construct the payload for the request
PAYLOAD=$(cat <<EOF
{
  "owner": "$OWNER",
  "repository": "$REPOSITORY",
  "pullRequestNumber": "$PULL_REQUEST_NUMBER",
  "githubToken": "$GITHUB_TOKEN",
  "codeBuddyKey": "$CODE_BUDDY_KEY",
  "stack": "$STACK",
  "totalComments": ${TOTAL_COMMENTS:-null}
}
EOF
)

echo "Making request to CodeBuddy AI Agent..."

# Make the CURL request
RESPONSE=$(curl -s --location 'http://64.23.245.115:8080/v1/code-review-agent' \
  --header 'Content-Type: application/json' \
  --data "$PAYLOAD")

# Check if request was successful
if [ -z "$RESPONSE" ]; then
  echo "Error: Empty response from CodeBuddy API"
  exit 1
fi

echo "Response received from CodeBuddy AI Agent"

# Set the action output using new GitHub Actions syntax
echo "response=$RESPONSE" >> "$GITHUB_OUTPUT"
