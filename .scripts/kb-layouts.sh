#!/bin/bash

# Configuration
LANGS_CONF="$HOME/.config/hypr/modules/langs.conf"
LAYOUTS_DIR="/usr/share/X11/xkb/symbols/"

# Check dependencies
if ! command -v gum &> /dev/null; then
    echo "❌ 'gum' is not installed. Please install it first:"
    echo "   https://github.com/charmbracelet/gum#installation"
    exit 1
fi

# Function to detect available keyboard layouts
detect_available_layouts() {
    if [ -d "$LAYOUTS_DIR" ]; then
        # Get all layout files, remove .xml and other non-layout files
        AVAILABLE_LAYOUTS=($(find "$LAYOUTS_DIR" -type f -printf '%f\n' | grep -vE '\.xml$|\.lst$|^[[:upper:]]+$'))
        # If detection fails, fall back to common layouts
        if [ ${#AVAILABLE_LAYOUTS[@]} -eq 0 ]; then
            AVAILABLE_LAYOUTS=("us" "ru" "il" "de" "fr" "es" "jp" "br")
        fi
    else
        AVAILABLE_LAYOUTS=("us" "ru" "il" "de" "fr" "es" "jp" "br")
    fi
    echo "${AVAILABLE_LAYOUTS[@]}"
}

# Function to select keyboard layouts
select_keyboard_layouts() {
    local available_layouts=($(detect_available_layouts))
    
    echo "⌨️ Available keyboard layouts:"
    selected_layouts=$(gum choose --no-limit \
        --cursor="> " \
        --selected-prefix="[*] " \
        --unselected-prefix="[ ] " \
        "${available_layouts[@]}" | tr '\n' ' ' | sed 's/ $//')

    if [ -z "$selected_layouts" ]; then
        echo "⚠️ No layouts selected. Defaulting to 'us'."
        selected_layouts="us"
    fi

    # Format output
    echo "Selected layouts: $selected_layouts"
    formatted_langs=$(echo "$selected_layouts" | tr ' ' ',')
    lang_entry="\$LANG=$formatted_langs"

    # Ensure config directory exists
    mkdir -p "$(dirname "$LANGS_CONF")"

    # Save to config
    echo "$lang_entry" > "$LANGS_CONF"
    echo "Saved keyboard layouts to: $LANGS_CONF"
    echo "   Content: $lang_entry"
}

# Main function
main() {
    select_keyboard_layouts
}

# Run
main
