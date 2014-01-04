<?php
	$idUtilisateur=$_POST['idUtilisateur'];
	$nom=$_POST['nom'];
	$prenom=$_POST['prenom'];
	$dateNaissance=$_POST['dateNaissance'];
	$adresse=$_POST['adresse'];
	$courriel=$_POST['courriel'];
	$telephone=$_POST['telephone'];
	$dateInscription=$_POST['dateInscription'];
	
	$connection=oci_connect("jeremymeyer","sum419520","localhost/ROSA");
	
	if (!$connection) 
	{
		echo "Echec de l'ouverture de la connection." ;
		exit ;
	}
	
	$query='execute changer_info_utilisateur('.$idUtilisateur.','.$nom.','.$prenom.','.$dateNaissance.','.$adresse.','.$courriel.','.$telephone.',null,null,null)';
	$sql_result = oci_parse($connection,$query);
	oci_execute($sql_result);
	
	oci_free_statement($sql_result);
	
	oci_close($connection) ;
	
	echo"<br><b>Modifications réussies !</b><br>";
?>
