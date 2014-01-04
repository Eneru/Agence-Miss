create or replace procedure ajout_bien
    (
        idutilisateur_p bien_immobilier.idutilisateur%type,
        nbChambres_p bien_immobilier.nbchambres%type,
        nbSdB_p bien_immobilier.nbsdb%type,
        nbCuisines_p bien_immobilier.nbcuisines%type,
        nbGarages_p bien_immobilier.nbgarages%type,
        nbCaves_p bien_immobilier.nbcaves%type,
        surface_p bien_immobilier.surface%type,
        tailleTerrain_p bien_immobilier.tailleterrain%type,
        nbEtages_p bien_immobilier.nbetages%type,
        nbAscenceurs_p bien_immobilier.nbascenceurs%type,
        idImage_p bien_immobilier.idimage%type,
        nomQuartier_p bien_immobilier.nomquartier%type,
        typeBien_p bien_immobilier.typebien%type
    )
IS
    nouvel_id_v bien_immobilier.idbien%type;
BEGIN
    select max(idBien)
        into nouvel_id_v
        from bien_immobilier
    ;
    nouvel_id_v := nouvel_id_v + 1;
    insert into bien_immobilier values
    (
        nouvel_id_v,
        idutilisateur_p,
        nbchambres_p,
        nbSdB_p,
        nbCuisines_p,
        nbGarages_p,
        nbCaves_p,
        surface_p,
        tailleTerrain_p,
        nbEtages_p,
        nbAscenceurs_p,
        idImage_p,
        nomQuartier_p,
        typeBien_p,
        sysdate
    );
END;
/

create or replace procedure changer_infos_utilisateur
(
    idUtilisateur_p utilisateur.idutilisateur%type,
    nom_p utilisateur.nom%type,
    prenom_p utilisateur.prenom%type,
    dateNaissance_p utilisateur.datenaissance%type,
    adresse_p utilisateur.adresse%type,
    courriel_p utilisateur.courriel%type,
    telephone_p utilisateur.telephone%type,
    dateInscription_p utilisateur.dateinscription%type,
    login_p utilisateur.login%type,
    mdp_p utilisateur.mdp%type
)
IS
    idUtilisateur_v utilisateur.idutilisateur%type;
    nom_v utilisateur.nom%type;
    prenom_v utilisateur.prenom%type;
    dateNaissance_v utilisateur.datenaissance%type;
    adresse_v utilisateur.adresse%type;
    courriel_v utilisateur.courriel%type;
    telephone_v utilisateur.telephone%type;
    dateInscription_v utilisateur.dateinscription%type;
    login_v utilisateur.login%type;
    mdp_v utilisateur.mdp%type;
BEGIN
    if (nom_p = null) then
        select nom into nom_v from utilisateur where idutilisateur = idutilisateur_p;
    else
        nom_v := nom_p;
    end if;
    if (prenom_p = null) then
        select prenom into prenom_v from utilisateur where idutilisateur = idutilisateur_p;
    else
        prenom_v := prenom_p;
    end if;
    if (dateNaissance_p = null) then
        select dateNaissance into dateNaissance_v from utilisateur where idutilisateur = idutilisateur_p;
    else
        dateNaissance_v := dateNaissance_p;
    end if;
    if (adresse_p = null) then
        select adresse into adresse_v from utilisateur where idutilisateur = idutilisateur_p;
    else
        adresse_v := adresse_p;
    end if;
    if (courriel_p = null) then
        select courriel into courriel_v from utilisateur where idutilisateur = idutilisateur_p;
    else
        courriel_v := courriel_p;
    end if;
    if (telephone_p = null) then
        select telephone into telephone_v from utilisateur where idutilisateur = idutilisateur_p;
    else
        telephone_v := telephone_p;
    end if;
    if (dateinscription_p = null) then
        select dateinscription into dateinscription_v from utilisateur where idutilisateur = idutilisateur_p;
    else
        dateinscription_v := dateinscription_p;
    end if;
    if (login_p = null) then
        select login into login_v from utilisateur where idutilisateur = idutilisateur_p;
    else
        login_v := login_p;
    end if;
    if (mdp_p = null) then
        select mdp into mdp_v from utilisateur where idutilisateur = idutilisateur_p;
    else
        mdp_v := mdp_p;
    end if;

    update utilisateur set
         nom =                    nom_v,
         prenom =                 prenom_v,
         dateNaissance =          dateNaissance_v,
         adresse =                adresse_v,
         courriel =               courriel_v,
         telephone =              telephone_v,
         dateInscription =        dateInscription_v,
         login =                  login_v,
         mdp =                    mdp_v
    where idUtilisateur = idutilisateur_p;
END;
/

create or replace procedure ajouter_recherche
(
    prixMin_p recherche.prixmin%type,
    prixMax_p recherche.prixMax%type,
    tailleMin_p recherche.tailleMin%type,
    tailleMax_p recherche.tailleMax%type,
    nbPiecesMin_p recherche.nbPiecesMin%type,
    nbPiecesMax_p recherche.nbPiecesMax%type,
    nomQuartier_p recherche.nomQuartier%type
)
IS
    nouvel_id_v recherche.idrecherche%type;
BEGIN
    select max(idrecherche)
        into nouvel_id_v
        from recherche;
    nouvel_id_v := nouvel_id_v + 1;
    insert into recherche values
    (
        nouvel_id_v,
        prixMin_p,
        prixMax_p,
        tailleMin_p,
        tailleMax_p,
        nbPiecesMin_p,
        nbPiecesMax_p,
        nomQuartier_p
    );
END;
/

create or replace function rechercher_vente
(
    prixMin_p recherche.prixmin%type,
    prixMax_p recherche.prixMax%type,
    tailleMin_p recherche.tailleMin%type,
    tailleMax_p recherche.tailleMax%type,
    nbPiecesMin_p recherche.nbPiecesMin%type,
    nbPiecesMax_p recherche.nbPiecesMax%type,
    nomQuartier_p recherche.nomQuartier%type
)
return bien_immobilier.idbien%type
IS
    resultat_v bien_immobilier.idbien%type;
BEGIN
    select idbien
        into resultat_v
        from bien_immobilier natural join vente
        where prixcourant >= prixMin_p
            and prixcourant <= prixmax_p
            and surface >= taillemin_p
            and surface <= taillemax_p
            and nbchambres >= nbpiecesmin_p
            and nbchambres <= nbpiecesmax_p
            and nomquartier = nomquartier_p
            and vendu = 0
            and rownum = 1
        order by prixcourant asc
    ;

    return resultat_v;
END;
/
