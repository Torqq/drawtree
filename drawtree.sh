#!/bin/bash

# Parameters
PATH_TO_SCAN="${1:-.}"
MAX_DEPTH=10

# Cool
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
CYAN=$(tput setaf 6)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
WHITE=$(tput setaf 7)
GRAY=$(tput setaf 8)
RESET=$(tput sgr0)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASENAME="maptree_output.txt"
OUTPUT_FILE="$SCRIPT_DIR/$BASENAME"
COUNT=1

while [[ -e "$OUTPUT_FILE" ]]; do
    OUTPUT_FILE="$SCRIPT_DIR/$(basename "$BASENAME" .txt)($COUNT).txt"
    ((COUNT++))
done

touch "$OUTPUT_FILE" || { echo "${RED}Erreur lors de la création du fichier d'export.${RESET}"; exit 1; }

show_tree() {
    local current_path="$1"
    local level="$2"

    if (( level > MAX_DEPTH )); then
        return
    fi

    local spacer
    spacer="$(printf '    %.0s' $(seq 1 $level))|-- "
    local folder_name
    folder_name="$(basename "$current_path")"

    local folder_color="$CYAN"
    [[ $level -eq 0 ]] && folder_color="$GREEN"
    [[ $level -eq 1 ]] && folder_color="$BLUE"

    echo -e "${folder_color}${spacer}${folder_name}${RESET}"
    echo "$spacer$folder_name" >> "$OUTPUT_FILE"

    find "$current_path" -mindepth 1 -maxdepth 1 -type f 2>/dev/null | while read -r file; do
        local fname="$(basename "$file")"
        local fprefix
        fprefix="$(printf '    %.0s' $(seq 1 $((level + 1))))-> "

        local ext="${fname##*.}"
        local color="$WHITE"
        case "$ext" in
            txt) color="$YELLOW" ;;
            exe|ps1|sh) color="$RED" ;;
        esac

        echo -e "${color}${fprefix}${fname}${RESET}"
        echo "$fprefix$fname" >> "$OUTPUT_FILE"
    done

    find "$current_path" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | while read -r dir; do
        show_tree "$dir" $((level + 1))
    done
}

show_tree "$(realpath "$PATH_TO_SCAN")" 0

echo -e "\n${GREEN}Export créé dans : $OUTPUT_FILE${RESET}"
