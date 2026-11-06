#!/bin/bash

set -e

# Check for dependencies
if ! command -v python3 &> /dev/null;
then
    echo "Python is not installed. Please install Python 3.11 or higher."
    exit 1
fi

if ! command -v g++ &> /dev/null;
then
    echo "g++ is not installed. Please install g++."
    exit 1
fi

if ! command -v clang++ &> /dev/null;
then
    echo "clang++ is not installed. Please install clang."
    exit 1
fi

# Optimized compilation flags for ARMv8.2
CXXFLAGS="-march=armv8-a -mtune=cortex-a72 -O2"

# Compile llama.cpp
echo "Compiling llama.cpp..."
cd llama.cpp  # Navigate to the directory containing llama.cpp
make CXX="g++ ${CXXFLAGS}"

# TFLite environment setup
echo "Setting up TFLite environment..."
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install tensorflow

echo "Setup completed successfully!"