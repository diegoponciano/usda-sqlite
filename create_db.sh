#!/bin/bash

if [ $# -ne 1 ]
then
  echo "You must specify a sqlite file as an argument."
  exit 1
fi

echo "Normalizing data..."
# Remove tildas
perl -pi -e s,~,,g data/*.txt
# Replace micro symbol to ASCII
perl -C1 -i -pe 's/\x{00B5}/mc/' data/NUTR_DEF.txt
# Replace micro symbol to ASCII
perl -C1 -i -pe "s/[\x91\x92]/'/g" data/*.txt
perl -C1 -i -pe 's/[\x93\x94]/"/g' data/*.txt

echo "Loading food group..."
sqlite3 $1 < load_food_group.sql

echo "Loading food..."
sqlite3 $1 < load_food.sql

echo "Loading nutrient..."
sqlite3 $1 < load_nutrient.sql
sqlite3 $1 < load_common_nutrient.sql

echo "Loading nutrition..."
sqlite3 $1 < load_nutrition.sql

echo "Done."
