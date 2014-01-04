<?php
	$idUtilisateur=$_POST['idUtilisateur'];
?>

<html>
	<head>
		<title>Recherche de biens immobiliers.</title>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" >
	</head>
	<body>
		<?php
			echo "Choisissez l'action à réaliser"
		?>
		<form action="listeComplete.php" method="post">
			<?php                
				echo "<input type=\"hidden\" name=\"idUtilisateur\" value=\"";
				echo $idUtilisateur;
				echo "\"/>";
			?>
			<input type="submit" value="Voir la liste complete des biens immobiliers."><br>
		</form>
		<form action="specification.php" method="post">
			<?php                
				echo "<input type=\"hidden\" name=\"idUtilisateur\" value=\"";
				echo $idUtilisateur;
				echo "\"/>";
			?>
			<input type="submit" value="Donner des critères de recherches."><br>
		</form>
	</body>
</html>
