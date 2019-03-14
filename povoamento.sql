use mydb;

insert into Tipo
	(descricao)
	values
	("Oficial"),("Não Oficial");

insert into Mapa
	(nome,Tipo_id)
    values
    ("Forest",1),
    ("Futurism",1),
    ("Space Ship",1),
    ("Meteor Crash Site",1),
    ("Clouds",2),
    ("Green field",2),
    ("Desert",1),
    ("City",2),
    ("Dust",1),
    ("Paks",2);
    
insert into MainServer (id) values (1);

delimiter $$
create trigger updateJogadoresOnline
	after update on Jogador 
    for each row
begin
update MainServer m
	set m.jogadoresOnline =(
		select count(MainServer_id) from Jogador
    );
end$$

delimiter $$
create trigger updateJogadoresEmPartida
	after update on Jogador 
    for each row
begin
update MainServer m
    set m.jogadoresEmPartida=(
		select count(GameServer_id) from Jogador
        );
end$$

delimiter $$
create trigger updateJogadoresOnlineOnInsert
	after insert on Jogador 
    for each row
begin
update MainServer m
	set m.jogadoresOnline =(
		select count(MainServer_id) from Jogador
    );
end$$

delimiter $$
create trigger updateJogadoresEmPartidaOnInsert
	after insert on Jogador 
    for each row
begin
update MainServer m
	set m.jogadoresEmPartida=(
		select count(GameServer_id) from Jogador
        );
end$$

insert into GameServer
	(nome,capacidade,mediaPing,Mapa_id,MainServer_id)
    values
    ("Tea Party",8,20.4,2,1),
    ("Join AXE team",12,15.3,5,1),
    ("Portugal",8,21.4,6,1),
    ("Spain Terror",6,10.8,2,1),
    ("Sniper Association",24,30.2,4,1),
    ("Forces United",8,20.4,4,1),
    ("Desert Operations",8,17.9,7,1),
    ("No man team",12,12.4,5,1),
    ("All round",16,14.3,7,1);

insert into Item
	(nome,descricao)
    values
    ("AK 47","Arma automática de medio alcance"),
    ("Granada","Granada de mão destruidora"),
	("MP7","Submetralhadora"),
    ("Granada de fumo","Granada de mão que provoca uma nuvem de fumo"),
    ("Colete de kevlar","Proteção contra balas e pequenos projecteis"),
    ("RPG","Lança misseis de grande alcance"),
    ("Espada japonesa","Espada clássica japonesa, efetiva a curto alcançe"),
    ("AWP","Arma de longo alcance de alto calibre"),
	("Desert Eagle","pistola semi-automática de alto calibre"),
    ("Revolver","Morte certa num curto alcance"),
    ("Espingarda canos cerrados","Destruição total do adversário"),
	("Glock","Pistola semi-automática com modo de rajada"),
    ("Colt","Arma automática de medio alcance"),
    ("Taser","Frita-o bem frito com este taser"),
    ("P90","Submetralhadora"),
    ("Scout","Arma de longo alcance");

insert into Jogador
	(nome,dataNascimento,Password,banCheck,telemovel,email,GameServer_id,MainServer_id)
    value
	("Diogo Brandão",'2010-01-01',"gdsnvdaewafr",False,912345656,"dbrand@mail.pt",1,1),
    ("John",'1980-04-03',"324daewafr",False,95232565,"john@mail.pt",1,1),
    ("Cactus",'1998-04-24',"gds443lkj",False,912988756,"vyb@mail.pt",2,1),
    ("leetawp",'1997-01-27',"noskill",False,912988756,"leet@mail.pt",2,1),
    ("Duk",'1997-01-27',"awpt",False,912988756,"duk@mail.pt",2,1),
    ("Fidalgo",'1985-08-12',"3243gjmmvsdan",False,942345560,"fid@mail.pt",3,1),
    ("Asdrúbal",'1995-01-18',"09uitora",False,932789560,"asimi@mail.pt",3,1),
    ("Trigo",'2000-05-23',"32rtt55mvsdan",False,92388880,"trigo@mail.pt",3,1),
    ("Camper",'2000-12-03',"qawsed",False,9258270,"camp@mail.pt",3,1),
    ("Algoritmo",'1985-08-14',"mnhyui545",False,987678000,"algo@mail.pt",3,1),
    ("Vyb",'1985-08-14',"noskillvyb",False,987634032,"vyb@mail.pt",2,1),
    ("Caloteiro",'1993-01-30',"calotas",False,940000000,"calot@mail.pt",3,1),
    ("Facadas",'1998-07-25',"knifeh",False,940360015,"knifes@mail.pt",2,1),
    ("Pato",'1992-10-30',"cctech",False,940000001,"ccpato@mail.pt",3,1);

insert into Rank
		 (disparos,headshots,tirosCertos, mortes, adversariosMortos, Jogador_id)
         value
         (139186,9473,64703,27082,32017,1),
		 (39186,1473,14703,2389,6017,2),
         (28912,928,12001,3910,7291,3),
         (982317,98073,521703,327582,453491,4),
         (739186,89473,624703,241782,473017,5),
         (8311,373,5416,1377,2392,6),
         (273,27,98,19,46,7),
         (82038,1003,52390,12325,24703,8),
         (8312,374,5417,1377,2393,9),
         (8312,373,5418,1379,2392,10),
         (982321,98088,521891,347582,423491,11),
         (139486,8473,71703,33082,37017,12),
         (787186,49473,524703,211782,443017,13),
         (102712,763,5218,979,1562,14);
         

delimiter $$
create procedure RankingGeral()
begin
select Jogador.nome,(((r.adversariosMortos/r.mortes)+(r.tirosCertos/r.disparos))+(r.headshots*0.3)) mod 100 as Pontuacao from Jogador
	inner join Rank as r
    on Jogador.id=r.Jogador_id
    order by Pontuacao desc;
end $$

delimiter $$
create procedure RankingGeralLimitado(in n INT)
begin
select Jogador.nome,(((r.adversariosMortos/r.mortes)+(r.tirosCertos/r.disparos))+(r.headshots*0.3)) mod 100 as Pontuacao from Jogador
	inner join Rank as r
    on Jogador.id=r.Jogador_id
    order by Pontuacao desc
    limit n;
end $$

insert into JogadorItem
	(Item_id,Jogador_id)
    values
    (1,1),
    (1,3),
    (1,6),
    (1,7),
    (1,8),
    (2,4),
    (2,2),
    (2,3),
    (2,6),
    (3,1),
    (3,6),
    (3,7),
    (3,16),
    (3,15),
    (4,1),
    (4,5),
    (4,11),
    (4,13),
    (4,12),
    (5,14),
    (5,13),
    (5,1),
    (5,16),
    (5,4),
    (6,1),
    (6,4),
    (6,5),
    (6,6),
    (6,7),
    (6,10),
    (7,13),
    (7,14),
    (7,15),
    (7,16),
    (7,10),
    (8,13),
    (8,10),
    (8,12),
    (8,9),
    (9,13),
    (9,4),
    (9,7),
    (9,8),
    (9,9),
    (10,16),
    (10,11),
    (10,6),
    (10,8),
    (10,7),
    (11,14),
    (11,12),
    (11,13),
    (11,6),
    (11,7),
    (11,16),
    (12,4),
    (12,6),
    (12,9),
    (12,2),
    (13,16),
    (13,14),
    (13,12),
    (13,11),
    (14,16),
    (14,1),
    (14,15),
    (14,2),
    (14,3);
    