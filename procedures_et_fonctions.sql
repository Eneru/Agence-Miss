create or replace function chiffreAgent
(idPersonnel_p historique_vente.idPersonnel%type) return historique_vente.fraisAgence%type
is
	somme_v historique_vente.fraisAgence%type;
	somme_erreur_v historique_vente.fraisAgence%type;
	type_v personnel.typePersonnel%type;
	listePersonnel_v personnel.idPersonnel%type;
	nb_vente_v INTEGER;
	
	AGENT_INEXISTANT exception;
	PAS_UN_AGENT exception;
	
begin
	
	select idPersonnel
	into listePersonnel_v
	from personnel;
	
	if (idPersonnel_p not in (listePersonnel_v)) then
		somme_erreur_v := -1.;
		raise AGENT_INEXISTANT;
	-- On vérifie que le personnel existe
	end if;
	
	select typePersonnel
	into type_v
	from personnel
	where idPersonnel_p = idPersonnel;
	
	if (type_v not like 'agent immobilier') then
		somme_erreur_v := -2.;
		raise PAS_UN_AGENT;
	-- On vérifie que c'est un agent immobilier
	
	else
		select count(*)
		into nb_vente_v
		from historique_vente
		where idPersonnel_p = idPersonnel;
		
		if (nb_vente_v = 0) then
			somme_v := 0.;
		-- Met la somme à 0 quand l'agent n'a fait aucune vente
		
		else
			select sum(fraisAgence)
			into somme_v
			from historique_vente
			where idPersonnel_p = idPersonnel;
		end if;
		
	end if;
	
	return somme_v;
	
	exception
		when AGENT_INEXISTANT then
			-- 'L''agent selectionne n''existe pas'
			return somme_erreur_v;
			
		when PAS_UN_AGENT then
			--'Le personnel selectionne n''est pas un agent immobilier'
			return somme_erreur_v;
end;
/
