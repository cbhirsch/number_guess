#!/bin/bash

# Prompt the user for input
read -p "Enter a value: " USER_INPUT

# Check if the input is not an integer
if ! [[ "$USER_INPUT" =~ ^-?[0-9]+$ ]]; then
  echo "The input is not an integer."
else
  echo "The input is an integer."
fi