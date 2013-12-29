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
when(not regexp_like(new.login,'^[:alpha:]{1}[:alnum:]{1,}$'))
BEGIN
  --Si le login est invalide
  RAISE_APPLICATION_ERROR(-20204,'Le login est invalide ; Il doit d''abord contenir une lettre puis une suite de chiffres ou de lettres');
END;
/

ALTER TRIGGER login_invalide ENABLE;

--Refus des ajouts de courriel de client invalide
create or replace trigger courriel_invalide
before insert or update on utilisateur
for each row
when(not regexp_like(new.courriel,'^[:alnum:]{1,}@[:alpha:]{1,}\.{1}[:alpha:]{2,}$');
BEGIN
  --Si l'adresse est invalide
  RAISE_APPLICATION_ERROR(-20205,'L''adresse courriel est invalide ; Elle doit etre du type nom@serveur.pays');
END;
/

ALTER TRIGGER courriel_invalide ENABLE;