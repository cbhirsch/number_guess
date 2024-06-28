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
    INPUT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USER_NAME')")
    #get user_id
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USER_NAME'")

  else
    #get user_id
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USER_NAME'")
    #get user info
    BEST_GAME=$($PSQL "SELECT best_game FROM game_info WHERE user_id='$USER_ID'")
    GAMES_PLAYED=$($PSQL "SELECT games_played FROM game_info WHERE user_id='$USER_ID'")
    echo -e "Welcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

  fi
  #initialize variable guessed_number
  NUMBER_FOUND=false
  #generate random number between 1-1000
  SECRET_NUMBER=$((RANDOM % 1000 +1))
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

  #add info into database
  GAME_INFO_ID=$($PSQL "SELECT game_info_id FROM game_info WHERE user_id=$USER_ID")
  echo $GAME_INFO_ID
  if [[ -z $GAME_INFO_ID ]]
  then
    INSERT_NEW_INFO=$($PSQL "INSERT INTO game_info(games_played,best_game,user_id) VALUES(1,$NUMBER_OF_GUESSES,$USER_ID)")
  else
    #increment games played
    ((GAMES_PLAYED++))
    
    #check if best game
    if [ $BEST_GAME -gt $NUMBER_OF_GUESSES ]
    then
      #if true update best game
      BEST_GAME=$NUMBER_OF_GUESSES

    fi

    #add info
    UPDATE_GAME_INFO=$($PSQL "UPDATE game_info SET games_played=$GAMES_PLAYED,best_game=$BEST_GAME WHERE game_info_id=$GAME_INFO_ID")

  fi


  #game finished statement
  echo -e "\nYou guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"






}
GAME