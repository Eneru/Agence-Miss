<?php
	$idUtilisateur=$_POST['idUtilisateur'];
	$quartier=$_POST['quartier'];
	
	$connection=oci_connect("jeremymeyer","sum419520","localhost/ROSA");
	
	if (!$connection) 
	{
		echo "Echec de l'ouverture de la connection." ;
		exit ;
	}
	
	$query ='select nom,prenom,nbChambres,nbSdB,nbCuisines,nbGarages,nbCaves,surface,tailleTerrain,nbEtages,nbAscenceurs,nomQuartier,typeBien,dateInitiale from bien_immobilier bi natural join utilisateur u where u.idUtilisateur = bi.idUtilisateur AND nomQuartier='.$quartier;
	
	$sql_result = oci_parse($connection,$query);
	oci_execute($sql_result);
	
	$num_columns = oci_num_fields($sql_result);
	
	echo "<table>";
	echo "<tr><th>Nom</th> <th>Prenom</th> <th>Nombre de chambres</th> <th>Nombre de salles de bain</th> <th>Nombre de cuisines</th> <th>Nombre de garages</th> <th>Nombre de caves</th> <th>Surface</th> <th>Taille du terrain</th> <th>Nombre d'étages</th> <th>Nombre d'ascenceurs</th> <th>Nom du quartier</th> <th>Type de bien</th> <th>Date initiale</th>" ;
	while ($row = oci_fetch_array($sql_result))
	{
		echo "<tr>" ;
		for ($i=0; $i < $num_columns; $i++)
		{
			echo "<td>".$row[$i]."</td>";
		}
		echo "</tr>";
	}
	echo "</table>" ;
	
	oci_free_statement($sql_result);
	oci_close($connection) ;
?>

