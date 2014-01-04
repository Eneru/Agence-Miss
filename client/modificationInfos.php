<?php
	$idUtilisateur=$_POST['idUtilisateur'];
?>

<html>
	<head>
		<title>Modifications des infos personnelles</title>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" >
	</head>
	<body>
		<form action="valideModif.php" method="post">
			<?php                
				echo "<input type=\"hidden\" name=\"idUtilisateur\" value=\"";
				echo $idUtilisateur;
				echo "\"/>";
			?>
			Laisser les champs à null si un changement est non désiré.
			Nom : <input type="text" value="null" name="nom"><br>
			Prenom : <input type="text" value="null" name="prenom"><br>
			Date de naissance : <input type="text" value="null" name="dateNaissance"><br>
			Adresse : <input type="text" value="null" name="adresse"><br>
			Courriel : <input type="text" value="null" name="courriel"><br>
			Téléphone : <input type="text" value="null" name="telephone"><br>
			<input type="submit" value="Modifier.">
		</form>
	</body>
</html>
