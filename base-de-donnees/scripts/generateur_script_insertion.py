#!/bin/python

data_files = {
    "quartier": "../raw/data_quartiers_nantes.csv",
    "longueurPistes": "../raw/data_longueur_pistes_velo.csv",
    "jour": "../raw/data_temperature.csv",
    "compteur": "../raw/data_geolocalisationCompteur.csv",
    "locCompteur": "../raw/data_quartier_compteur.csv",
    "comptage": "../raw/data_comptageVelo_nettoye.csv",
}

def read_file(file_path):
    with open(file_path, "r") as f:
        return f.read().split("\n")[1:-1]

def insert_quartier():
    quartier_data = read_file(data_files["quartier"])
    longueurPistes_data = read_file(data_files["longueurPistes"])

    for qline in quartier_data:
        for lline in longueurPistes_data:
            if int(qline.split(";")[0]) == int(lline.split(";")[0]):
                print(f"INSERT INTO Quartier VALUES ({qline.split(';')[0]},'{qline.split(';')[1]}',{lline.split(';')[1].replace(',','.')});")

def insert_vacancesZoneB():
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

    for i in range(0, len(dates), 3):
        print(f"INSERT INTO VacancesZoneB VALUES (TO_DATE('{dates[i]}','DD-MM-YYYY'),TO_DATE('{dates[i+1]}','DD-MM-YYYY'),'{dates[i+2]}');")

def insert_jour():
    jour_data = read_file(data_files["jour"])
    nbJour = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    for line in jour_data:
        print(f"INSERT INTO Jour VALUES (TO_DATE('{line.split(';')[0]}','YYYY-MM-DD'),{line.split(';')[1].replace(',','.')});")

    for annee in range(2020, 2024):
        for mois in range(1, 13):
            if mois < 10:
                mois = f"0{mois}"

            for day in range(1, nbJour[int(mois) - 1] + 1):
                if int(day) < 10:
                    day = f"0{day}"
                date = f"{annee}-{mois}-{day}"
                present = False
                for entry in jour_data:
                    if date in entry:
                        present = True
                if not present:
                    print(f"INSERT INTO Jour VALUES (TO_DATE('{date}','YYYY-MM-DD'),NULL);")

def insert_compteur():
    compteur_data = read_file(data_files["compteur"])
    locCompteur_data = read_file(data_files["locCompteur"])

    for line in compteur_data:
        observation = line.split(";")[2]
        if observation == '':
            observation = 'NULL'
        else:
            observation = "'" + observation + "'"

        quartier = 'NULL'
        for couple in locCompteur_data:
            if line.split(";")[0] == couple.split(";")[0]:
                quartier = couple.split(";")[1]
        if quartier == '':
            quartier = 'NULL'
        print(f"INSERT INTO Compteur VALUES({line.split(';')[0]},'{line.split(';')[1]}',{observation},{line.split(';')[3].split(',')[0]},{line.split(';')[3].split(',')[0]},{quartier});")

def insert_comptageJour():
    comptage_data = read_file(data_files["comptage"])

    for line in comptage_data:
        line = line.split(';')
        insertion = f"INSERT INTO ComptageJour VALUES ({int(line[0])},TO_DATE('{line[2]}','YYYY-MM-DD'),"
        for k in range(3, 27):
            if line[k] == '':
                insertion += 'NULL'
            else:
                insertion += line[k]
            insertion += ","
        if line[28] == '':
            insertion += 'NULL'
        else:
            insertion += "'" + line[28] + "'"
        insertion += ");"
        print(insertion)

if __name__ == "__main__":
    insert_quartier()
    insert_vacancesZoneB()
    insert_jour()
    insert_compteur()
    insert_comptageJour()

