<?php
	$idUtilisateur=$_POST['idUtilisateur'];
?>

<html>
	<head>
		<title>Gestion des visites</title>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" >
	</head>
	<body>
		<form action="consultationVisite.php" method="post">
			<?php                
				echo "<input type=\"hidden\" name=\"idUtilisateur\" value=\"";
				echo $idUtilisateur;
				echo "\"/>";
			?>
			<input type="submit" value="Consulter toutes vos visites.">
		</form>
		<br>
		<br>
		<br>
		<form action="ajouteVisite.php" method="post">
			<?php                
				echo "<input type=\"hidden\" name=\"idUtilisateur\" value=\"";
				echo $idUtilisateur;
				echo "\"/>";
			?>
			Identifiant du bien à visiter : <input type="number" name="idBien"><br>
			Date de visite : <input type="text" name="dateR"><br>
			Identifiant de la personne visitante : <input type="number" name="idUtilisateur"><br>
			Duree : <input type="number" name="duree"><br>
			<input type="submit" value="Créer la visite.">
		</form>
	</body>
</html>

