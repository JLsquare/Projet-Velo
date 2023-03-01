#!/bin/python3

"""
Crée le script d'insertion dans la table Boucle a
partir du du fichier csv de geolocalisation des compteurs
"""

if __name__ == '__main__':
    import sys
    SPLITON = ";"

    # Check correct usage
    if len(sys.argv) != 3:
        print(f"Usage : python3 {sys.argv[0][2:]} filename.csv TableName")
        quit()

    # Check if the csv file exists
    try:
        x = open(sys.argv[1])
        x.close()
    except:
        print(f"ERROR : {sys.argv[1]} not found")
        quit()

    filename = sys.argv[1]
    tableName = sys.argv[2]

    # read file
    with open(filename) as f:
        text = f.read().split("\n")[1:] # Split lines and remove the first one because it has column names
        nombreEltParLigne = len(text[0].split(SPLITON))
        for line in text[:-1]:
            eltDeLaLigne = line.split(SPLITON)
            insertion = f"INSERT INTO {tableName} VALUES ("
            for k in range(nombreEltParLigne):
                # Particularity of our csv file, the last element needed to be split
                if k == 3 :
                    try : 
                        if len(eltDeLaLigne[k].split(",")) == 2:
                            insertion += eltDeLaLigne[k].split(",")[0] +"," +eltDeLaLigne[k].split(",")[1]
                    except :
                        continue

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
                            if eltDeLaLigne[k][-1] == " ":
                                insertion += f"'{eltDeLaLigne[k][:-1]}'"
                            else:
                                insertion += f"'{eltDeLaLigne[k]}'"
                # Add comas where they are useful
                if k < nombreEltParLigne - 1:
                    insertion += ","
            insertion += ");"
            with open("bornes.sql", "a") as bornes:
                bornes.write(insertion + '\n')

