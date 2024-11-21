#!/bin/bash

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null
then
    echo "GitHub CLI (gh) could not be found. Please install it first."
    exit 1
fi

# List all forked repositories
echo "Fetching list of forked repositories..."
forked_repos=$(gh repo list --fork --json nameWithOwner --jq '.[].nameWithOwner')

if [ -z "$forked_repos" ]; then
    echo "No forked repositories found."
    exit 0
fi

echo "The following forked repositories were found:"
echo "$forked_repos"

# Ask for confirmation before deleting
read -p "Do you want to delete all these forked repositories? (y/N): " confirmation

if [[ "$confirmation" =~ ^[Yy]$ ]]; then
    for repo in $forked_repos; do
        echo "Deleting repository: $repo"
        gh repo delete "$repo" --confirm
    done
    echo "All forked repositories have been deleted."
else
    echo "Operation cancelled. No repositories were deleted."
fi