--Proprietaires avec plus de 5 biens de 130m² minimum
with user_sup_30 as(
  select idUtilisateur
  from bien_immobilier
  where tailleTerrain >= 130)
select idUtilisateur
from user_sup_30 us
where 5 <= (select count(*)
            from user_sup_30 usBis
            where us.idUtilisateur = usBis.idUtilisateur);

--Pour chaque ville, le nombre de biens immobilier en location, le nombre de biens immobilier en vente et le nombre de clients cherchant un bien dans cette ville

select nomVille, count(idLocation) as nombre_location, count(idVente) as nombre_vente, count(idRecherche) as nombre_client_chercheur
from quartier_ville,bien_immobilier,vente,location,recherche
where quartier_ville.nomQuartier=bien_immobilier.nomQuartier
  AND quartier_ville.nomQuartier=vente.nomQuartier
  AND quartier_ville.nomQuartier=location.nomQuartier
  AND quartier_ville.nomQuartier=recherche.nomQuartier
group by nomVille;

--Pour chaque appartement vendu, la différence entre le bénéfice maximum potentiel et le bénéfice réelle de la vente
select idBien,(prixInitial*fraisAgence-prixCourant*fraisAgence) as difference_benefice
from historique_vente
group by idBien,(prixInitial*fraisAgence-prixCourant*fraisAgence);

-- Manque à gagner sur les appartements vendus.
select idBien, (prixInitial - prixCourant) as manque
    from historique_vente natural join bien_immobilier
    where typebien like 'appartement'
;

-- Clients ayant effectué le plus de visites.
select idUtilisateur, nom, prenom
    from reservation_creneau natural join utilisateur
    group by (idUtilisateur, nom, prenom)
    order by count(*)
    where dateR >= add_months(sysdate, -1)
;
