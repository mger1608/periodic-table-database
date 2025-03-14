#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# check if argument is provded
if [ -z "$1" ]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# store the input argument
INPUT=$1

# Query the database for the element based on atomic_number , symbol, or name
ELEMENT_INFO=$($PSQL "SELECT e.atmoic_number, e.symbol. e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
                      FROM elements e
                      JOIN properties p ON e.atomic_number = p.atomic_number
                      JOIN types t ON p.type_id = t.type_id
                      WHERE e.atomic_number::TEXT = '$INPUT' OR e.symbol = '$INPUT' OR e.name = '$INPUT';")


# check if the element was found
if [ -z "$ELEMENT_INFO" ]; then
  echo "I could not find that element in the database."
else
  # Split the result into variables
  IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME TYPE MASS MELTING BOILING <<< "$ELEMENT_INFO"

  # Remove trailing zeros from atomic mass
  MASS=$(echo $MASS | sed 's/\(\.[0-9]*[1-9]\)0*$/\1/; s/\.$//')

  # Output the formatted information
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). Its a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi