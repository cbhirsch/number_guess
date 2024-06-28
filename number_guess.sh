#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guessing -t --no-align -c"


GAME() {
  #read in username
  echo -e "\nEnter your username:"
  read USER_INPUT

  #check for username
  USER_NAME=$($PSQL "SELECT username FROM users WHERE username='$USER_INPUT'")
  if [[ -z $USER_NAME ]]
  then
    USER_NAME=$USER_INPUT
    echo -e "\nWelcome, $USER_NAME! It looks like this is your first time here."

  else
    #get user info
    USER_INFO=$($PSQL "SELECT games_played, best_game FROM users WHERE username='$USER_NAME'")
    echo $USER_INFO | while IFS='|' read GAMES_PLAYED BEST_GAME
    do 
      echo -e "\nWelcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses"
    done
  fi

  #generate random number between 1-1000
  NUMBER=$((RANDOM % 1000 +1))
  echo $NUMBER




}
GAME