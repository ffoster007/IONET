#!/bin/bash

# สคริปต์ CLI สำหรับ ionet
# วิธีใช้: ionet [command] [options]

# สี ANSI สำหรับการแสดงผล
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color


print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}


install_cli() {
    print_info "installing ionet CLI..."
    
    local script_path="$(readlink -f "$0")"
    local install_path="/usr/local/bin/ionet"
    

    if [ ! -w "/usr/local/bin" ]; then
        print_warning "need to use sudo to install"
        sudo cp "$script_path" "$install_path"
        sudo chmod +x "$install_path"
    else
        cp "$script_path" "$install_path"
        chmod +x "$install_path"
    fi
    
    if [ $? -eq 0 ]; then
        print_success "ionet CLI installed successfully!"
        print_info "You can now use the 'ionet' command anywhere in the system"
        print_info "Try typing: ionet help"
    else
        print_error "Installation failed"
        return 1
    fi
}

# ฟังก์ชันถอนการติดตั้ง
uninstall_cli() {
    print_info "Uninstalling ionet CLI..."
    
    local install_path="/usr/local/bin/ionet"
    
    if [ ! -f "$install_path" ]; then
        print_warning "ionet is not installed on the system"
        return 1
    fi
    
    if [ ! -w "/usr/local/bin" ]; then
        sudo rm "$install_path"
    else
        rm "$install_path"
    fi
    
    if [ $? -eq 0 ]; then
        print_success "ionet CLI uninstalled successfully"
    else
        print_error "Uninstallation failed"
        return 1
    fi
}

# ฟังก์ชันแสดงวิธีใช้
show_help() {
    cat << EOF
Usage: ionet [command] [options]

Commands:
    install     Install ionet CLI on the system
    uninstall   Uninstall ionet CLI
    help        Show this help message
    version     Show version
    list        List files
    create      Create a new file
    delete      Delete a file

Options:
    -h, --help      Show help
    -v, --verbose   Show verbose information
    -f, --force     Force operation

Examples:
    ./ionet.sh install    # First time installation
    ionet list
    ionet create myfile.txt
    ionet delete myfile.txt --force

EOF
}




# Variables for options
VERBOSE=false
FORCE=false

# ประมวลผล arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        install)
            install_cli
            exit $?
            ;;
        uninstall)
            uninstall_cli
            exit $?
            ;;
        help)
            show_help
            exit 0
            ;;
        version)
            show_version
            exit 0
            ;;
        *)
            print_error "Invalid command: $1"
            echo "Use the 'help' command to see usage"
            exit 1
            ;;
    esac
done

# ถ้าไม่มี argument แสดง help
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi