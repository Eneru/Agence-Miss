-- UTILISATEUR
-- Dates de naissance invalides.
create or replace trigger naissance
    before insert or update on UTILISATEUR
    for each row
    when (sysdate < new.dateNaissance)
BEGIN
    -- soulever une exception
    RAISE_APPLICATION_ERROR(-20200, 'La date de naissance doit etre inferieure a la date du jour.');
END;
/
show errors;
ALTER TRIGGER naissance ENABLE;

-- Noms de client invalides.
create or replace trigger nom_invalide
    before insert or update on utilisateur
    for each row
    when (new.nom not like upper(new.nom))
BEGIN
    :new.nom := upper(:new.nom);
END;
/
show errors;
ALTER TRIGGER nom_invalide ENABLE;

-- Prénoms de client invalides.
create or replace trigger prenom_invalide
    before insert or update on utilisateur
    for each row
    when (new.prenom not like initcap(new.prenom))
BEGIN
    :new.prenom := initcap(:new.prenom);
END;
/
show errors;
ALTER TRIGGER prenom_invalide ENABLE;

-- Login invalides
create or replace trigger login_invalide
    before insert or update on utilisateur
    for each row
    when (not (regexp_like(new.login,'^[[:alpha:]][[:alnum:]]+$')))
BEGIN
    RAISE_APPLICATION_ERROR(-20204, 'Le login est invalide ; Il doit d''abord contenir une lettre puis une suite de chiffres ou de lettres.');
END;
/
show errors;
ALTER TRIGGER login_invalide ENABLE;

--Refus des ajouts de courriel de client invalide
create or replace trigger courriel_invalide
    before insert or update on utilisateur
    for each row
    when (not (regexp_like(new.courriel,'^[[:alpha:]][[:alnum:]\-\_\.]+@[[:alnum:]\-\_\.]+[[:alpha:]]{2,}$')))
BEGIN
    RAISE_APPLICATION_ERROR(-20205, 'L''adresse courriel est invalide ; Elle doit etre du type nom@serveur.pays.');
END;
/
show errors;
ALTER TRIGGER courriel_invalide ENABLE;

--Hachage du mot de passe
create or replace trigger hachage_mdp
    before insert or update on utilisateur
    for each row
BEGIN
    :new.mdp := DBMS_OBFUSCATION_TOOLKIT.MD5(input_string => :new.mdp);
END;
/
show errors;
ALTER TRIGGER hachage_mdp ENABLE;

-- Agents
create or replace trigger agent_immobilier
    after insert on personnel
    for each row
    when (new.typePersonnel like '%agent immobilier%')
BEGIN
    insert into agent_info values
    (
        :new.idPersonnel,
        0,
        0.
    );
END;
/

-- BIEN_IMMOBILIER
-- Date initiale
create or replace trigger insertionImmobilier
    before insert on bien_immobilier
    for each row
    when (new.dateInitiale = NULL)
BEGIN
    :new.dateInitiale := sysdate;
END;
/
show errors;
ALTER TRIGGER insertionImmobilier ENABLE;

-- RESERVATION_CRENEAU
-- Date incorrecte
create or replace trigger reserveCreneau
    before insert or update on RESERVATION_CRENEAU
    for each row
    when (sysdate > new.dateR)
BEGIN
    RAISE_APPLICATION_ERROR(-20201, 'La date de reservation de creneau doit etre supérieure a la date du jour.');
END;
/
show errors;
ALTER TRIGGER reserveCreneau ENABLE;

-- LOCATION
-- Insertion location
create or replace trigger insertion_location
    before insert or update on LOCATION
    for each row
BEGIN
    if (:new.loue = 0) then
        if ( :new.idUtilisateur != NULL OR :new.dateLocation != NULL ) then
            RAISE_APPLICATION_ERROR(-20211, 'Bien non loue, il ne peut pas etre associé à un utilisateur ou avoir une date de location.');
        end if;
    elsif ( :new.idUtilisateur = NULL OR :new.dateLocation = NULL ) then
        RAISE_APPLICATION_ERROR(-20212, 'Le bien est loue, il doit etre associe à un utilisateur et une date de location.');
    elsif ( sysdate < :new.dateLocation ) then
        RAISE_APPLICATION_ERROR(-20202, 'La date de location doit etre inferieur a la date du jour.');
    end if;
