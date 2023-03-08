#!/bin/bash

echo "Mise a jour de Vacances.sql ..."
python3 ./scripts/remplissageVacances.py


echo  "Mise a jour de Bornes.sql ..."
python3 ./scripts/remplissageBornes.py ./raw/geolocalisationCompteur.csv Bornes


echo  "Mise a jour de ComptageVeloJour.sql ..."
python3 ./scripts/remplissageComptageVeloJour.py ./raw/comptageVelo.csv

