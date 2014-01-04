<?php
	$idUtilisateur=$_POST['idUtilisateur'];
?>

<html>
	<head>
		<title>Gestion des biens immobiliers</title>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" >
	</head>
	<body>
		<form action="consultationBienIMMO.php" method="post">
			<?php                
				echo "<input type=\"hidden\" name=\"idUtilisateur\" value=\"";
				echo $idUtilisateur;
				echo "\"/>";
			?>
			Quartier de sélection des biens<input type="name" name="quartier"><br>
			<input type="submit" value="Consulter tous les biens.">
		</form>
		<br>
		<br>
		<br>
		<form action="ajoutBienIMMO.php" method="post">
			<?php                
				echo "<input type=\"hidden\" name=\"idUtilisateur\" value=\"";
				echo $idUtilisateur;
				echo "\"/>";
			?>
			Nombre de chambres : <input type="number" name="nbChambres"><br>
			Nombre de salles de bain : <input type="number" name="nbSdB"><br>
			Nombre de cuisines : <input type="number" name="nbCuisines"><br>
			Nombre de garages : <input type="number" name="nbGarages"><br>
			Nombre de caves : <input type="number" name="nbCaves"><br>
			Surface : <input type="number" name="surface"><br>
			Taille du terrain : <input type="number" name="tailleTerrain"><br>
			Nombre d'étages : <input type="number" name="nbEtages"><br>
			Nombre d'ascenceurs : <input type="number" name="nbAscenceurs"><br>
			Nom du quartier : <input type="text" name="nomQuartier"><br>
			<input type="radio" name="TypeduBien" value="Maison" checked="">Maison
			<input type="radio" name="TypeduBien" value="Appartement" checked="">Appartement<br>
			<input type="submit" value="Crée le bien.">
		</form>
	</body>
</html>
