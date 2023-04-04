---------------------------------------------------------------------------[+]
-- SCRIPT DE REQUETAGE DE LA BASE DE DONNEES POUR LE PROJET VELO DE NANTES  |
---------------------------------------------------------------------------[+]

/**
 * 
 * Pubert Elise
 * Esnault Gabin
 * Da-Rocha Gatien
 * Leborgne Néo
 * 
 * Gr : 1B1
 * Deadline : 07 avril 2023
 * 
 */


-------------------------------[+]
-- PROJECTION AVEC RESTRICTION  |
-------------------------------[+]
-----------------------------------------------------------------------------[+]
-- 1. Selectionner l'identifiant, le nom des compteur et les observation des  |
--    compteurs qui ont une observation                                       |
-----------------------------------------------------------------------------[+]

SELECT idCompteur, libelle, observation
FROM Compteur 
WHERE observation IS NOT NULL;

/** 8 rows selected 
 * IDCOMPTEUR   LIBELLE                             OBSERVATION
 * -----------  ----------------------------------  -------------
 * 699          Coteaux vers Est                    Releve manuel
 * 700          Promenade de Bellevue vers Ouest    Releve manuel
 * 89           Coteaux vers Ouest                  Releve manuel
 * 1031         VN751A Vers St Leger les Vignes     Releve manuel
 * 907          Stade vers Est                      Releve manuel
 * 701          Promenade de Bellevue vers Est      Releve manuel
 * 889          Stade vers Ouest                    Releve manuel
 * 1032         VN vers Sucé sur Erdre              Releve manuel
 */


----------------------------------------------------------------------------------[+]
-- 2. Selectionner les noms des quartiers et la longueur de l'aménagement cyclable |
--    des quartiers dont l'aménagement cyclable est supérieur à 20 000m            |
----------------------------------------------------------------------------------[+]

SELECT nomQuartier, longueurAmenagementCyclable
FROM Quartier
WHERE longueurAmenagementCyclable > 20000;

/** 8 rows selected
 * NOMQUARTIER                          LONGUEURAMENAGEMENTCYCLABLE
 * ----------------------------------   ---------------------------
 * Centre Ville                                 21548.7
 * Bellevue - Chantenay - Sainte Anne           22597.3
 * Hauts Pavés - Saint Félix                    30522.9
 * Malakoff - Saint-Donatien                    28078.6
 * Ile de Nantes                                32398.2
 * Nantes Nord                                  22945.8
 * Nantes Erdre                                 31816.2
 * Doulon - Bottiere                            48780.2
 */


---------[+]
-- UNION  |
---------[+]
-------------------------------------------------------------------------------------------------[+]
-- 1.Selectionner les dates de début des vacances de Noel et les jours entre le 10 et le 15 mars  |
--   2022                                                                                         |
-------------------------------------------------------------------------------------------------[+]
SELECT dateDebut jours
FROM VacancesZoneB
WHERE UPPER(nomVacances) LIKE '%NOEL%'

UNION

SELECT dateJour
FROM Jour
WHERE dateJour > TO_DATE('10-03-2022','DD-MM-YYYY') 
    AND dateJour < TO_DATE('15-03-2022','DD-MM-YYYY');

/** 8 rows selected
 * JOURS
 * ----------
 * 21-DEC-19
 * 19-DEC-20
 * 18-DEC-21
 * 11-MAR-22
 * 12-MAR-22
 * 13-MAR-22
 * 14-MAR-22
 * 17-DEC-22
 */


--------------------------[+]
-- DIFFERENCE ENSEMBLISTE  |
--------------------------[+]
---------------------------------------------------------------------------[+]
-- 1. Trouver les compteurs qui n'ont pas été utilisé lors du 28 mars 2021  |
---------------------------------------------------------------------------[+]
SELECT idCompteur
FROM Compteur
    
MINUS
    
SELECT DISTINCT leCompteur
FROM ComptageJour
WHERE leJour = TO_DATE('2021-05-30', 'YYYY-MM-DD');

/** 58 rows selected
 * IDCOMPTEUR
 * ----------
 * 89
 * 664
 * 665
 * 666
 * 667
 * 668
 * 669
 * 670
 * ...
 */


--------------------[+]
-- JOINTURE INTERNE  |
--------------------[+]
------------------------------------------------------[+]
-- 1. Pour chaque compteur appartenant à un quartier,  |
--    sélectionner le nom de ce quartier               |
------------------------------------------------------[+]
SELECT idCompteur, nomQuartier
FROM Compteur 
    JOIN Quartier ON leQuartier = idQuartier;

/** 52 rows selected
 * IDCOMPTEUR   NOMQUARTIER
 * ----------   -------------------------
 * 665          Centre Ville
 * 744          Centre Ville
 * 666          Centre Ville
 * 681          Malakoff - Saint-Donatien
 * 679          Malakoff - Saint-Donatien
 * 787          Centre Ville
 * 788          Centre Ville
 * 700          Doulon - Bottiere
 */


