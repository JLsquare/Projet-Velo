--------------------------------------------------------------------------[+]
-- SCRIPT DE CREATION DE LA BASE DE DONNEES POUR LE PROJET VELO DE NANTES  |
--------------------------------------------------------------------------[+]

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

----------------------[+]
-- SCHEMA RELATIONNEL  |
----------------------[+]

/*

Quartier(idQuartier(1), nomQuartier, longueurAmenagementCyclable)

Compteur(idCompteur(1), libelle, observation, latitude, longitude, leQuartier = @Quartier.idQuartier)

Jour(date(1), temperatureMoyenne)

VacancesZoneB(dateDebut(1)), dateFin, nomVacances)

ComptageJour(unCompteur = Compteur.idCompteur (1), unJour = @Jour.date(1), h00,h01,h02,h03,h04,h05,h06,h07,h08,h09,h10,h11,h12,h13,h14,h15,h16,h17,h18,h19,h20,h21,h22,h23,probabilitePresenceErreur)

*/

---------------------[+]
-- SCRIPT DE CREATION |
---------------------[+]

DROP TABLE ComptageJour;
DROP TABLE Compteur;
DROP TABLE Jour;
DROP TABLE VacancesZoneB;
DROP TABLE Quartier;


CREATE TABLE Quartier (
	idQuartier NUMBER
		CONSTRAINT pk_Quartier PRIMARY KEY,
	nomQuartier VARCHAR2(50),
	longueurAmenagementCyclable NUMBER
		CONSTRAINT ck_longueurAmenagementCyclable CHECK (longueurAmenagementCyclable > 0)
);


CREATE TABLE VacancesZoneB (
  	dateDebut DATE
  		CONSTRAINT pk_Vacances PRIMARY KEY,
  	dateFin DATE,
  		CONSTRAINT ck_dateDebut_date_fin CHECK (dateFin > dateDebut),
  	nomVacances VARCHAR2(50)
);

CREATE TABLE Jour (
	dateJour DATE
		CONSTRAINT pk_Jour PRIMARY KEY,
	temperatureMoyenne NUMBER
);

CREATE TABLE Compteur (
	idCompteur NUMBER
		CONSTRAINT pk_Compteur PRIMARY KEY,
	libelle VARCHAR2(50),
	observation VARCHAR2(100),
	latitude NUMBER,
	longitude NUMBER,
	leQuartier NUMBER
		CONSTRAINT fk_Compteur_Quartier REFERENCES Quartier(idQuartier)
);

CREATE TABLE ComptageJour (
	leCompteur NUMBER
		CONSTRAINT fk_ComptageJour_Compteur REFERENCES Compteur(idCompteur),
	leJour DATE
		CONSTRAINT fk_ComptageJour_Jour REFERENCES Jour(dateJour),
	h00 NUMBER 
	    CONSTRAINT ck_0h CHECK (h00 >= 0),
	h01 NUMBER 
	    CONSTRAINT ck_1h CHECK (h01 >= 0),
	h02 NUMBER 
	    CONSTRAINT ck_h2 CHECK (h02 >= 0),
	h03 NUMBER 
	    CONSTRAINT ck_3h CHECK (h03 >= 0),
	h04 NUMBER 
	    CONSTRAINT ck_4h CHECK (h04 >= 0),
	h05 NUMBER 
	    CONSTRAINT ck_5h CHECK (h05 >= 0),
	h06 NUMBER 
	    CONSTRAINT ck_6h CHECK (h06 >= 0),
	h07 NUMBER 
	    CONSTRAINT ck_7h CHECK (h07 >= 0),
	h08 NUMBER 
	    CONSTRAINT ck_8h CHECK (h08 >= 0),
	h09 NUMBER 
	    CONSTRAINT ck_9h CHECK (h09 >= 0),
	h10 NUMBER 
	    CONSTRAINT ck_10h CHECK (h10 >= 0),
	h11 NUMBER 
	    CONSTRAINT ck_11h CHECK (h11 >= 0),
	h12 NUMBER 
	    CONSTRAINT ck_12h CHECK (h12 >= 0),
	h13 NUMBER 
	    CONSTRAINT ck_13h CHECK (h13 >= 0),
	h14 NUMBER 
	    CONSTRAINT ck_14h CHECK (h14 >= 0),
	h15 NUMBER 
	    CONSTRAINT ck_15h CHECK (h15 >= 0),
	h16 NUMBER 
	    CONSTRAINT ck_16h CHECK (h16 >= 0),
	h17 NUMBER 
	    CONSTRAINT ck_17h CHECK (h17 >= 0),
	h18 NUMBER 
	    CONSTRAINT ck_18h CHECK (h18 >= 0),
	h19 NUMBER 
	    CONSTRAINT ck_19h CHECK (h19 >= 0),
	h20 NUMBER 
	    CONSTRAINT ck_20h CHECK (h20 >= 0),
	h21 NUMBER 
	    CONSTRAINT ck_21h CHECK (h21 >= 0),
	h22 NUMBER 
	    CONSTRAINT ck_22h CHECK (h22 >= 0),
	h23 NUMBER 
	    CONSTRAINT ck_23h CHECK (h23 >= 0),
	probabilitePresenceAnomalie VARCHAR2(50) 
	    CONSTRAINT ck_probabilitePresenceAnomalie CHECK (UPPER(probabilitePresenceAnomalie) IN ('FAIBLE', 'FORTE', NULL)),
	CONSTRAINT pk_ComptageJour PRIMARY KEY (leCompteur, leJour)
);
