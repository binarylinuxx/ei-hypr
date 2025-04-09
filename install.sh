#!/bin/bash

# Configuration
GIT_REPO="https://github.com/binarylinuxx/ei-hypr"
PKGS="wget gum curl"
TARGET_DIR="ei-hypr"

# Function to install packages
install_packages() {
    echo "Installing required presetup packages: $PKGS"
    sudo pacman -Sy --noconfirm $PKGS || {
        echo "Failed to install packages."
        exit 1
    }
}

# Function to clone the repository
clone_repo() {
    if [ -d "$TARGET_DIR" ]; then
        echo "Directory '$TARGET_DIR' already exists. Removing it for a fresh clone..."
        rm -rf "$TARGET_DIR" || {
            echo "Failed to remove existing directory."
            exit 1
        }
    fi

    echo "Cloning repository: $GIT_REPO"
    git clone "$GIT_REPO" "$TARGET_DIR" || {
        echo "Failed to clone repository."
        exit 1
    }
}

# Main function
main() {
    install_packages
    clone_repo
    echo "PRESETUP DONE."
}

version=$(gum choose "YES" "NO CANCEL")

if [ "$version" == "YES" ]; then
    echo ">> STARTING PRESETUP"
    main
elif [ "$version" == "NO CANCEL" ]; then
    echo ">> CANCELED DESTROY"
    exit 130
else
    echo ">> INVALID OPTION"
    exit 1
fi