END;
/
show errors;
ALTER TRIGGER insertion_location ENABLE;

-- Suppression/Archivage
create or replace trigger archivage_location
    after delete on LOCATION
    for each row
DECLARE
    nouvelID_v HISTORIQUE_LOCATION.idHistLocation%type;
BEGIN
    select count(*)
        into nouvelID_v
        from historique_location
    ;
    nouvelID_v := nouvelID_v + 1;
    insert into historique_location values
    (
        nouvelID_v,
        :old.idBien,
        :old.idPersonnel,
        :old.idUtilisateur,
        :old.loyer,
        :old.charges,
        :old.fraisAgence,
        :old.loue,
        :old.dateLocation
    );
END;
/
show errors;
ALTER TRIGGER archivage_location ENABLE;

-- VENTE
create or replace trigger insertion_vente
    before insert or update on VENTE
    for each row
BEGIN
    if (:new.vendu = 0) then
        if ( :new.idUtilisateur != NULL OR :new.dateVente != NULL ) then
            RAISE_APPLICATION_ERROR(-20213, 'Bien non vendu, il ne peut pas etre associé à un utilisateur ou avoir une date de vente.');
        end if;
    elsif ( :new.idUtilisateur = NULL OR :new.dateVente = NULL ) then
        RAISE_APPLICATION_ERROR(-20214, 'Le bien est vendu, il doit etre associe à un utilisateur et une date de location.');
    elsif ( sysdate < :new.dateVente ) then
        RAISE_APPLICATION_ERROR(-20215, 'La date de vente doit etre inferieur a la date du jour.');
    end if;
END;
/
show errors;
ALTER TRIGGER insertion_vente ENABLE;

-- Suppression/Archivage
create or replace trigger archivage_vente
    after delete on VENTE
    for each row
DECLARE
    nouvelID_v HISTORIQUE_VENTE.idHistVente%type;
BEGIN
    select count(*)
        into nouvelID_v
        from historique_vente
    ;
    nouvelID_v := nouvelID_v + 1;
    insert into historique_vente values
    (
        nouvelID_v,
        :old.idBien,
        :old.idPersonnel,
        :old.idUtilisateur,
        :old.prixInitial,
        :old.prixCourant,
        :old.fraisAgence,
        :old.vendu,
        :old.dateVente,
        :old.prixCourant * :old.fraisAgence
    );
END;
/
show errors;
ALTER TRIGGER archivage_vente ENABLE;

-- HISTORIQUE_LOCATION
create or replace trigger insertion_historique_location
    before insert or update on HISTORIQUE_LOCATION
    for each row
BEGIN
    if (:new.loue = 0) then
        if ( :new.idUtilisateur != NULL OR :new.dateLocation != NULL ) then
            RAISE_APPLICATION_ERROR(-20216, 'Bien non loue, il ne peut pas etre associé à un utilisateur ou avoir une date de location.');
        end if;
    elsif ( :new.idUtilisateur = NULL OR :new.dateLocation = NULL ) then
        RAISE_APPLICATION_ERROR(-20217, 'Le bien est loue, il doit etre associe à un utilisateur et une date de location.');
    elsif ( sysdate < :new.dateLocation ) then
        RAISE_APPLICATION_ERROR(-20218, 'La date de location doit etre inferieur a la date du jour.');
    end if;
END;
/
show errors;
ALTER TRIGGER insertion_historique_location ENABLE;

-- HISTORIQUE_VENTE
create or replace trigger insertion_historique_vente
    before insert or update on HISTORIQUE_VENTE
    for each row
BEGIN
    if (:new.vendu = 0) then
        if ( :new.idUtilisateur != NULL OR :new.dateVente != NULL ) then
            RAISE_APPLICATION_ERROR(-20219, 'Bien non vendu, il ne peut pas etre associé à un utilisateur ou avoir une date de vente.');
        end if;
    elsif ( :new.idUtilisateur = NULL OR :new.dateVente = NULL ) then
        RAISE_APPLICATION_ERROR(-20220, 'Le bien est vendu, il doit etre associe à un utilisateur et une date de location.');
    elsif ( sysdate < :new.dateVente ) then
        RAISE_APPLICATION_ERROR(-20221, 'La date de vente doit etre inferieur a la date du jour.');
    elsif ( :new.benefice != :new.prixVente * :new.fraisAgence ) then
        RAISE_APPLICATION_ERROR(-20222, 'Bénéfice invalide.');
    end if;
