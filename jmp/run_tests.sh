#!/bin/bash

# JMP Flutter App Test Runner
# This script provides easy commands to run different types of tests

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "JMP Flutter App Test Runner"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  all              Run all tests"
    echo "  unit             Run unit tests only"
    echo "  widget           Run widget tests only"
    echo "  integration      Run integration tests only"
    echo "  coverage         Run tests with coverage report"
    echo "  clean            Clean test cache and rebuild"
    echo "  generate-mocks   Generate mock classes"
    echo "  help             Show this help message"
    echo ""
    echo "Options:"
    echo "  --verbose        Run with verbose output"
    echo "  --platform=PLATFORM  Run tests on specific platform (android, ios, web)"
    echo "  --coverage-html  Generate HTML coverage report"
    echo ""
    echo "Examples:"
    echo "  $0 all"
    echo "  $0 unit --verbose"
    echo "  $0 coverage --coverage-html"
    echo "  $0 widget --platform=android"
}

# Function to check if Flutter is available
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed or not in PATH"
        exit 1
    fi
}

# Function to get dependencies
get_dependencies() {
    print_status "Getting Flutter dependencies..."
    flutter pub get
}

# Function to generate mock classes
generate_mocks() {
    print_status "Generating mock classes..."
    flutter packages pub run build_runner build --delete-conflicting-outputs
    print_success "Mock classes generated successfully"
}

# Function to clean test cache
clean_tests() {
    print_status "Cleaning test cache..."
    flutter clean
    flutter pub get
    generate_mocks
    print_success "Test cache cleaned successfully"
}

# Function to run unit tests
run_unit_tests() {
    print_status "Running unit tests..."
    if [[ "$VERBOSE" == "true" ]]; then
        flutter test test/unit/ --verbose
    else
        flutter test test/unit/
    fi
    print_success "Unit tests completed"
}

# Function to run widget tests
run_widget_tests() {
    print_status "Running widget tests..."
    if [[ "$VERBOSE" == "true" ]]; then
        flutter test test/widget/ --verbose
    else
        flutter test test/widget/
    fi
    print_success "Widget tests completed"
}

# Function to run integration tests
run_integration_tests() {
    print_status "Running integration tests..."
    if [[ "$VERBOSE" == "true" ]]; then
        flutter test test/integration/ --verbose
    else
        flutter test test/integration/
    fi
    print_success "Integration tests completed"
}

# Function to run all tests
run_all_tests() {
    print_status "Running all tests..."
    if [[ "$VERBOSE" == "true" ]]; then
        flutter test --verbose
    else
        flutter test
    fi
    print_success "All tests completed"
}

# Function to run tests with coverage
run_coverage_tests() {
    print_status "Running tests with coverage..."
    
    # Create coverage directory if it doesn't exist
    mkdir -p coverage
    
    if [[ "$VERBOSE" == "true" ]]; then
        flutter test --coverage --coverage-path=coverage/lcov.info --verbose
    else
        flutter test --coverage --coverage-path=coverage/lcov.info
    fi
    
    if [[ "$GENERATE_HTML" == "true" ]]; then
        print_status "Generating HTML coverage report..."
        if command -v genhtml &> /dev/null; then
            genhtml coverage/lcov.info -o coverage/html
            print_success "HTML coverage report generated at coverage/html/index.html"
        else
            print_warning "genhtml not found. Install lcov to generate HTML coverage report."
            print_warning "On macOS: brew install lcov"
            print_warning "On Ubuntu: sudo apt-get install lcov"
        fi
    fi
    
    print_success "Coverage tests completed"
}

# Function to run tests on specific platform
run_platform_tests() {
    if [[ -z "$PLATFORM" ]]; then
        print_error "Platform not specified. Use --platform=android|ios|web"
        exit 1
    fi
    
    print_status "Running tests on platform: $PLATFORM"
    
    case $PLATFORM in
        android)
            flutter test -d android
            ;;
        ios)
            flutter test -d ios
            ;;
        web)
            flutter test -d chrome
            ;;
        *)
            print_error "Unsupported platform: $PLATFORM"
            print_error "Supported platforms: android, ios, web"
            exit 1
            ;;
    esac
    
    print_success "Platform tests completed for $PLATFORM"
}

# Main script logic
main() {
    # Check if Flutter is available
    check_flutter
    
    # Parse command line arguments
    COMMAND=""
    VERBOSE="false"
    PLATFORM=""
    GENERATE_HTML="false"
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            all|unit|widget|integration|coverage|clean|generate-mocks|help)
                COMMAND="$1"
                shift
                ;;
            --verbose)
                VERBOSE="true"
                shift
                ;;
            --platform=*)
                PLATFORM="${1#*=}"
                shift
                ;;
            --coverage-html)
                GENERATE_HTML="true"
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # If no command specified, show usage
    if [[ -z "$COMMAND" ]]; then
        show_usage
        exit 1
    fi
    
    # Execute command
    case $COMMAND in
        help)
            show_usage
            ;;
        clean)
            clean_tests
            ;;
        generate-mocks)
            get_dependencies
            generate_mocks
            ;;
        unit)
            get_dependencies
            if [[ -n "$PLATFORM" ]]; then
                run_platform_tests
            else
                run_unit_tests
            fi
            ;;
        widget)
            get_dependencies
            if [[ -n "$PLATFORM" ]]; then
                run_platform_tests
            else
                run_widget_tests
            fi
            ;;
        integration)
            get_dependencies
            if [[ -n "$PLATFORM" ]]; then
                run_platform_tests
            else
                run_integration_tests
            fi
            ;;
        coverage)
            get_dependencies
            run_coverage_tests
            ;;
        all)
            get_dependencies
            if [[ -n "$PLATFORM" ]]; then
                run_platform_tests
            else
                run_all_tests
            fi
            ;;
        *)
            print_error "Unknown command: $COMMAND"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@" 