<?php
	$idUtilisateur=$_POST['idUtilisateur'];
	$nbChambres=$_POST['nbChambres'];
	$nbSdB=$_POST['nbSdB'];
    $nbCuisines=$_POST['nbCuisines'];
	$nbGarages=$_POST['nbGarages'];
    $nbCaves=$_POST['nbCaves'];
    $surface=$_POST['surface'];
    $tailleTerrain=$_POST['tailleTerrain'];
    $nbEtages=$_POST['nbEtages'];
    $nbAscenceurs=$_POST['nbAscenceurs'];
    $idImage='null';
    $nomQuartier=$_POST['nomQuartier'];
    $typeBien=$_POST['TypeduBien'];
    
    $connection=oci_connect("jeremymeyer","sum419520","localhost/ROSA");
	
	if (!$connection) 
	{
		echo "Echec de l'ouverture de la connection." ;
		exit ;
	}
	
	$query ='execute ajout_bien('.$idUtilisateur.','.$nbChambres.','.$nbSdB.','.$nbCuisines.','.$nbGarages.','.$nbCaves.','.$surface.','.$tailleTerrain.','.$nbEtages.','.$nbAscenceurs.','.$idImage.','.$nomQuartier.','.$typeBien.')';
	$sql_result = oci_parse($connection,$query);
	oci_execute($sql_result);
	
	oci_free_statement($sql_result);
	oci_close($connection) ;
	
	echo"<br><b>Ajout réussi !</b><br>";
?>

