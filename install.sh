#!/bin/bash

# สคริปต์ CLI พื้นฐาน
# วิธีใช้: ./script.sh [command] [options]

# สี ANSI สำหรับการแสดงผล
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ฟังก์ชันแสดงข้อความ
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

# ฟังก์ชันแสดงวิธีใช้
show_help() {
    cat << EOF
การใช้งาน: $(basename "$0") [command] [options]

คำสั่ง:
    help        แสดงความช่วยเหลือนี้
    version     แสดงเวอร์ชัน
    list        แสดงรายการไฟล์
    create      สร้างไฟล์ใหม่
    delete      ลบไฟล์

ตัวเลือก:
    -h, --help      แสดงความช่วยเหลือ
    -v, --verbose   แสดงข้อมูลละเอียด
    -f, --force     บังคับทำงาน

ตัวอย่าง:
    $(basename "$0") list
    $(basename "$0") create myfile.txt
    $(basename "$0") delete myfile.txt --force

EOF
}

# ฟังก์ชันแสดงเวอร์ชัน
show_version() {
    echo "เวอร์ชัน 1.0.0"
}

# ฟังก์ชันแสดงรายการไฟล์
list_files() {
    print_info "รายการไฟล์ในไดเรกทอรีปัจจุบัน:"
    ls -lh | tail -n +2
}

# ฟังก์ชันสร้างไฟล์
create_file() {
    local filename="$1"
    
    if [ -z "$filename" ]; then
        print_error "กรุณาระบุชื่อไฟล์"
        return 1
    fi
    
    if [ -f "$filename" ]; then
        print_warning "ไฟล์ $filename มีอยู่แล้ว"
        read -p "ต้องการเขียนทับหรือไม่? (y/n): " confirm
        if [ "$confirm" != "y" ]; then
            print_info "ยกเลิกการสร้างไฟล์"
            return 0
        fi
    fi
    
    touch "$filename"
    if [ $? -eq 0 ]; then
        print_success "สร้างไฟล์ $filename เรียบร้อย"
    else
        print_error "ไม่สามารถสร้างไฟล์ $filename ได้"
        return 1
    fi
}

# ฟังก์ชันลบไฟล์
delete_file() {
    local filename="$1"
    local force="$2"
    
    if [ -z "$filename" ]; then
        print_error "กรุณาระบุชื่อไฟล์"
        return 1
    fi
    
    if [ ! -f "$filename" ]; then
        print_error "ไม่พบไฟล์ $filename"
        return 1
    fi
    
    if [ "$force" != "true" ]; then
        read -p "ต้องการลบไฟล์ $filename หรือไม่? (y/n): " confirm
        if [ "$confirm" != "y" ]; then
            print_info "ยกเลิกการลบไฟล์"
            return 0
        fi
    fi
    
    rm "$filename"
    if [ $? -eq 0 ]; then
        print_success "ลบไฟล์ $filename เรียบร้อย"
    else
        print_error "ไม่สามารถลบไฟล์ $filename ได้"
        return 1
    fi
}

# ตัวแปรสำหรับ options
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
        help)
            show_help
            exit 0
            ;;
        version)
            show_version
            exit 0
            ;;
        list)
            list_files
            exit 0
            ;;
        create)
            create_file "$2"
            exit $?
            ;;
        delete)
            delete_file "$2" "$FORCE"
            exit $?
            ;;
        *)
            print_error "คำสั่งไม่ถูกต้อง: $1"
            echo "ใช้คำสั่ง 'help' เพื่อดูวิธีใช้"
            exit 1
            ;;
    esac
done


if [ $# -eq 0 ]; then
    show_help
    exit 0
fi