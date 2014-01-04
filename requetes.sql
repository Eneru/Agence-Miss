--Proprietaires avec plus de 5 biens de 130m² minimum
select idUtilisateur
    from bien_immobilier
    where tailleTerrain >= 130
    group by idUtilisateur
    having count(*) >= 5
;

--Pour chaque ville, le nombre de biens immobilier en location, le nombre de biens immobilier en vente et le nombre de clients cherchant un bien dans cette ville
with
    clients_ville as
    (
        select nomVille, count(idutilisateur) as clients
            from quartier_ville natural join recherche natural join recherche_client
            group by nomVille
    ),
    locations_ville as
    (
        select nomVille, count(idLocation) as locations
            from quartier_ville natural join bien_immobilier natural join location
            group by nomVille
    ),
    ventes_ville as
    (
        select nomVille, count(idVente) as ventes
            from quartier_ville natural join bien_immobilier natural join vente
            group by nomVille
    )
select nomVille, clients, locations, ventes
    from clients_ville natural join locations_ville natural join ventes_ville
;

-- Manque à gagner sur les appartements vendus.
select idBien, (prixInitial*fraisAgence - prixVente*fraisAgence) as difference_benefice
    from historique_vente natural join bien_immobilier
    where typebien like 'appartement'
;

-- Clients ayant effectué le plus de visites.
select idUtilisateur, nom, prenom, count(*) as visites
    from reservation_creneau natural join utilisateur
    where dateR >= add_months(sysdate, -1)
    group by (idUtilisateur, nom, prenom)
    order by count(*) desc
;

-- Bien le moins cher.
select idUtilisateur, idBien
    from recherche_client natural join recherche natural join vente
    where enVente = 1
        and rownum = 1
    order by prixCourant desc
;
