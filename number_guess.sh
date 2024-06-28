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
      echo -e "\nWelcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
    done
  fi
  #initialize variable guessed_number
  NUMBER_FOUND=false
  #generate random number between 1-1000
  SECRET_NUMBER=$((RANDOM % 1000 +1))
  echo $SECRET_NUMBER
  #initial user input
  echo -e "\nGuess the secret number between 1 and 1000:"
  NUMBER_OF_GUESSES=0
  read USER_GUESS

  #basic game logic
  while [ $NUMBER_FOUND != true ]
  do
    #increment guesses
    ((NUMBER_OF_GUESSES++))

    #check input if it is an integer or higher/lower than secret number
    if ! [[ "$USER_GUESS" =~ ^-?[0-9]+$ ]]; then
      echo -e "\nThat is not an integer, guess again:" 
      read USER_GUESS
    elif [ $SECRET_NUMBER -lt $USER_GUESS ]
    then
      echo -e "\nIt's lower than that, guess again:" 
      read USER_GUESS
    elif [ $SECRET_NUMBER -gt $USER_GUESS ]
    then
      echo -e "\nIt's higher than that, guess again:" 
      read USER_GUESS
    else
      NUMBER_FOUND=true
    fi
  done

  #game finished statement
  echo -e "\nYou guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"






}
GAME