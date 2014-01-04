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
    mdp_p utilisateur.mdp%type,
)
IS
    idUtilisateur_v utilisateur.idutilisateur%type,
    nom_v utilisateur.nom%type,
    prenom_v utilisateur.prenom%type,
    dateNaissance_v utilisateur.datenaissance%type,
    adresse_v utilisateur.adresse%type,
    courriel_v utilisateur.courriel%type,
    telephone_v utilisateur.telephone%type,
    dateInscription_v utilisateur.dateinscription%type,
    login_v utilisateur.login%type,
    mdp_v utilisateur.mdp%type,

BEGIN
    if (nom_p = null) then
        select nom from utilisateur into nom_v where idutilisateur = idutilisateur_p;
    else
        nom_v := nom_p;
    end if;
    if (prenom_p = null) then
        select prenom from utilisateur into prenom_v where idutilisateur = idutilisateur_p;
    else
        prenom_v := prenom_p;
    end if;
    if (dateNaissance_p = null) then
        select dateNaissance from utilisateur into dateNaissance_v where idutilisateur = idutilisateur_p;
    else
        dateNaissance_v := dateNaissance_p;
    end if;
    if (adresse_p = null) then
        select adresse from utilisateur into adresse_v where idutilisateur = idutilisateur_p;
    else
        adresse_v := adresse_p;
    end if;
    if (courriel_p = null) then
        select courriel from utilisateur into courriel_v where idutilisateur = idutilisateur_p;
    else
        courriel_v := courriel_p;
    end if;
    if (telephone_p = null) then
        select telephone from utilisateur into telephone_v where idutilisateur = idutilisateur_p;
    else
        telephone_v := telephone_p;
    end if;
    if (dateinscription_p = null) then
        select dateinscription from utilisateur into dateinscription_v where idutilisateur = idutilisateur_p;
    else
        dateinscription_v := dateinscription_p;
    end if;
    if (login_p = null) then
        select login from utilisateur into login_v where idutilisateur = idutilisateur_p;
    else
        login_v := login_p;
    end if;
    if (mdp_p = null) then
        select mdp from utilisateur into mdp_v where idutilisateur = idutilisateur_p;
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
