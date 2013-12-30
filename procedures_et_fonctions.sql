--Retourne le chiffre d'affaire d'un agent
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
	
BEGIN
	
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
END;
/

--Diminution du prix de 2%
create or replace procedure diminution_2pourcents
is
  

--Diminution du prix mensuellement de 2%
create or replace procedure diminution_mensuel
is
BEGIN
  DMBS_SCHEDULER.create_job(
    job_name        => 'diminution',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN diminution_2pourcents; END;',
    start_date      => SYSTIMESTAMP
    repeat_interval => 'freq=monthly; bymonth=1,2,3,4,5,6,7,8,9,10,11,12; bymonthday=1;',
    end_date        => NULL,
    enabled         => TRUE,
    comments        => 'Diminution le 1er de chaque mois'
  );
END;
/

--Calcule de distance entre deux latitudes/longitudes
create or replace function calcDistance (Lat1 number,Lon1 number,Lat2 number,Lon2 number,Radius in number default 6387.7) return number
is
--Multiple pour passer de degré à radian
DegToRad number := 57.29577951;
BEGIN
  return(NVL(Radius,0) * ACOS((sin(NVL(Lat1,0) / DegToRad) * SIN(NVL(Lat2,0) / DegToRad)) + (COS(NVL(Lat1,0) / DegToRad) * COS(NVL(Lat2,0) / DegToRad) * COS(NVL(Lon2,0) / DegToRad - NVL(Lon1,0)/ DegToRad))));
END;
  
