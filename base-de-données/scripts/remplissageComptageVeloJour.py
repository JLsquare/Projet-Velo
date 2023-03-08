#!/bin/python3

"""
Crée le script d'insertion dans la table Boucle a
partir du du fichier csv de geolocalisation des compteurs
"""


# ComptageVeloJour(laBoucle(1) = @Boucle.idBoucle,leJour(1),h00,h01,h02,h03,h04,h05,h06,h07,h08,h09,h10,h11,h12,h13,h14,h15,h16,h17,h18,h19,h20,h21,h22,h23,probaErreur)

# boucle_num;libelle;jour;00;01;02;03;04;05;06;07;08;09;10;11;12;13;14;15;16;17;18;19;20;21;22;23;total;probabilite_presence_anomalie;jour_de_la_semaine;boucle_libelle;dateformat;vacances_zone_b
# x = "0664;Bonduelle vers sud;2023-01-23;4;1;0;0; 1; 0; 6; 49;149;69;21;20;43;41;28;22;54;132;162;82;34;18;15;10;961;;1;0664 - Bonduelle vers sud;2023-01-23;Hors Vacances".split(";")
# print(x)
# print(f"INSERT INTO ComptageVeloJour VALUES ({x[0]},{x[2]},{x[3]},{x[4]},{x[5]},{x[6]},{x[7]},{x[8]},{x[9]},{x[10]},{x[11]},{x[12]},{x[13]},{x[14]},{x[15]},{x[16]},{x[17]},{x[18]},{x[19]},{x[20]},{x[21]},{x[22]},{x[23]},{x[24]},{x[25]},{x[26]},{x[28]});")


if __name__ == '__main__':
    import sys
    import os
    SPLITON = ";"

    # Check correct usage
    if len(sys.argv) != 2:
        print(f"Usage : python3 {sys.argv[0][2:]} comptageVelo.csv")
        quit()

    # Check if the csv file exists
    try:
        x = open(sys.argv[1])
        x.close()
    except:
        print(f"ERROR : {sys.argv[1]} not found")
        quit()

    filename = sys.argv[1]
    TABLENAME = "ComptageVeloJour"
    try : 
        os.remove(f"sql/{TABLENAME}.sql")
        print(f"{TABLENAME}.sql existant : Ecrasement ...")
    except : 
        print(f"{TABLENAME} inexistant : Creation ...")

    # read file
    with open(filename) as f:
        text = f.read().split("\n")[1:] # Split lines and remove the first one because it has column names
        nombreEltParLigne = len(text[0].split(SPLITON))
        for line in text[:-1]:
            eltDeLaLigne = line.split(SPLITON)
            insertion = f"INSERT INTO {TABLENAME} VALUES ("
            for k in [0,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,28]:
                if k == 2 : # Ici on s'occupe de la deuxieme valeur qui est une date de la forme 2020-02-19
                    insertion += f"TO_DATE('{eltDeLaLigne[k]}','YYYY-MM-DD')"
                
                else :
                    if eltDeLaLigne[k] == "":
                        insertion += "NULL"
                    else:
                        # For every element, try to add it as an integer
                        try:
                            insertion += str(int(eltDeLaLigne[k]))
                        except ValueError:
                            # Else, add it as a string
                            # Sometimes, values had a space a the end in our case, idk why
                            insertion += f"'{eltDeLaLigne[k]}'"
                # Add comas where they are useful
                if k != 28:
                    insertion += ","
            insertion += ");"
            with open(f"sql/{TABLENAME}.sql", "w") as bornes:
                bornes.write(insertion + '\n')

    print("Success ! ")