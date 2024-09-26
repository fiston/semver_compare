#!/bin/bash

# Function to compare two pre-release identifiers
compare_prerelease() {
    local pr1=$1
    local pr2=$2
    # If both are empty, they are equal
    if [[ -z "$pr1" && -z "$pr2" ]]; then
        return 0
    # Pre-release is lower precedence than no pre-release
    elif [[ -z "$pr1" ]]; then
        return 1
    elif [[ -z "$pr2" ]]; then
        return 2
    fi
    # Split pre-release identifiers by dot
    IFS='.' read -r -a pr_parts1 <<<"$pr1"
    IFS='.' read -r -a pr_parts2 <<<"$pr2"
    for i in "${!pr_parts1[@]}"; do
        if [[ -z "${pr_parts2[$i]}" ]]; then
            return 1
        fi
        if [[ "${pr_parts1[$i]}" =~ ^[0-9]+$ && "${pr_parts2[$i]}" =~ ^[0-9]+$ ]]; then
            # Numeric comparison
            if (( pr_parts1[i] > pr_parts2[i] )); then
                return 1
            elif (( pr_parts1[i] < pr_parts2[i] )); then
                return 2
            fi
        else
            # Alphanumeric comparison
            if [[ "${pr_parts1[$i]}" > "${pr_parts2[$i]}" ]]; then
                return 1
            elif [[ "${pr_parts1[$i]}" < "${pr_parts2[$i]}" ]]; then
                return 2
            fi
        fi
    done
    if [[ ${#pr_parts2[@]} -gt ${#pr_parts1[@]} ]]; then
        return 2
    fi
    return 0
}

# Function to compare two full semantic versions
compare_semver() {
    local version1=$1
    local version2=$2
    # Split version and pre-release parts
    IFS='-' read -r core1 prerelease1 <<<"$version1"
    IFS='-' read -r core2 prerelease2 <<<"$version2"
    # Split the core version into major, minor, patch
    IFS='.' read -r major1 minor1 patch1 <<<"$core1"
    IFS='.' read -r major2 minor2 patch2 <<<"$core2"
    # Compare major versions
    if (( major1 > major2 )); then
        return 1  # version1 is greater
    elif (( major1 < major2 )); then
        return 2  # version2 is greater
    fi
    # Compare minor versions
    if (( minor1 > minor2 )); then
        return 1  # version1 is greater
    elif (( minor1 < minor2 )); then
        return 2  # version2 is greater
    fi
    # Compare patch versions
    if (( patch1 > patch2 )); then
        return 1  # version1 is greater
    elif (( patch1 < patch2 )); then
        return 2  # version2 is greater
    fi
    # Compare pre-release versions if present
    compare_prerelease "$prerelease1" "$prerelease2"
    return $?
}

# Main function to handle comparison and operator
semver_compare() {
    local version1=$1
    local operator=$2
    local version2=$3

    compare_semver "$version1" "$version2"
    result=$?

    case $operator in
        ">")
            [[ $result -eq 1 ]] && echo "true" || echo "false"
            ;;
        "<")
            [[ $result -eq 2 ]] && echo "true" || echo "false"
            ;;
        "==")
            [[ $result -eq 0 ]] && echo "true" || echo "false"
            ;;
        *)
            echo "Invalid operator. Use '>', '<', or '=='." >&2
            exit 1
            ;;
    esac
}

# Ensure three arguments are passed
if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <version1> <operator> <version2>" >&2
    echo "Operator can be '>', '<', or '=='" >&2
    exit 1
fi

# Call the main function with all arguments
semver_compare "$1" "$2" "$3" 