-----------------------------------------------------------------------[+]
-- 2. Pour chaque comptage du compteur 665, selectionner l'identifiant  |
--    du compteur, le jour du comptage et la température                |
-----------------------------------------------------------------------[+]
SELECT leCompteur, dateJour, temperatureMoyenne
FROM ComptageJour
    JOIN Jour ON leJour = dateJour
WHERE leCompteur = 665;

/** 25 rows selected
 * LECOMPTEUR   DATEJOUR    TEMPERATUREMOYENNE
 * ----------   ---------   ------------------
 * 665          27-JAN-20   9.85
 * 665          26-JAN-20   7.58
 * 665          25-JAN-20   6.4
 * 665          24-JAN-20   3.52
 * 665          23-JAN-20   2.58
 * 665          22-JAN-20   3.2
 * 665          21-JAN-20   2.95
 * 665          20-JAN-20   4.93
 * ...
*/


----------------------------------[+]
-- TRI + LIMITATION (AVEC ROWNUM)  |
----------------------------------[+]
-----------------------------------------------[+]
-- 1. Selectionner les 40 jours les plus chaud  |
-----------------------------------------------[+]
SELECT * 
FROM (SELECT * 
    FROM Jour 
    ORDER BY TemperatureMoyenne DESC)
WHERE ROWNUM <= 40;

/** 40 rows selected
 * DATEJOUR    TEMPERATUREMOYENNE
 * ---------   ------------------
 * 18-JUL-22   30.95
 * 18-JUN-22   30.1
 * 07-AUG-20   29.05
 * 13-AUG-22   27.95
 * 08-AUG-20   27.92
 * 11-AUG-20   27.8
 * 13-JUL-22   27.72
 * 17-JUN-22   27.62
 * ...
 */


--------------------[+]
-- JOINTURE EXTERNE  |
--------------------[+]
--------------------------------------------------------------------------------------[+]
-- 1. Pour chaque quartier, selectionner les compteurs qu'il possède (peut-être null)  |
--------------------------------------------------------------------------------------[+]
SELECT nomQuartier, idCompteur
FROM Quartier
    LEFT JOIN Compteur ON leQuartier = idQuartier
ORDER BY nomQuartier;

/** 60 rows selected
 * NOMQUARTIER                          IDCOMPTEUR
 * ----------------------------------   ----------
 * Bellevue - Chantenay - Sainte Anne   - 
 * Blordiere                            - 
 * Breil - Barberie                     - 
 * Centre Ville                         788
 * Centre Ville                         787
 * Centre Ville                         666
 * Centre Ville                         665
 * Centre Ville                         744
 * ...
 */


------------------------------------------------------------------------------------------[+]
-- 2. Pour chaque jour, selectionner le nombre de passage entre 8h et 12h du compteur 672  |
--    et la temperature (peut-être null) trié du jour le plus ancien au plus récent        |                                                               --
------------------------------------------------------------------------------------------[+]
SELECT dateJour, h08 + h09 + h10 + h11 nbPassageDe8a12, temperatureMoyenne
FROM Jour
    LEFT JOIN ComptageJour ON leJour = dateJour
WHERE leCompteur = 672
ORDER BY dateJour;

/** 
 * DATEJOUR     NBPASSAGEDE8A12     TEMPERATUREMOYENNE
 * ---------    ---------------     ------------------
 * 01-JAN-20    -                   7.28
 * 02-JAN-20    -                   9.7
 * 03-JAN-20    -                   10.8
 * 04-JAN-20    -                   5.28
 * 05-JAN-20    -                   6
 * 06-JAN-20    -                   4.32
 * 07-JAN-20    -                   10.4
 * 08-JAN-20    -                   11.98
 * ...
 */


----------------------------------------[+]
-- FONCTION DE GROUPE SANS REGROUPEMENT  |
----------------------------------------[+]
---------------------------------------------------------------------[+]
-- 1. Selectionner la temperature moyenne la plus chaude enregistrée  |
---------------------------------------------------------------------[+]
SELECT MAX(temperatureMoyenne)
FROM Jour;

/** 
 * MAX(TEMPERATUREMOYENNE)
 * -----------------------
 * 30.95
 */

 
