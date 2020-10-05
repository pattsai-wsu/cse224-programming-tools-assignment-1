#!/bin/bash

##################################################################################################
# Patrick Tsai PA 1 - CSE 224 Fall - Due October 4, 2019 by 8am
#
# This program is Titled Sticks, Users compete against the computer.
# 1. The user initially chooses the total number of sticks to play with in the initial pile.
# 2. The user then chooses who goes first, u for user or c for computer 
# 3. Contestants choose a number of sticks to "take away" from the pile,
#    reducing the total number of sticks in the pile after each turn
# 4. Contestants can only choose 1, 2, or 3 sticks to remove from the pile, any other number
#    choice is considered illegal choice.
#    If a Contestant selects 2 consecutive illegal choices, they forfeit the game.
# 5. Whichever contestant selects the last number of sticks, that brings the pile total to 0, Wins.
# 6. The user is given a choice to play again at the end.
##################################################################################################

 illegal_move=0
 round=1
 
 func_illegal_move () {
   # this function handles illegal choices, giving contestants a second chnace to choose a legal choice
   # or else they forfeit
   if [[ $illegal_move -lt 1 ]]
   then
     echo "You Entered an illegal move. Please enter 1, 2, or 3."
     echo "If you enter another illegal move you will automatically forfeit the game."
     illegal_move=$((illegal_move+1))
     func_user_turn

   elif [[ $illegal_move -eq 1 ]]
   then
      echo "You have entered too many illegal moves, you lose"
      echo -e "\nYOU LOSE, You have lost due to making 2 illegal moves in a row."
      func_another_game
   fi
 }

 func_show_stick () {
   # this function is a for loop to show the number of sticks that remain using |
   for ((i=0;i<$num_stick;++i))
   do
     echo -n "|"
   done 
     echo "($num_stick)"
 }

 func_stick_subtract () {
   # this function subtracts the contestants' choice from the pile total
   new_num_stick=$((num_stick-take_away))
   num_stick=$new_num_stick
 }

 func_user_turn () {
      # this function handles the user's turn, asking how many sticks to remove
      current_player=1  # used for determine the winner
      echo -n -e "How many sticks would you like to take? \nEnter 1, 2, or 3: "
      read  take_away

      if [[ $take_away -eq 1 ]] || [[ $take_away -eq 2 ]] || [[ $take_away -eq 3 ]]
      then
        echo "After User's Turn - Total Sticks:"
        func_stick_subtract
      else 
        func_illegal_move        
      fi
 }

 func_computer_turn () {
      # this function handles the conputer's turn using ,modulus of 4 to choose the number of sticks
      current_player=0  # used to determine the winner
      computer_take=$((num_stick % 4))
      if [[ $computer_take -eq 0 ]]
      then
        computer_take=1
      fi

      echo "Computer takes: $computer_take"
      take_away=$computer_take
      func_stick_subtract
      echo "After Computer's Turn - Total Sticks:"
      round=$(($round+1))
 }

 func_another_game () {
      # this function handles if the user wants to play another game
      echo -e "\nWould you like to play again?"
      echo -e "press y for yes, any other key will exit the program"
      read -n1 another_game
      if [[ "$another_game" == "y" ]]
      then
        reload=$(readlink -f "$0")  # reloads the script
        exec "$reload"
      else
        exit 1
      fi
 }

 func_check_winner () {
      if [[ "$num_stick" -eq 0 ]]
      then
        if [[ "$current_player" -eq 1 ]]
        then
          echo -e "\nYOU WIN\n"
          func_another_game
        else
          echo -e "\nThe Computer Wins\n"
          func_another_game
        fi
      fi
 }

  echo -e "\rWelcome to the Stick game, we hope you have fun!"

  while true   # while loop to handle if the user selects less than 10 inital sticks
  do           # asks the initial sticks question again

  echo -n "Enter the number of sticks you'd like to use (must be 10 or more): "
  read num_stick


  if [[ num_stick -gt 9 ]] # check the number entered by the user - must be greater than 9
  then  

    while true  # while loop to handle if the user selects an option other than c or u
    do          # asks who the user wants to go first again

      echo  -n "Who would you like to go first? Enter c for computer or u for user: "
      read go_first

    if [[ "$go_first" == "c" ]] || [[ "$go_first" == "u" ]]
    then

      if [[ "$go_first" == "c" ]]
      then
        first="func_computer_turn"
        second="func_user_turn"
      else
        first="func_user_turn"
        second="func_computer_turn"
      fi

      while [[ $num_stick -gt 0 ]]
      do
           echo -e "\n-- Round $round - ( Current Stick Total $num_stick ) --"
              $first
              func_show_stick
              func_check_winner
              $second
              func_show_stick
              func_check_winner
              illegal_move=0  # resets the illegal move counter to zero

      done
      break
    fi
    echo "Invalid Entry"
   done 
  fi 
  echo "Invalid Entry"
  done
  break
