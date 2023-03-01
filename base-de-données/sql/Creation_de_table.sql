------------------------------------------------------------------
-- SCRIPT DE CREATION DE LA BASE DE DONNÉES POUR LE PROJET VELO --
------------------------------------------------------------------


------------------------
-- SCHEMA RELATIONNEL --
------------------------

/*

Vacances(dateDebut(1),dateFin(1))

Boucle(idBoucle(1),Libelle,PositionLat,PositionLong)

ComptageVeloJour(laBoucle(1) = @Boucle.idBoucle,leJour(1),h00,h01,h02,h03,h04,h05,h06,h07,h08,h09,h10,h11,h12,h13,h14,h15,h16,h17,h18,h19,h20,h21,h22,h23,probaErreur)

*/



DROP TABLE ComptageVeloJour;
DROP TABLE Borne;
DROP TABLE Vacances;


CREATE TABLE Vacances (
  dateDebut DATE,
  dateFin DATE,
  CONSTRAINT ck_dateDebut_date_fin CHECK (dateFin > dateDebut),
  CONSTRAINT pk_Vacances PRIMARY KEY (dateDebut, dateFin)
);

CREATE TABLE Boucle (
  idBoucle NUMBER 
    CONSTRAINT pk_Boucle PRIMARY KEY,
  Libelle VARCHAR2(255),
  Observation VARCHAR2(255),
  PositionLat FLOAT,
  PositionLong FLOAT
);





CREATE TABLE ComptageVeloJour (
  laBoucle NUMBER 
    CONSTRAINT fk_ComptageVeloJour_Boucle REFERENCES Boucle(idBoucle),
  leJour DATE,
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
  probaErreur VARCHAR2(50) 
  CONSTRAINT ck_probaErreur CHECK (probaErreur IN ('Faible', 'Forte', NULL)),
  CONSTRAINT pk_ComptageVeloJour PRIMARY KEY (laBoucle, leJour)
);