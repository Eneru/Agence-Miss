-- Retourne le chiffre d'affaires d'un agent
create or replace function chiffreAgent
    (idPersonnel_p personnel.idPersonnel%type)
    return agent_info.benefice_total%type
is
    somme_v historique_vente.fraisAgence%type;
    somme_erreur_v historique_vente.fraisAgence%type;
    compte_perso_v integer;
    AGENT_INEXISTANT exception;
BEGIN
    select count(*)
    into compte_perso_v
    from agent_info
    where idPersonnel_p = idPersonnel;

    if (compte_perso_v != 1) then
        somme_erreur_v := -1.;
        raise AGENT_INEXISTANT;
    end if;
    select benefice_total
        into somme_v
        from agent_info
        where idPersonnel_p = idPersonnel;

    return somme_v;

    exception
        when AGENT_INEXISTANT then
            -- 'L''agent selectionne n''existe pas'
            return somme_erreur_v;
END;
/
show errors;

-- --Diminution du prix de 2%
-- create or replace procedure diminution_2pourcents
-- is
--     cursor bien_envente_c is
--         select * from bien_immobilier
--             natural join vente
--             where vendu = 0
--             for update of prixCourant;
-- BEGIN
--     for bien_envente_r in bien_envente_c loop
--         -- On vérifie si on est encore le 1er mois, car si on le crée le 1er d''un mois il pourrait faire la mise à jour
--         if(sysdate - bien_envente_r.dateInitiale > 30) then
--             -- On vérifie qu''on ne sort pas de la marge
--             if(bien_envente_r.prixCourant - (2 * bien_envente_r.prixCourant / 100) < bien_envente_r.prixInitial - bien_envente_r.marge) then
--                 --Si on descend en dessous de la marge maximale autorisée alors on applique tout simplement la marge maximale
--                 update vente
--                     set prixCourant = prixInitial - marge
--                     where current of bien_envente_c;
--             else
--                 update vente
--                     set prixCourant = prixCourant - (2 * prixCourant / 100)
--                     where current of bien_envente_c;
--             end if;
--         end if;
--     end loop;
--     COMMIT;
-- END;
-- /
-- show errors;

--Diminution du prix mensuellement de 2% (ne fonctionne pas sans les droits)
--create or replace procedure diminution_mensuel
--is
--BEGIN
--  DMBS_SCHEDULER.create_job(
--    job_name        => 'diminution',
--    job_type        => 'PLSQL_BLOCK',
--    job_action      => 'BEGIN diminution_2pourcents; END;',
--    start_date      => SYSTIMESTAMP,
--    repeat_interval => 'freq=monthly; bymonth=1,2,3,4,5,6,7,8,9,10,11,12; bymonthday=1;',
--    end_date        => NULL,
--    enabled         => TRUE,
--    comments        => 'Diminution le 1er de chaque mois'
--  );
--END;
--/
show errors;

-- Calcul de distance entre deux latitudes/longitudes
create or replace function calcDistance
    (Lat1 number,Lon1 number,Lat2 number,Lon2 number,Radius in number default 6387.7)
    return number
is
    --Multiple pour passer de degré à radian
    DegToRad number := 57.29577951;
BEGIN
    return(NVL(Radius,0) * ACOS((sin(NVL(Lat1,0) / DegToRad) * SIN(NVL(Lat2,0) / DegToRad)) + (COS(NVL(Lat1,0) / DegToRad) * COS(NVL(Lat2,0) / DegToRad) * COS(NVL(Lon2,0) / DegToRad - NVL(Lon1,0)/ DegToRad))));
END;
/
show errors;

-- Archivage
create or replace procedure archivage
IS
BEGIN
    -- Les triggers archivent tout bien supprime.
    delete from vente where vendu = 1;
    delete from location where loue = 1;
END;
/
show errors;
