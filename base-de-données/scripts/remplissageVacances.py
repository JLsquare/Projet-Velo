#!/bin/python3

if __name__ == '__main__':
    import requests

    officialContent = requests.get("https://www.vacances-scolaires-gouv.com/")
    zoneBIndex = officialContent.text.index("bg-zone-b")
    zoneB = officialContent.text[zoneBIndex:zoneBIndex +250]
    indexDebut = zoneB.index("time datetime")
    debut = zoneB[indexDebut+15:indexDebut+25]
    # print(f"Debut : {debut}")
    zoneB = zoneB[indexDebut+25:]
    indexFin = zoneB.index("time datetime")
    fin = zoneB[indexFin+15:indexFin+25]
    # print(f"Fin : {fin}")

    
    with open("sql/vacances.sql","w") as f :
        string = f"INSERT INTO Vacances VALUES (TO_DATE('{debut}','YYYY-MM-DD'),TO_DATE('{fin}','YYYY-MM-DD'));\n"
        with open("sql/vacances.sql",'r') as read :
            if string not in read.read() :
                f.write(string)