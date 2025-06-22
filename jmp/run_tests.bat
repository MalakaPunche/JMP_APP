@echo off
setlocal enabledelayedexpansion

REM JMP Flutter App Test Runner for Windows
REM This script provides easy commands to run different types of tests

set "COMMAND="
set "VERBOSE=false"
set "PLATFORM="
set "GENERATE_HTML=false"

REM Function to show usage
:show_usage
echo JMP Flutter App Test Runner
echo.
echo Usage: %0 [COMMAND] [OPTIONS]
echo.
echo Commands:
echo   all              Run all tests
echo   unit             Run unit tests only
echo   widget           Run widget tests only
echo   integration      Run integration tests only
echo   coverage         Run tests with coverage report
echo   clean            Clean test cache and rebuild
echo   generate-mocks   Generate mock classes
echo   help             Show this help message
echo.
echo Options:
echo   --verbose        Run with verbose output
echo   --platform=PLATFORM  Run tests on specific platform (android, ios, web)
echo   --coverage-html  Generate HTML coverage report
echo.
echo Examples:
echo   %0 all
echo   %0 unit --verbose
echo   %0 coverage --coverage-html
echo   %0 widget --platform=android
goto :eof

REM Function to check if Flutter is available
:check_flutter
flutter --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Flutter is not installed or not in PATH
    exit /b 1
)
goto :eof

REM Function to get dependencies
:get_dependencies
echo [INFO] Getting Flutter dependencies...
flutter pub get
goto :eof

REM Function to generate mock classes
:generate_mocks
echo [INFO] Generating mock classes...
flutter packages pub run build_runner build --delete-conflicting-outputs
echo [SUCCESS] Mock classes generated successfully
goto :eof

REM Function to clean test cache
:clean_tests
echo [INFO] Cleaning test cache...
flutter clean
flutter pub get
call :generate_mocks
echo [SUCCESS] Test cache cleaned successfully
goto :eof

REM Function to run unit tests
:run_unit_tests
echo [INFO] Running unit tests...
if "%VERBOSE%"=="true" (
    flutter test test/unit/ --verbose
) else (
    flutter test test/unit/
)
echo [SUCCESS] Unit tests completed
goto :eof

REM Function to run widget tests
:run_widget_tests
echo [INFO] Running widget tests...
if "%VERBOSE%"=="true" (
    flutter test test/widget/ --verbose
) else (
    flutter test test/widget/
)
echo [SUCCESS] Widget tests completed
goto :eof

REM Function to run integration tests
:run_integration_tests
echo [INFO] Running integration tests...
if "%VERBOSE%"=="true" (
    flutter test test/integration/ --verbose
) else (
    flutter test test/integration/
)
echo [SUCCESS] Integration tests completed
goto :eof

REM Function to run all tests
:run_all_tests
echo [INFO] Running all tests...
if "%VERBOSE%"=="true" (
    flutter test --verbose
) else (
    flutter test
)
echo [SUCCESS] All tests completed
goto :eof

REM Function to run tests with coverage
:run_coverage_tests
echo [INFO] Running tests with coverage...

REM Create coverage directory if it doesn't exist
if not exist "coverage" mkdir coverage

if "%VERBOSE%"=="true" (
    flutter test --coverage --coverage-path=coverage/lcov.info --verbose
) else (
    flutter test --coverage --coverage-path=coverage/lcov.info
)

if "%GENERATE_HTML%"=="true" (
    echo [INFO] Generating HTML coverage report...
    genhtml coverage/lcov.info -o coverage/html >nul 2>&1
    if errorlevel 1 (
        echo [WARNING] genhtml not found. Install lcov to generate HTML coverage report.
        echo [WARNING] On Windows: Install lcov through WSL or use online coverage tools.
    ) else (
        echo [SUCCESS] HTML coverage report generated at coverage/html/index.html
    )
)

echo [SUCCESS] Coverage tests completed
goto :eof

REM Function to run tests on specific platform
:run_platform_tests
if "%PLATFORM%"=="" (
    echo [ERROR] Platform not specified. Use --platform=android^|ios^|web
    exit /b 1
)

echo [INFO] Running tests on platform: %PLATFORM%

if "%PLATFORM%"=="android" (
    flutter test -d android
) else if "%PLATFORM%"=="ios" (
    flutter test -d ios
) else if "%PLATFORM%"=="web" (
    flutter test -d chrome
) else (
    echo [ERROR] Unsupported platform: %PLATFORM%
    echo [ERROR] Supported platforms: android, ios, web
    exit /b 1
)

echo [SUCCESS] Platform tests completed for %PLATFORM%
goto :eof

REM Parse command line arguments
:parse_args
if "%~1"=="" goto :main_logic
if "%~1"=="all" set "COMMAND=all" & shift & goto :parse_args
if "%~1"=="unit" set "COMMAND=unit" & shift & goto :parse_args
if "%~1"=="widget" set "COMMAND=widget" & shift & goto :parse_args
if "%~1"=="integration" set "COMMAND=integration" & shift & goto :parse_args
if "%~1"=="coverage" set "COMMAND=coverage" & shift & goto :parse_args
if "%~1"=="clean" set "COMMAND=clean" & shift & goto :parse_args
if "%~1"=="generate-mocks" set "COMMAND=generate-mocks" & shift & goto :parse_args
if "%~1"=="help" set "COMMAND=help" & shift & goto :parse_args
if "%~1"=="--verbose" set "VERBOSE=true" & shift & goto :parse_args
if "%~1"=="--coverage-html" set "GENERATE_HTML=true" & shift & goto :parse_args
if "%~1:~0,11%"=="--platform=" (
    set "PLATFORM=%~1:~11%"
    shift
    goto :parse_args
)
echo [ERROR] Unknown option: %~1
call :show_usage
exit /b 1

REM Main script logic
:main_logic
REM Check if Flutter is available
call :check_flutter
if errorlevel 1 exit /b 1

REM If no command specified, show usage
if "%COMMAND%"=="" (
    call :show_usage
    exit /b 1
)

REM Execute command
if "%COMMAND%"=="help" (
    call :show_usage
) else if "%COMMAND%"=="clean" (
    call :clean_tests
) else if "%COMMAND%"=="generate-mocks" (
    call :get_dependencies
    call :generate_mocks
) else if "%COMMAND%"=="unit" (
    call :get_dependencies
    if not "%PLATFORM%"=="" (
        call :run_platform_tests
    ) else (
        call :run_unit_tests
    )
) else if "%COMMAND%"=="widget" (
    call :get_dependencies
    if not "%PLATFORM%"=="" (
        call :run_platform_tests
    ) else (
        call :run_widget_tests
    )
) else if "%COMMAND%"=="integration" (
    call :get_dependencies
    if not "%PLATFORM%"=="" (
        call :run_platform_tests
    ) else (
        call :run_integration_tests
    )
) else if "%COMMAND%"=="coverage" (
    call :get_dependencies
    call :run_coverage_tests
) else if "%COMMAND%"=="all" (
    call :get_dependencies
    if not "%PLATFORM%"=="" (
        call :run_platform_tests
    ) else (
        call :run_all_tests
    )
) else (
    echo [ERROR] Unknown command: %COMMAND%
    call :show_usage
    exit /b 1
)

goto :eof 