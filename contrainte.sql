--A la création d'un bien on met la date à la date courante
create or replace trigger insertionImmobilier
before insert on bien_immobilier
for each row
BEGIN
  --On met la date initiale à la date courante
  :new.dateInitiale := sysdate;
END;
/

ALTER TRIGGER insertionImmobilier ENABLE;

--Erreur sur la date de naissance
create or replace trigger birthUser
before insert or update on UTILISATEUR
for each row
when (sysdate < :new.dateNaissance)
BEGIN
	-- soulever une exception
	RAISE_APPLICATION_ERROR(-20200,'La date de naissance doit etre inferieure a la date du jour.');
END;
/

ALTER TRIGGER birthUser ENABLE;

--Erreur sur la réservation du créneau
create or replace trigger reserveCreneau
before insert or update on RESERVATION_CRENEAU
for each row
when (sysdate > :new.dateR)
BEGIN
	-- soulever une exception
	RAISE_APPLICATION_ERROR(-20201,'La date de reservation de creneau doit etre supérieure a la date du jour.');
END;
/

ALTER TRIGGER reserveCreneau ENABLE;

--Erreur sur la date de location
create or replace trigger dateLocation
before insert or update on HISTORIQUE_LOCATION
for each row
when (sysdate < :new.dateL)
BEGIN
	-- soulever une exception
	RAISE_APPLICATION_ERROR(-20202,'La date de location doit etre inferieur a la date du jour.');
END;
/

ALTER TRIGGER dateLocation ENABLE;

--Erreur sur la date de vente
create or replace trigger dateVente
before insert or update on HISTORIQUE_VENTE
for each row
when (sysdate < :new.dateV)
BEGIN
	-- soulever une exception
	RAISE_APPLICATION_ERROR(-20203,'La date de vente doit etre inferieure a la date du jour.');
END;
/

ALTER TRIGGER dateVente ENABLE;

--Modification des ajouts nom de client invalide
create or replace trigger nom_invalide
before insert or update on utilisateur
for each row
when (:new.nom not like upper(:new.nom))
BEGIN
  --Si le nom n'est pas valide, on le change
  :new.nom := upper(:new.nom);
END;
/

ALTER TRIGGER nom_invalide ENABLE;

--Modification des ajouts de prenom de client invalide
create or replace trigger prenom_invalide
before insert or update on utilisateur
for each row
when (:new.prenom not like initcap(:new.prenom))
BEGIN
  --Si le prenom n'est pas valide, on le change
  :new.prenom := initcap(:new.prenom);
END;
/

ALTER TRIGGER prenom_invalide ENABLE;

--Refus des ajouts de login de client invalide
create or replace trigger login_invalide
before insert or update on utilisateur
for each row
when(not (regexp_like(:new.login,'^[:alpha:]{1}[:alnum:]{1,}$')))
BEGIN
  --Si le login est invalide on soulève une erreur
  RAISE_APPLICATION_ERROR(-20204,'Le login est invalide ; Il doit d''abord contenir une lettre puis une suite de chiffres ou de lettres.');
END;
/

ALTER TRIGGER login_invalide ENABLE;

--Refus des ajouts de courriel de client invalide
create or replace trigger courriel_invalide
before insert or update on utilisateur
for each row
when(not (regexp_like(:new.courriel,'^[:alnum:]{1,}@[:alpha:]{1,}\.{1}[:alpha:]{2,}$')))
BEGIN
  --Si l'adresse est invalide on soulève une erreur
  RAISE_APPLICATION_ERROR(-20205,'L''adresse courriel est invalide ; Elle doit etre du type nom@serveur.pays.');
END;
/

ALTER TRIGGER courriel_invalide ENABLE;

--Hachage du mot de passe
create or replace trigger hachage_mdp
before insert or update on utilisateur
for each row
BEGIN
  --Hachage du mdp
  :new.mdp := DBMS_OBFUSCATION_TOOLKIT.MD5(input_string => :new.mdp);
END;
/

ALTER TRIGGER hachage_mdp ENABLE;

create or replace trigger visite_invalide
before insert on reservation_creneau
for each row
DECLARE
  jour_de_la_semaine varchar(10);
  nombre_de_reservation integer;
  
  cursor liste_creneau_agent_c is
    select idPersonnel, idBien, dateR, duree
    from reservation_creneau;
    
  cursor liste_creneau_client_c is
    select idUtilisateur, idBien, dateR, duree
    from reservation_creneau;

BEGIN
  select upper(to_char(:new.dateR, 'DAY'))
  into jour_de_la_semaine
  from dual;
  
  --Si la réservation est un dimanche on soulève une excpetion
  if (jour_de_la_semaine like 'SUNDAY') then
    raise_application_error(-20206, 'Rerservation non autorisee le dimanche.');
  end if;
  
  select count(*)
  into nombre_de_reservation
  from reservation_creneau rc
  where :new.dateR = rc.dateR;
  
  --Si le nombre de réservation est supérieur à 2 alors on empèche la réservation
  if (nombre_de_reservation > 3=) then
    raise_application_error(-20207, 'Il y a deja 3 reservations le jour la.');
  end if;
  
  --Si l'heure de la réservation n'est pas comprise entre 8 et 20 alors on empèche la réservation
  if (to_number(to_char(:new.dateR,hh24))<8 || (to_number(to_char(:new.dateR,hh24))+duree/60)>20) then
    raise_application_error(-20208, 'La reservation doit commencer à partir de 8h et finir avant 20h.');
  end if;
  
  for agent_r in liste_creneau_agent_c loop
  --Si un agent se trouve à deux endroits en meme temps
    if (:new.idPersonnel=agent_r.idPersonnel
    AND :new.idBien!=agent_r.idBien
    AND not ((:new.dateR<agent_r.dateR AND :new.dateR+:new.duree<agent_r.dateR+agent_r.duree
            OR :new.dateR>agent_r.dateR AND :new.dateR+:new.duree>agent_r.dateR+agent_r.duree)
            )
    )then
      raise_application_error(-20209, 'Un agent ne peut se trouver a deux endroits en meme temps.');
    end if;
  end loop;
  
  for client_r in liste_creneau_client_c
  --Si un client se trouve à deux endroits en meme temps
    if (:new.idUtilisateur=client_r.idUtilisateur
    AND :new.idBien!=client_r.idBien
    AND not ((:new.dateR<client_r.dateR AND :new.dateR+:new.duree<client_r.dateR+client_r.duree
            OR :new.dateR>client_r.dateR AND :new.dateR+:new.duree>client_r.dateR+client_r.duree)
            )
    )then
      raise_application_error(-20210, 'Un client ne peut se trouver a deux endroits en meme temps.');
    end if;
  end loop;
END;
/

ALTER TRIGGER visite_invalide ENABLE;

create view pourcentage_rentabilite (identifiant_bien, rentabilite, prix) as
  select idBien, ((prixDeVente/prixDeVenteInitial)*100), prixCourant
  from vente;
--On autorise les gens à modifier le prix et sélectionner n'importe quoi dans la vue
grant select, update(prix) on pourcentage_rentabilite to public;
