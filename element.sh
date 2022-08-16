#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

DISPLAY_RESULT() {
  if [[ -z $1 ]]; then
    echo "I could not find that element in the database."
  else 
    echo $1 | while read TYPE_ID BAR NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELT BAR BOIL BAR TYPE
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi
}

if [[ -z $1 ]]; then
  echo Please provide an element as an argument.
elif [[ $1 =~ ^[0-9]+$ ]]; then
  QUERY_RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1;")
  DISPLAY_RESULT "$QUERY_RESULT"
elif [[ $1 =~ ^[A-Z][a-z]?$ ]]; then
  QUERY_RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1';")
  DISPLAY_RESULT "$QUERY_RESULT"
elif [[ $1 =~ ^[a-zA-Z]{3,}$ ]]; then
  QUERY_RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$1';")
  DISPLAY_RESULT "$QUERY_RESULT"
fi
