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
