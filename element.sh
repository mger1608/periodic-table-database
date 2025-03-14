#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [ -z "$1" ]; then
echo "Please provide an element as an argument."
exit 0
fi
INPUT=$1
ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.atomic_number::TEXT = '$INPUT' OR e.symbol = '$INPUT' OR e.name = '$INPUT';")
if [ -z "$ELEMENT_INFO" ]; then
echo "I could not find that element in the database."
else
IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME TYPE MASS MELTING BOILING <<< "$ELEMENT_INFO"echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi
