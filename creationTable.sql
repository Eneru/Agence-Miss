create table QUARTIER
(
    nomQuartier varchar2(32) primary key
);

create table VILLE
(
    nomVille varchar2(32) primary key
);

create table REGION
(
    nomRegion varchar2(32) primary key
);

create table QUARTIER_VILLE
(
    nomQuartier varchar2(32),
    nomVille varchar2(32),
    primary key (nomQuartier,nomVille),
    foreign key (nomQuartier) references QUARTIER,
    foreign key (nomVille) references Ville
);

create table VILLE_REGION
(
    nomVille varchar2(32),
    nomRegion varchar2(32),
    primary key (nomVille,nomRegion),
    foreign key (nomVille) references Ville,
    foreign key (nomRegion) references REGION
);

create table UTILISATEUR
(
    idUtilisateur integer primary key,
    nom varchar2(32) not null,
    prenom varchar2(32) not null,
    dateNaissance date not null,
    adresse varchar2(64) not null,
    courriel varchar2(64) not null,
    telephone integer not null,
    dateInscription date not null,
    login varchar(16) not null,
    mdp varchar(16) not null,
    UNIQUE (courriel,telephone,login,mdp),
    CHECK (dateNaissance < dateInscription)
);

create table PERSONNEL
(
    idPersonnel integer primary key,
    idUtilisateur integer,
    typePersonnel varchar2(32) not null,
    salaire float not null,
    foreign key (idUtilisateur) references UTILISATEUR,
    CHECK
    (
        salaire >= 0.
        AND lower(typePersonnel) IN ('directeur','secretaire','personnel administratif','agent immobilier')
    )
);

create table AGENT_INFO
(
    idPersonnel integer primary key,
    nombre_de_ventes integer default 0,
    benefice_total float default 0,
    foreign key (idPersonnel) references PERSONNEL
);

create table IMAGE
(
    idImage integer primary key,
    image_complete BLOB not null
);
create table RELATIONS_CLIENT
(
    idPersonnel integer,
    idUtilisateur integer,
    primary key (idPersonnel,idUtilisateur),
    foreign key (idPersonnel) references PERSONNEL,
    foreign key (idUtilisateur) references UTILISATEUR
);

create table RECHERCHE
(
    idRecherche integer primary key,
    prixMin float not null,
    prixMax float not null,
    tailleMin integer not null,
    tailleMax integer not null,
    nbPiecesMin number(3) not null,
    nbPiecesMax number(3) not null,
    nomQuartier varchar2(32) not null,
    foreign key (nomQuartier) references QUARTIER,
    CHECK
    (
        prixMin > 0.
        AND prixMax >= prixMin
        AND tailleMin > 0
        AND tailleMax >= tailleMin
        AND nbPiecesMin > 0
        AND nbPiecesMax >= nbPiecesMin
    )
);

create table RECHERCHE_CLIENT
(
    idUtilisateur integer,
    idRecherche integer,
    primary key (idUtilisateur, idRecherche),
    foreign key (idUtilisateur) references UTILISATEUR,
    foreign key (idRecherche) references RECHERCHE
);

create table BIEN_IMMOBILIER
(
    idBien integer primary key,
    idUtilisateur integer not null,
    nbChambres number(2) not null,
    nbSdB number(1) not null,
    nbCuisines number(1) not null,
    nbGarages number(1) not null,
    nbCaves number(1) not null,
    surface integer not null,
    tailleTerrain integer not null,
    nbEtages number(2) not null,
    nbAscenceurs number(1) not null,
    idImage integer,
    nomQuartier varchar2(32) not null,
    typeBien varchar2(12) not null,
    dateInitiale date,
    foreign key (idUtilisateur) references UTILISATEUR,
    foreign key (nomQuartier) references QUARTIER,
    foreign key (idImage) references IMAGE,
    CHECK
    (
        nbChambres >= 0
        AND nbSdB >= 0
        AND nbCuisines >= 0
        AND nbGarages >= 0
        AND nbCaves >= 0
        AND surface > 0
        AND tailleTerrain >= 0
        AND nbEtages >= 0
        AND nbAscenceurs >= 0
        AND lower(typeBien) IN ('maison','appartement')
    )
);

create table RESERVATION_CRENEAU
(
    idBien integer,
    dateR date,
    idUtilisateur integer not null,
    idPersonnel integer not null,
    duree integer not null,--en minutes
    primary key (idBien, dateR, idUtilisateur),
    foreign key (idBien) references BIEN_IMMOBILIER,
    foreign key (idUtilisateur) references UTILISATEUR,
    foreign key (idPersonnel) references PERSONNEL,
    CHECK (duree > 0)
);

create table LOCATION
(
    idLocation integer primary key,
    idBien integer not null,
    idUtilisateur integer,
    loyer float not null,
    charges float not null,
    fraisAgence float not null,
    loue number(1) default 0,
    dateLocation date default null,
    foreign key (idBien) references BIEN_IMMOBILIER,
    foreign key (idUtilisateur) references UTILISATEUR,
    CHECK
    (
        loyer > 0.
        AND charges >= 0.
        AND fraisAgence >= 0.
        AND fraisAgence <= loyer
    )
);

create table VENTE
(
    idVente integer primary key,
    idBien integer not null,
    idUtilisateur integer,
    prixInitial float not null,
    prixCourant float,
    marge float not null,
    fraisAgence float not null, -- pourcentage
    vendu number(1) default 0,
    dateVente date default null,
    foreign key (idBien) references BIEN_IMMOBILIER,
    foreign key (idUtilisateur) references UTILISATEUR,
    CHECK
    (
        prixInitial >= prixCourant
        AND marge >= 0.
        AND prixCourant >= prixInitial - marge
        AND fraisAgence >= 0.03
        AND fraisAgence <= 0.10
    )
);

create table HISTORIQUE_LOCATION
(
    idHistLocation integer primary key,
    idBien integer not null,
    idUtilisateur integer,
    loyer float not null,
    charges float not null,
    fraisAgence float not null,
    loue number(1) not null,
    dateLocation date,
    foreign key (idBien) references BIEN_IMMOBILIER,
    foreign key (idUtilisateur) references UTILISATEUR,
    CHECK
    (
        loyer > 0.
        AND charges >= 0.
        AND fraisAgence >= 0.
        AND fraisAgence <= loyer
    )
);

create table HISTORIQUE_VENTE
(
    idHistVente integer primary key,
    idBien integer not null,
    idUtilisateur integer,
    prixInitial float not null,
    prixVente float not null,
    fraisAgence float not null,
    vendu number(1) not null,
    dateVente date,
    benefice float not null,
    foreign key (idBien) references BIEN_IMMOBILIER,
    foreign key (idUtilisateur) references UTILISATEUR,
    CHECK
    (
        prixInitial >= prixVente
        AND prixVente > 0.
        AND fraisAgence >= 0.03
        AND fraisAgence <= 0.10
    )
);
