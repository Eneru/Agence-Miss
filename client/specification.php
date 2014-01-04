<?php
	$idUtilisateur=$_POST['idUtilisateur'];
?>

<html>
	<head>
		<title>Modifications des infos personnelles</title>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" >
	</head>
	<body>
		<form action="valideRecherche.php" method="post">
			<?php                
				echo "<input type=\"hidden\" name=\"idUtilisateur\" value=\"";
				echo $idUtilisateur;
				echo "\"/>";
			?>
			<input type="submit" value="Valider.">
		</form>
	</body>
</html>
