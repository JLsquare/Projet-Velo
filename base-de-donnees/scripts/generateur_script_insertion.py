#!/bin/python

quartier = {"file" : "../raw/data_quartiers_nantes.csv"}
longueurPistes = {"file" : "../raw/data_longueur_pistes_velo.csv"}
jour = {"file" : "../raw/data_temperature.csv"}
compteur = { "file" : "../raw/data_geolocalisationCompteur.csv"}
locCompteur = {"file" : "../raw/data_quartier_compteur.csv"}
comptage = {"file" : "../raw/data_comptageVelo_nettoye.csv"}

if __name__ == '__main__':

    # Insertion Quartier
    with open(quartier["file"],"r",) as q :
        quartier["contenu"] = q.read().split("\n")[1:-1]
    with open(longueurPistes["file"],"r") as l :
        longueurPistes["contenu"] = l.read().split("\n")[1:-1]
    insertionQuartier = {}
    for qline in quartier["contenu"]:
        for lline in longueurPistes["contenu"] :
            if int(qline.split(";")[0]) == int(lline.split(";")[0]) :
                print(f"INSERT INTO Quartier VALUES ({qline.split(';')[0]},'{qline.split(';')[1]}',{lline.split(';')[1].replace(',','.')});")

    # Insertion VacancesZoneB

    dates = [
    '21-12-2019', '06-01-2020', 'Noel 2019',
    '15-02-2020', '02-03-2020', 'Hiver 2020',
    '11-04-2020', '27-04-2020', 'Printemps 2020',
    '04-07-2020', '01-09-2020', 'Ete 2020',
    '17-10-2020', '02-11-2020', 'Toussaint 2020',
    '19-12-2020', '04-01-2021', 'Noel 2020',
    '20-02-2021', '08-03-2021', 'Hiver 2021',
    '24-04-2021', '10-05-2021', 'Printemps 2021',
    '06-07-2021', '02-09-2021', 'Ete 2021',
    '23-10-2021', '08-11-2021', 'Toussaint 2021',
    '18-12-2021', '03-01-2022', 'Noel 2021',
    '05-02-2022', '21-02-2022', 'Hiver 2022',
    '09-04-2022', '25-04-2022', 'Printemps 2022',
    '07-07-2022', '01-09-2022', 'Ete 2022',
    '22-10-2022', '07-11-2022', 'Toussaint 2022',
    '17-12-2022', '03-01-2023', 'Noel 2022',
    '11-02-2023', '27-02-2023', 'Hiver 2023',
    '15-04-2023', '02-05-2023', 'Printemps 2023',
    '08-07-2023', '04-09-2024', 'Ete 2023',
    ]

    for k in range(0,len(dates),3) :
        print(f"INSERT INTO VacancesZoneB VALUES (TO_DATE('{dates[k]}','DD-MM-YYYY'),TO_DATE('{dates[k+1]}','DD-MM-YYYY'),'{dates[k+2]}');")

    # Insertion Jour

    with open(jour["file"]) as j :
        jour["contenu"] = j.read().split("\n")[1:-1]
        
    
    for line in jour["contenu"] :
        print(f"INSERT INTO Jour VALUES (TO_DATE('{line.split(';')[0]}','YYYY-MM-DD'),{line.split(';')[1].replace(',','.')});")
    nbJour = [31,28,31,30,31,30,31,31,30,31,30,31]

    
    for annee in range(2020,2024):
        for mois in range(1,13) :
            if mois < 10 :
                mois = f"0{mois}"
                
            for day in range(1,nbJour[int(mois) - 1] + 1):
                if int(day) < 10 :
                    day = f"0{day}"
                date = f"{annee}-{mois}-{day}"
                present = False
                for entry in jour["contenu"]:
                    if date in entry :
                        present = True
                if not present :
                    print(f"INSERT INTO Jour VALUES (TO_DATE('{date}','YYYY-MM-DD'),NULL);")
                    
    # Insertion Compteur

    with open(compteur["file"]) as c :
        compteur["contenu"] = c.read().split("\n")[1:-1]
    with open(locCompteur["file"]) as lc :
        locCompteur["contenu"] = lc.read().split("\n")[1:-1]

    for line in compteur["contenu"] :
        observation = line.split(";")[2]
        if observation == '':
            observation = 'NULL'
        else :
            observation = "'" + observation + "'"

        quartier = 'NULL'
        for couple in locCompteur["contenu"] :
            if line.split(";")[0] == couple.split(";")[0] :
                quartier = couple.split(";")[1]
        if quartier == '':
            quartier = 'NULL'
        print(f"INSERT INTO Compteur VALUES({line.split(';')[0]},'{line.split(';')[1]}',{observation},{line.split(';')[3].split(',')[0]},{line.split(';')[3].split(',')[0]},{quartier});")

    # Insertion ComptageJour
    
    with open(comptage["file"]) as c :
        comptage["contenu"] = c.read().split("\n")[1:-1]
    for line in comptage["contenu"] :
        line = line.split(';')
        insertion = f"INSERT INTO ComptageJour VALUES ({int(line[0])},TO_DATE('{line[2]}','YYYY-MM-DD'),"
        for k in [3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26]:
            if line[k] == '':
                insertion += 'NULL'
            else :
                insertion += line[k]
            insertion += ","
        if line[28] == '':
            insertion += 'NULL'
        else :
            insertion += "'"+line[28]+"'"
        insertion += ");"
        print(insertion)