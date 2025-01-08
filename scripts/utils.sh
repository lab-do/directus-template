#!/bin/sh

# Colors
COLOR_RESET="\033[0m"
COLOR_INFO="\033[1;34m"    # Bold Blue
COLOR_SUCCESS="\033[1;32m" # Bold Green
COLOR_WARNING="\033[1;33m" # Bold Yellow
COLOR_ERROR="\033[1;31m"   # Bold Red

# Print a message with a color

# Helper function to log informational messages
info() {
  printf "${COLOR_INFO}[INFO]${COLOR_RESET} %s\n" "$1" >&2
}

# Helper function to log success messages
success() {
  printf "${COLOR_SUCCESS}[SUCCESS]${COLOR_RESET} %s\n" "$1" >&2
}

# Helper function to log warning messages
warning() {
  printf "${COLOR_WARNING}[WARNING]${COLOR_RESET} %s\n" "$1" >&2
}

# Helper function to log error messages
error() {
  printf "${COLOR_ERROR}[ERROR]${COLOR_RESET} %s\n" "$1" >&2
  exit 1
}

# Function to get the Directus container name
directus_container() {
  # Get the list of running Docker containers
  running_containers=$(docker ps -f "name=directus" --format '{{.Names}}')

  if [ -z "$running_containers" ]; then
    # If not found by name, try to find by image
    running_containers=$(docker ps -f "ancestor=directus/directus" --format '{{.Names}}')
  fi

  if [ -z "$running_containers" ]; then
    Print "No Directus container found." >&2
    exit 1
  fi

  count=$(echo "$running_containers" | wc -l)
  if [ "$count" -eq 1 ]; then
    # If only one container is found, return it
    echo "$running_containers"
    return 0
  fi

  # If multiple containers are found, prompt the user to select
  printf "Multiple Directus containers found:\n" >&2

  while true; do
    # Display running containers for the user to choose from
    printf "Available containers:\n" >&2
    i=1
    for container in $running_containers; do
      printf "  [%d] %s\n" "$i" "$container" >&2
      i=$((i + 1))
    done

    printf "\nSelect container number: " >&2
    read -r selection

    if ! echo "$selection" | grep -qE '^[0-9]+$'; then
      echo "Invalid selection: not a number" >&2
      continue
    fi

    i=1
    for container in $running_containers; do
      if [ "$i" = "$selection" ]; then
        echo "$container"
        return 0
      fi
      i=$((i + 1))
    done

    # If no valid container was selected
    echo "Invalid selection: number out of range" >&2
  done
}
