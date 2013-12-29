-- USERS
--Directeur
insert into utilisateur
values (1,'MEYER','Jeremy',22-01-1993,'51 rue Schott Strasbourg','jeremy.meyer@etu.unistra.fr',0633884935,14-07-2012,'jmeyer','motdepasse');

insert into personnel
values (1,1,'directeur',10000.92);
--

--Agent immobilier
insert into utilisateur
values (2,'RAZANAJATO','Harenome',10-03-1992,'28 Strassburgstrasse Kehl','razanajato@etu.unistra.fr',0692781423,25-12-2012,'hranaz','crypte');

insert into personnel
values (2,2,'agent immobilier',2500);
--

--Acheteur
insert into utilisateur
values (3,'SISI','Lafamille',09-03-1993,'93 izi Paris','rakaydu93@hotmail.com',0793939393,02-09-2013,'ghettoyou','93izi');
--

--Secretaire
insert into utilisateur
values (4,'GORDON','Melinda',28-04-1975,'23 rue du Paradis Eden','jeparleauxfantomes@msn.fr',0349687591,07-11-2013,'faon','tome');

insert into personnel
values (3,4,'secretaire',1050.12);
--

--Acheteur
insert into utilisateur
values (5,'NOEL','Pere',25-12-1855,'25 rue de Noel Pole Nord','pere.noel@etu.unistra.fr',36656565,25-12-2013,'pere','noel');
--

--Personnel administratif
insert into utilisateur
values (6,'ROUTE','Tri',29-02-1984,'42 route de la Wantzenau Strasbourg','lard.bain@gmail.fr',0801040608,27-12-2013,'root','root');

insert into personnel
values (4,6,'personnel administratif',1251.47);
--

--Acheteur
insert into utilisateur
values (7,'DE MYRE','Nicolas',06-12-270,'14 rue de l''Eglise Sarreguemines','saint.nicolas@etu.unistra.fr',0312345678,28-12-2013,'saint','nicolas');
--

--Vendeur
insert into utilisateur
values (8,'BON','Jean',23-05-1988,'Bois de Boulogne Paris','jeanbon.beurre@orange.fr',0488091523,31-12-2014,'bonne','annee');
--

-- REGIONS
insert into region
values ('Alsace');

insert into region
values ('Aquitaine');

insert into region
values ('Auvergne');

insert into region
values ('Bourgogne');

insert into region
values ('Bretagne');

insert into region
values ('Centre');

insert into region
values ('Champagne-Ardenne');

insert into region
values ('Corse');

insert into region
values ('Franche-Comte');

insert into region
values ('Guadeloupe');

insert into region
values ('Guyane');

insert into region
values ('Ile-de-France');

insert into region
values ('Languedoc-Roussillon');

insert into region
values ('Limousin');

insert into region
values ('Lorraine');

insert into region
values ('Martinique');

insert into region
values ('Mayotte');

insert into region
values ('Midi-Pyrenees');

insert into region
values ('Nord-Pas-de-Calais');

insert into region
values ('Basse-Normandie');

insert into region
values ('Haute-Normandie');

insert into region
values ('Pays de la Loire');

insert into region
values ('Picardie');

insert into region
values ('Poitou-Charentes');

insert into region
values ('Provence-Alpes-Cote d''Azur');

insert into region
values ('La Reunion');

insert into region
values ('Rhone-Alpes');

-- VILLES
insert into ville
values ('Strasbourg');

insert into ville
values ('Illkirsch-Graffenstaten');

insert into ville
values ('Sarreguemines');

insert into ville
values ('Paris');

insert into ville
values ('Metz');

insert into ville
values ('Lyon');

-- QUARTIERS
insert into quartier
values('Robertsau');

insert into quartier
values('Meinau');

insert into quartier
values('Bois de Boulogne');

insert into quartier
values('Beausoleil');

insert into quartier
values('Borny');

insert into quartier
values('Bellecour');

-- MISE EN RELATION VILLE QUARTIER
insert into quartier_ville
values('Robertsau','Strasbourg');

insert into quartier_ville
values('Meinau','Strasbourg');

insert into quartier_ville
values('Bois de Boulogne','Paris');

insert into quartier_ville
values('Beausoleil','Sarreguemines');

insert into quartier_ville
values('Borny','Metz');

insert into quartier_ville
values('Bellecour','Lyon');

-- MISE EN RELATION REGION VILLE
insert into ville_region
values('Strasbourg','Alsace');

insert into ville_region
values('Illkirsch-Graffenstaten','Alsace');

insert into ville_region
values('Sarreguemines','Lorraine');

insert into ville_region
values('Paris','Ile-de-France');

insert into ville_region
values('Metz','Lorraine');

insert into ville_region
values('Lyon','Rhone-Alpes');