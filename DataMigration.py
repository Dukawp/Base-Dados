#!/usr/bin/python

import mysql.connector
import sys
from pymongo import MongoClient
import datetime


def fetchItems(id,inv):
    print "\n"
    print "\n"
    print id
    items=[]
    for row in inv:
        if row[0]==id:
            print row[1]
            items.append({"nome":row[1],"descricao":row[2]})
        if row[0]>int(id):
            break;
    return items

#abrir conecao a base de dados mysql

c=connection = mysql.connector.connect (user = "root",password="daniel",db = "Trablh")
c2=connection = mysql.connector.connect (user = "root",password="daniel",db = "Trablh")
#abrir coneccao a base de dados mongoDb
client = MongoClient()
#Parte MySQL, queries

cursor = c.cursor()
cursor2=c2.cursor()

cursor.execute ("select * from JogadorEJogo")
cursor2.execute("select * from JogadorInv")
cursr=[]
for row in cursor2:
    cursr.append((int(row[0]),row[1],row[2]))
#migracao dos dados para o mongoDb
mydb = client.TrabalhoDB2

for row in cursor :
    data=row[2].strftime('%m/%d/%Y').split('/')
    d= datetime.datetime(int(data[2]),int(data[0]),int(data[1]),0,0,0)
    record={"nome":row[1],"dataNascimento":d,"password":row[3],"banCheck":row[4],
            "telemovel":row[5],"email":row[6],"mainServer":row[7],"rank":{"disparos":row[8],"headshots":row[9],
                                                           "tirosCertos":row[10],"mortes":row[11],
                                                           "adversariosMortos":row[12]},
            "gameServer":{"nome":row[13],"capacidade":row[14],"mediaPing":row[15],"mapa":row[16],"tipo":row[17]},
            "items": fetchItems(row[0],cursr)}
    mydb.Trabalho2.insert(record)

cursor.close ()
c.close ()
c2.close()
