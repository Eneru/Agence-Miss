--Proprietaires avec plus de 5 biens de 130m² minimum
with user_sup_30 as
  select idUtilisateur
  from bien_immobilier
  where tailleTerrain >= 130;
select idUtilisateur
from user_sup_30 us
where 5 <= (select count(*)
            from user_sup_30 usBis
            where us.idUtilisateur = usBis.idUtilisateur);
