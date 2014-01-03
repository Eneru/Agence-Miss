--Retourne le chiffre d'affaire d'un agent
create or replace function chiffreAgent
(idPersonnel_p historique_vente.idPersonnel%type) return historique_vente.fraisAgence%type
is
	somme_v historique_vente.fraisAgence%type;
	somme_erreur_v historique_vente.fraisAgence%type;
	type_v personnel.typePersonnel%type;
	listePersonnel_v personnel.idPersonnel%type;
	
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
		select benefice_total
    into somme_v
    from agent_info
    where idPersonnel_p = idPersonnel;
		
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
  cursor bien_envente_c is
    select * from bien_immobilier
    natural join vente
    where enVente=1
    for update of prixCourant;

BEGIN
  for bien_envente_r in bien_envente_c loop
    --On vérifie si on est encore le 1er mois, car si on le crée le 1er d'un mois il pourrait faire la mise à jour
    if(sysdate-bien_envente_r.dateInitiale > 30) then
    --On vérifie qu'on ne sort pas de la marge
      if(bien_envente_r.prixCourant - (2*bien_envente_r.prixCourant/100) < bien_envente_r.prixInitial - bien_envente_r.marge) then
        --Si on descend en dessous de la marge maximale autorisée alors on applique tout simplement la marge maximale
        update vente
        set prixCourant:=prixInitiale-marge;
        where current of bien_envente_c;
      else
        update vente
        set prixCourant:=prixCourant-(2*prixCourant/100)
        where current of bien_envente_c;
      end if;
    end if;
  end loop;
COMMIT;
END;
/

--Diminution du prix mensuellement de 2% (ne fonctionne pas sans les droits
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

--Calcule de distance entre deux latitudes/longitudes
create or replace function calcDistance (Lat1 number,Lon1 number,Lat2 number,Lon2 number,Radius in number default 6387.7) return number
is
--Multiple pour passer de degré à radian
DegToRad number := 57.29577951;
BEGIN
  return(NVL(Radius,0) * ACOS((sin(NVL(Lat1,0) / DegToRad) * SIN(NVL(Lat2,0) / DegToRad)) + (COS(NVL(Lat1,0) / DegToRad) * COS(NVL(Lat2,0) / DegToRad) * COS(NVL(Lon2,0) / DegToRad - NVL(Lon1,0)/ DegToRad))));
END;
/

--Archivage de la vente et mise à jour des informations sur les agents vendeurs
create or replace procedure archivage_vente
is
DECLARE
cursor bien_de_vente_c is
  select * from bien_immobilier
  natural join vente
  for update;
  
nombre_bien_vendu integer;
  
BEGIN
  select count(*)
  into nombre_bien_vendu
  from historique_vente;

  for bien_r in bien_de_vente_c loop
    --Si la bien est vendu on l'archive
    if (bien_r.enVente=0) then
      --Insertion dans la table d'historique
      insert into historique_vente
      values (nombre_bien_vendu+1, bien_r.idBien, bien_r.idUtilisateur, bien_r.idPersonnel, bien_r.prixInitial, bien_r.prixCourant, bien_r.fraisAgence, bien_r.dateVente);
      --Mise à jour de l'info sur l'agent vendeur
      update agent_info
      set nombre_de_vente:=nombre_de_vente+1, benefice_total:=benefice_total+(bien_r.fraisAgence*bien_r.prixCourant);
      where idPersonnel = bien_r.idPersonnel;
      --Suppression de la table de vente
      delete from vente where idBien=bien_r.idBien;
    end if;
  end loop;
COMMIT;
END;
/

--Archivage de la location et mise à jour des informations sur les agents loueurs
create or replace procedure archivage_location
is
DECLARE
cursor bien_de_location_c is
  select * from bien_immobilier
  natural join location
  for update;
  
nombre_bien_loue integer;
  
BEGIN
  select count(*)
  into nombre_bien_loue
  from historique_location;

  for bien_r in bien_de_location_c loop
    --Si la bien est vendu on l'archive
    if (bien_r.enLocation=0) then
      --Insertion dans la table d'historique
      insert into historique_location
      values (nombre_bien_loue+1, bien_r.idBien, bien_r.idUtilisateur, bien_r.idPersonnel, bien_r.loyer, bien_r.charges, bien_r.fraisAgence, bien_r.dateLocation);
      --Mise à jour de l'info sur l'agent vendeur
      update agent_info
      set nombre_de_vente:=nombre_de_vente+1, benefice_total:=benefice_total+bien_r.fraisAgence;
      where idPersonnel = bien_r.idPersonnel;
      --Suppression de la table de vente
      delete from location where idBien=bien_r.idBien;
    end if;
  end loop;
COMMIT;
END;
/