----------------------------------------------------------------------------------------------[+]
-- 2. Selectionner la moyenne de nombre de passage entre 10h et 11h  (arrondi à l'unité près)  |
----------------------------------------------------------------------------------------------[+]
SELECT ROUND(AVG(h10))
FROM ComptageJour;

/**
 * ROUND(AVG(H10))
 * ---------------
 * 20
 */


----------------------------------------[+]
-- FONCTION DE GROUPE AVEC REGROUPEMENT  |
----------------------------------------[+]
-------------------------------------------------------------------------------[+]
-- 1. Pour chaque compteur, renvoyer la somme de tous les passages enregistrés  |
-------------------------------------------------------------------------------[+]
SELECT leCompteur, SUM(h01 + h02 + h03 + h04 + h05 + h06 + h07 + h08 + h09 + h10 + h11 + h12 + 
                    h13 + h14 + h15 + h16 + h17 + h18 + h19 + h20 + h21 + h22 + h23) nbPassageTotal
FROM ComptageJour
GROUP BY leCompteur;

/** 50 rows selected.
 * LECOMPTEUR NBPASSAGETOTAL
 * ---------- --------------
 *        786        2200922
 *        787        1481841
 *        785        2230384
 *        665         674875
 *        745         131655
 *        944         234822
 *        742        1028058
 *        670         302391
 *        672         609614
 *        674         508966
 *        677         313416
 * ...
 */


------------------------------------------------------------------------------------------[+]
-- 2. Selectionner la moyenne de temperature pour chaque vacance identifié par le nom des  |
--    vacances(Trié par le nom des Vacances)                                               |
------------------------------------------------------------------------------------------[+]
SELECT nomVacances, ROUND(AVG(temperatureMoyenne),2) moyenne
FROM VacancesZoneB, Jour
WHERE dateJour >= dateDebut AND dateJour <= dateFin
GROUP BY nomVacances
ORDER BY nomVacances;

/** 16 rows selected
 * NOMVACANCES  MOYENNE
 * -----------  -------
 * Ete 2020     20.73
 * Ete 2021     19.27
 * Ete 2022     23.36
 * Hiver 2020   9.29
 * Hiver 2021   9.38
 * Hiver 2022   8.18
 * Noel 2019    7.23
 * Noel 2020    6.28
 * ...
 */


----------------------------------------[+]
-- REGROUPEMENT ET RESTRICTION (HAVING)  |
----------------------------------------[+]
-------------------------------------------------------------------------------------------------[+]
-- 1. Selectionner les compteurs qui ont eu au moins 30 fois une anomalie "Forte" et le nombre    |
--    de fois qu'ils ont reçu ce type de probabilité d'anomalie (Trié par ce nombre (décroissant))|
-------------------------------------------------------------------------------------------------[+]

SELECT leCompteur, COUNT(leJour)
FROM (
    SELECT *
    FROM ComptageJour
    WHERE UPPER(probabilitePresenceAnomalie) LIKE '%FORTE%'
)
GROUP BY leCompteur
HAVING COUNT(leJour) >= 30
ORDER BY COUNT(leJour) DESC;

/** 3 rows selected
 * LECOMPTEUR   COUNT(LEJOUR)
 * ----------   -------------
 * 680          36
 * 727          35
 * 677          35
 */


------------------------------------------------------------------[+]
-- 2. Selectionner le nombre de compteur avec et sans observation  |
------------------------------------------------------------------[+]
SELECT observation, COUNT(idCompteur)
FROM Compteur
GROUP BY observation;

/** 2 rows selected
 * OBSERVATION      COUNT(IDCOMPTEUR)
 * -------------    -----------------
 * -                50
 * Releve manuel    8
 */


------------[+]
-- DIVISION  |
------------[+]
------------------------------------------------------------------------------------[+]
-- 1. Trouver tous les compteurs qui ont été actifs tous les jours de janvier 2020   |                                                               --
------------------------------------------------------------------------------------[+]
SELECT leCompteur
FROM (
    SELECT * 
    FROM ComptageJour
    WHERE leJour >= TO_DATE('2020-01-01','YYYY-MM-DD') 
        AND leJour <= TO_DATE('2020-01-31','YYYY-MM-DD')
    )
GROUP by leCompteur
HAVING COUNT(leJour) = 31;

/** 11 rows selected
 * LECOMPTEUR
 * 666
 * 943
 * 890
 * 680
 * 743
 * 672
 * 683
 * ...
 */


----------------------------------[+]
-- TEST DES VALEURS (IN / NOT IN)  |
----------------------------------[+]
----------------------------------------------------------------------------------------------[+]
-- 1. Selectionner les dates de début et de fin des vacances de Noel 2021 et de printemps 2022 |
----------------------------------------------------------------------------------------------[+]
SELECT dateDebut, dateFin
FROM VacancesZoneB
WHERE upper(nomVacances) IN ('NOEL 2021','PRINTEMPS 2022');

/** 2 rows selected
 * DATEDEBUT    DATEFIN
 * ---------    ---------
 * 09-APR-22    25-APR-22
 * 18-DEC-21    03-JAN-22
 */


------------------------------------------[+]
-- TEXT D'EXISTENCE (EXISTS / NOT EXISTS)  |
------------------------------------------[+]
----------------------------------------------[+]
-- 1.Selectionner les jours de vacances d'été  |
----------------------------------------------[+]
SELECT * 
FROM Jour
WHERE EXISTS (
    SELECT * 
    FROM VacancesZoneB
    WHERE dateDebut < dateJour 
    	AND dateFin > dateJour
    	AND UPPER(nomVacances) LIKE '%ETE%'
);

/** 168 rows selected
 * DATEJOUR
 * ---------
 * 30-AUG-22
 * 29-AUG-22
 * 28-AUG-22
 * 27-AUG-22
 * 26-AUG-22
 * 25-AUG-22
 * 24-AUG-22
 * 23-AUG-22
 * ...
 */

