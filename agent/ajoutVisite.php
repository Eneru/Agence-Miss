<?php
	$idUtilisateur=$_POST['idUtilisateur'];
	$idBien=$_POST['idBien'];
	$dateR=$_POST['dateR'];
	$idClient=$_POST['idClient'];
	$duree=$_POST['duree'];
    
    $connection=oci_connect("jeremymeyer","sum419520","localhost/ROSA");
	
	if (!$connection) 
	{
		echo "Echec de l'ouverture de la connection." ;
		exit ;
	}
	/* Manque de temps
	$query ='execute ajout_visite('.$idUtilisateur.','.$nbChambres.','.$nbSdB.','.$nbCuisines.','.$nbGarages.','.$nbCaves.','.$surface.','.$tailleTerrain.','.$nbEtages.','.$nbAscenceurs.','.$idImage.','.$nomQuartier.','.$typeBien.')';
	$sql_result = oci_parse($connection,$query);
	oci_execute($sql_result);
	
	oci_free_statement($sql_result);
	oci_close($connection) ;
	
	echo"<br><b>Ajout de visite réussi !</b><br>";
	*/
?>
