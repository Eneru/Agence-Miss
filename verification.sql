-- retour : -1 = n'existe pas, 0 = utilisateur, 1 = employe, 2 = agent
create or replace function est_un
(idUtilisateur_p utilisateur.idUtilisateur%type) return integer
is
	liste_utilisateur_v utilisateur.idUtilisateur%type;
	liste_agent_v personnel.idUtilisateur%type;
	type_v personnel.typePersonnel%type;
	
BEGIN
	select idUtilisateur
	into liste_utilisateur_v
	from utilisateur;
	
	select idUtilisateur,
	into liste_agent_v
	from personnel;
	
	if(idUtilisateur not in (liste_agent_v))
		if(idUtilisateur not in (liste_utilisateur_v))
			return -1;
		else
			return 0;
		end if;
	else
		select typePersonnel
		into type_v
		from personnel
		where idPersonnel_p = idPersonnel;
		
		if(type_v not like 'agent immobilier')
			return 1;
		else
			return 2;
		end if;
	end if;
END;
/