END;
/
show errors;
ALTER TRIGGER insertion_historique_vente ENABLE;

create or replace procedure verifier_performances
    (idPersonnel_p agent_info.idPersonnel%type)
is
    temp_succes_v integer;
    temp_benefices_v float;
    somme_succes_v integer;
    somme_benefices_v float;
BEGIN
    somme_succes_v := 0;
    somme_benefices_v := 0.;

    select count(*)
        into temp_succes_v
        from
        (
            select prixCourant * fraisAgence as benefice
                from vente
                where vendu = 1
                    AND idPersonnel = idPersonnel_p
                    AND to_number(to_char(sysdate, 'YYYY')) = to_number(to_char(dateVente, 'YYYY'))
        )
    ;
    if (temp_succes_v > 0) then
        somme_succes_v := somme_succes_v + temp_succes_v;
    end if;
    select count(*)
        into temp_succes_v
        from
        (
            select benefice
                from historique_vente
                where vendu = 1
                    AND idPersonnel = idPersonnel_p
                    AND to_number(to_char(sysdate, 'YYYY')) = to_number(to_char(dateVente, 'YYYY'))
        )
    ;
    if (temp_succes_v > 0) then
        somme_succes_v := somme_succes_v + temp_succes_v;
    end if;
    select count(*)
        into temp_succes_v
        from
        (
            select fraisAgence
                from location
                where loue = 1
                    AND idPersonnel = idPersonnel_p
                    AND to_number(to_char(sysdate, 'YYYY')) = to_number(to_char(dateLocation, 'YYYY'))
        )
    ;
    if (temp_succes_v > 0) then
        somme_succes_v := somme_succes_v + temp_succes_v;
    end if;
    select count(*)
        into temp_succes_v
        from
        (
            select fraisAgence
                from historique_location
                where loue = 1
                    AND idPersonnel = idPersonnel_p
                    AND to_number(to_char(sysdate, 'YYYY')) = to_number(to_char(dateLocation, 'YYYY'))
        )
    ;
    if (temp_succes_v > 0) then
        somme_succes_v := somme_succes_v + temp_succes_v;
    end if;

    select sum(benefice)
        into temp_benefices_v
        from
        (
            select prixCourant * fraisAgence as benefice
                from vente
                where vendu = 1
                    AND idPersonnel = idPersonnel_p
                    AND to_number(to_char(sysdate, 'YYYY')) = to_number(to_char(dateVente, 'YYYY'))
        )
    ;
    if (temp_benefices_v > 0.) then
        somme_benefices_v := somme_benefices_v + temp_benefices_v;
    end if;
    select sum(benefice)
        into temp_benefices_v
        from
        (
            select benefice
                from historique_vente
                where vendu = 1
                    AND idPersonnel = idPersonnel_p
                    AND to_number(to_char(sysdate, 'YYYY')) = to_number(to_char(dateVente, 'YYYY'))
        )
    ;
    if (temp_benefices_v > 0.) then
        somme_benefices_v := somme_benefices_v + temp_benefices_v;
    end if;
    select sum(fraisAgence)
        into temp_benefices_v
        from
        (
            select fraisAgence
                from location
                where loue = 1
                    AND idPersonnel = idPersonnel_p
                    AND to_number(to_char(sysdate, 'YYYY')) = to_number(to_char(dateLocation, 'YYYY'))
        )
    ;
    if (temp_benefices_v > 0.) then
        somme_benefices_v := somme_benefices_v + temp_benefices_v;
    end if;
    select sum(fraisAgence)
        into temp_benefices_v
        from
        (
            select fraisAgence
                from historique_location
                where loue = 1
                    AND idPersonnel = idPersonnel_p
                    AND to_number(to_char(sysdate, 'YYYY')) = to_number(to_char(dateLocation, 'YYYY'))
        )
    ;
    if (temp_benefices_v > 0.) then
        somme_benefices_v := somme_benefices_v + temp_benefices_v;
    end if;

    update agent_info set
        nombre_de_ventes = somme_succes_v,
        benefice_total = somme_benefices_v
    where idPersonnel = idPersonnel_p;
END;
/
show errors;

