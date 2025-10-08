#!/bin/bash

# Sway launcher script for Nvidia GPUs
# This script handles the --unsupported-gpu flag needed for proprietary Nvidia drivers

# Check if we have Nvidia GPU
if lspci | grep -i nvidia &> /dev/null; then
    echo "Nvidia GPU detected, launching sway with --unsupported-gpu flag..."
    exec sway --unsupported-gpu "$@"
else
    echo "No Nvidia GPU detected, launching sway normally..."
    exec sway "$@"
fi