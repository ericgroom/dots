#!/bin/bash

# Get the current branch name
current_branch=$(git symbolic-ref --short HEAD)

# Ensure we are on a branch
if [ -z "$current_branch" ]; then
  echo "Not currently on a branch. Please checkout a branch before running this script."
  exit 1
fi

# List all branches except for the current branch and main/master
branches=$(git branch | grep -vE "^\*|$current_branch|master|main" | tr -d ' ')

# If no branches are found to clean, exit
if [ -z "$branches" ]; then
  echo "No branches to clean up."
  exit 0
fi

# Create a temporary file with the branch list
temp_file=$(mktemp)

# Generate a list of branches with a marker (D to delete, space to keep)
echo "# Mark branches with 'delete' or 'd' to delete them. Leave others as they are." >> "$temp_file"
echo "# Mark with FORCE to use -D" >> "$temp_file"
for branch in $branches; do
  echo "keep $branch" >> "$temp_file"
done

# Open the temporary file in the editor
$(git config --global core.editor) "$temp_file"

# Read the file and delete marked branches
while IFS= read -r line; do
  # Check if the line starts with 'D' (delete)
  if [[ "$line" =~ ^d\ (.*) ]]; then
    branch_to_delete="${BASH_REMATCH[1]}"
    echo "Deleting branch: $branch_to_delete"
    git branch -d "$branch_to_delete"
  fi
  if [[ "$line" =~ ^FORCE\ (.*) ]]; then
    branch_to_delete="${BASH_REMATCH[1]}"
    echo "Force deleting branch: $branch_to_delete"
    git branch -D "$branch_to_delete"
  fi
done < "$temp_file"

# Clean up the temporary file
rm "$temp_file"

echo "Cleanup complete!"
