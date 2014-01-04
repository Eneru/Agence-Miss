<?php
	$idUtilisateur=$_POST['idUtilisateur'];
	$connection=oci_connect("jeremymeyer","sum419520","localhost/ROSA");
	
	if (!$connection) 
	{
		echo "Echec de l'ouverture de la connection." ;
		exit ;
	}
	
	$query='select nom,prenom,dateNaissance,adresse,courriel,telephone,dateInscription from utilisateur where idUtilisateur='.$idUtilisateur;
	
	$sql_result = oci_parse($connection,$query);
	oci_execute($sql_result);
	
	$num_columns = oci_num_fields($sql_result);
	
	echo "<table>";
	echo "<tr><th>Nom</th> <th>Prenom</th> <th>Date de naissance</th> <th>Adresse</th> <th>Courriel</th> <th>Téléphone</th> <th>Date d'inscription'</th> " ;
	while ($row = oci_fetch_array($sql_result))
	{
		echo "<tr>" ;
		for ($i=0; $i < $num_columns; $i++)
		{
			echo "<td>".$row[$i]."</td>";
		}
		echo "</tr>";
	}
	echo "</table><br><br>" ;
	
	oci_free_statement($sql_result);
?>

<html>
	<head>
		<title>Gestion des informations personnelles</title>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" >
	</head>
	<body>
		<form action="modificationInfos.php" method="post">
			<?php                
				echo "<input type=\"hidden\" name=\"idUtilisateur\" value=\"";
				echo $idUtilisateur;
				echo "\"/>";
			?>
			<input type="submit" value="Modifier les informations personnelles.">
		</form>
	</body>
</html>