create or replace trigger bien_vendu
    after insert or update on VENTE
DECLARE
    compte_v integer;
    cursor biens_vendus_c is
        select distinct idpersonnel from vente where vendu = 1;
BEGIN
    select count(*)
        into compte_v
        from vente
        where vendu = 1
    ;
    if (compte_v > 0) then
        for id_r in biens_vendus_c loop
            verifier_performances(id_r.idpersonnel);
        end loop;
    end if;
END;
/
show errors;
ALTER TRIGGER bien_vendu ENABLE;

create or replace trigger bien_loue
    after insert or update on LOCATION
DECLARE
    compte_v integer;
    cursor biens_loues_c is
        select distinct idpersonnel from location where loue = 1;
BEGIN
    select count(*)
        into compte_v
        from location
        where loue = 1
    ;
    if (compte_v > 0) then
        for id_r in biens_loues_c loop
            verifier_performances(id_r.idpersonnel);
        end loop;
    end if;
END;
/
show errors;
ALTER TRIGGER bien_loue ENABLE;

create or replace trigger visite_invalide
    before insert or update on reservation_creneau
    for each row
DECLARE
    jour_de_la_semaine varchar2(16);
    nombre_de_reservation integer;
    cursor liste_creneau_agent_c is
        select idPersonnel, idBien, dateR, duree
            from reservation_creneau natural join relations_client;
    cursor liste_creneau_client_c is
        select idUtilisateur, idBien, dateR, duree
            from reservation_creneau;
BEGIN
    --select to_number(to_char(:new.dateR, 'fmD'))
    --    into jour_de_la_semaine
    --    from dual;
    jour_de_la_semaine := upper(to_char(:new.dateR, 'DAY'));

    if (to_char(:new.dateR, 'DAY') like '%SUNDAY%') then
        raise_application_error(-20206, 'Rerservation non autorisee le dimanche.');
    end if;

    select count(*)
        into nombre_de_reservation
        from reservation_creneau rc
        where :new.dateR = rc.dateR;

    --Si le nombre de réservation est supérieur à 3 alors on empèche la réservation
    if (nombre_de_reservation > 3) then
        raise_application_error(-20207, 'Il y a deja 3 reservations le jour la.');
    end if;

    --Si l'heure de la réservation n'est pas comprise entre 8 et 20 alors on empèche la réservation
    if (to_number(to_char(:new.dateR, 'hh24')) < 8
        OR (to_number(to_char(:new.dateR, 'hh24')) + :new.duree / 60) > 20
    ) then
        raise_application_error(-20208, 'La reservation doit commencer apres 8h et finir avant 20h.');
    end if;

    for agent_r in liste_creneau_agent_c loop
        --Si un agent se trouve à deux endroits en meme temps
        if (:new.idPersonnel = agent_r.idPersonnel
            AND :new.idBien != agent_r.idBien
            AND not (
                (:new.dateR < agent_r.dateR AND :new.dateR + :new.duree < agent_r.dateR + agent_r.duree)
                OR (:new.dateR > agent_r.dateR AND :new.dateR + :new.duree > agent_r.dateR + agent_r.duree)
            )
        ) then
            raise_application_error(-20209, 'Un agent ne peut se trouver a deux endroits en meme temps.');
        end if;
    end loop;

    for client_r in liste_creneau_client_c loop
        --Si un client se trouve à deux endroits en meme temps
        if (:new.idUtilisateur = client_r.idUtilisateur
            AND :new.idBien != client_r.idBien
            AND not (
                (:new.dateR < client_r.dateR AND :new.dateR + :new.duree < client_r.dateR + client_r.duree)
                OR (:new.dateR > client_r.dateR AND :new.dateR + :new.duree > client_r.dateR + client_r.duree)
            )
        ) then
            raise_application_error(-20210, 'Un client ne peut se trouver a deux endroits en meme temps.');
        end if;
    end loop;
END;
/
show errors;
ALTER TRIGGER visite_invalide ENABLE;

create or replace view pourcentage_rentabilite (identifiant_bien, rentabilite, prix) as
select idBien, ((prixCourant/prixInitial)*100), prixCourant
from vente;
--On autorise les gens à modifier le prix et sélectionner n''importe quoi dans la vue
grant select, update(prix) on pourcentage_rentabilite to public;


