#!/bin/bash

# Simulating USER_INFO
USER_INFO="10|5"
USER_NAME="John"

# Read the USER_INFO
while IFS='|' read -r GAMES_PLAYED BEST_GAME; do
  echo -e "\nWelcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
done < <(echo "$USER_INFO")

# Now you can use the BEST_GAME variable outside the loop
echo "Best game outside the loop: $BEST_GAME"