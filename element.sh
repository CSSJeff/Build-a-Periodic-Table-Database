#!/bin/bash
# script for periodic table project
# updated formatting
# cleanup
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

if [[ $1 =~ ^[0-9]+$ ]]
then
  QUERY="atomic_number=$1"
elif [[ ${#1} -le 2 ]]
then
  QUERY="symbol='$1'"
else
  QUERY="name='$1'"
fi

DATA=$($PSQL "SELECT atomic_number, name, symbol FROM elements WHERE $QUERY")

if [[ -z $DATA ]]
then
  echo "I could not find that element in the database."
  exit
fi

echo $DATA | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL
do
  INFO=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM properties FULL JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")

  echo $INFO | while IFS="|" read MASS MELT BOIL TYPE
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  done
done

# fix
# feat
# refactor
# chore
