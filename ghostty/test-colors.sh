#!/bin/bash

# Test script to check terminal colors
echo "Testing terminal colors..."
echo

# Test ANSI colors
echo "Standard ANSI colors:"
for i in {0..15}; do
    printf "\033[38;5;${i}mColor $i\033[0m  "
    if [ $((($i + 1) % 8)) -eq 0 ]; then
        echo
    fi
done
echo

# Test text formatting
echo "Text formatting tests:"
echo -e "\033[1mBold text\033[0m"
echo -e "\033[3mItalic text\033[0m"
echo -e "\033[4mUnderlined text\033[0m"
echo -e "\033[31mRed text\033[0m"
echo -e "\033[32mGreen text\033[0m"
echo -e "\033[33mYellow text\033[0m"
echo -e "\033[34mBlue text\033[0m"
echo -e "\033[35mMagenta text\033[0m"
echo -e "\033[36mCyan text\033[0m"
echo -e "\033[37mWhite text\033[0m"
echo

# Test your prompt
echo "Current prompt colors:"
echo $PROMPT

echo "If colors look good and match your nvim theme, the configuration is working!"