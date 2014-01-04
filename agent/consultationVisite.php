<?php
	$idUtilisateur=$_POST['idUtilisateur'];
	
	$connection=oci_connect("jeremymeyer","sum419520","localhost/ROSA");
	
	if (!$connection) 
	{
		echo "Echec de l'ouverture de la connection." ;
		exit ;
	}
	
	$query ='select * from reservation_creneau rc natural join utilisateur u where u.idUtilisateur = rc.idUtilisateur AND idPersonnel='.$idUtilisateur;
	
	$sql_result = oci_parse($connection,$query);
	oci_execute($sql_result);
	
	$num_columns = oci_num_fields($sql_result);
	
	echo "<table>";
	echo "<tr><th>Identifiant du bien</th> <th>Date de réservation</th> <th>Identifiant de l'utilisateur</th> <th>Votre identifiant</th> <th>Duree de la visite</th>" ;
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
