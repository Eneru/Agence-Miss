--Erreur sur la date de naissance
create or replace trigger birthUser
before insert or update on UTILISATEUR
for each row
when (sysdate < new.dateNaissance)
BEGIN
	-- soulever une exception
	RAISE_APPLICATION_ERROR(-20200,'La date de naissance doit etre inferieure a la date du jour');
END;
/

ALTER TRIGGER birthUser ENABLE;

--Erreur sur la réservation du créneau
create or replace trigger reserveCreneau
before insert or update on RESERVATION_CRENEAU
for each row
when (sysdate > new.dateR)
BEGIN
	-- soulever une exception
	RAISE_APPLICATION_ERROR(-20201,'La date de reservation de creneau doit etre supérieure a la date du jour');
END;
/

ALTER TRIGGER reserveCreneau ENABLE;

--Erreur sur la date de location
create or replace trigger dateLocation
before insert or update on HISTORIQUE_LOCATION
for each row
when (sysdate < new.dateL)
BEGIN
	-- soulever une exception
	RAISE_APPLICATION_ERROR(-20202,'La date de location doit etre inferieur a la date du jour');
END;
/

ALTER TRIGGER dateLocation ENABLE;

--Erreur sur la date de vente
create or replace trigger dateVente
before insert or update on HISTORIQUE_VENTE
for each row
when (sysdate < new.dateV)
BEGIN
	-- soulever une exception
	RAISE_APPLICATION_ERROR(-20203,'La date de vente doit etre inferieure a la date du jour');
END;
/

ALTER TRIGGER dateVente ENABLE;

--Modification des ajouts nom de client invalide
create or replace trigger nom_invalide
before insert or update on utilisateur
for each row
when (new.nom not like upper(new.nom))
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
when (new.prenom not like initcap(new.prenom))
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
when(not regexp_like(new.login,'^[:alpha:][:alnum:]+$'))
BEGIN
  --Si le login est invalide on soulève une erreur
  RAISE_APPLICATION_ERROR(-20204,'Le login est invalide ; Il doit d''abord contenir une lettre puis une suite de chiffres ou de lettres');
END;
/

ALTER TRIGGER login_invalide ENABLE;

--Refus des ajouts de courriel de client invalide
create or replace trigger courriel_invalide
before insert or update on utilisateur
for each row
when(not regexp_like(new.courriel,'^[:alnum:]+@[:alpha:]+\.[:alpha:]{2,}$');
BEGIN
  --Si l'adresse est invalide on soulève une erreur
  RAISE_APPLICATION_ERROR(-20205,'L''adresse courriel est invalide ; Elle doit etre du type nom@serveur.pays');
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
