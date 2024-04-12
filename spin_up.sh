#!/bin/bash

PROJECT_DIR="../demo-portal/"

# Replace with your actual Github token (**never store it in plain text!**)
GITHUB_TOKEN="your_github_token"

# Navigate to the project directory
cd "$PROJECT_DIR" || { echo "Error: Could not change directory to $PROJECT_DIR"; exit 1; }

# Export the Github token
export GITHUB_TOKEN="$GITHUB_TOKEN"

# Run yarn dev to spin up Backstage
yarn dev

# Handle potential errors (optional)
if [[ $? -ne 0 ]]; then
  echo "Error: yarn dev failed!"
fi