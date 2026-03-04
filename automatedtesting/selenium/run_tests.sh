#!/bin/bash
# Script to run Selenium tests with proper environment setup

echo "========================================"
echo "Selenium Functional UI Test Suite"
echo "========================================"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed"
    exit 1
fi

echo "Python version:"
python3 --version
echo ""

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    echo "Virtual environment created"
    echo ""
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate
echo ""

# Install/update dependencies
echo "Installing dependencies..."
pip install -q --upgrade pip
pip install -q -r requirements.txt
echo "Dependencies installed"
echo ""

# Run tests
echo "Running Selenium tests..."
echo "========================================"
python3 login.py

# Capture exit code
TEST_EXIT_CODE=$?

# Deactivate virtual environment
deactivate

echo ""
echo "========================================"
if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo "✓ ALL TESTS PASSED"
else
    echo "✗ SOME TESTS FAILED"
fi
echo "========================================"
echo ""
echo "Check log files in: log/"
ls -lh log/ | tail -n 1

exit $TEST_EXIT_CODE
