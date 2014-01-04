<?php
	$connection=oci_connect("jeremymeyer","sum419520","localhost/ROSA");
	
	if (!$connection) 
	{
		echo "Echec de l'ouverture de la connection." ;
		exit ;
	}
	
	$login=$_POST['login'];
	$mdp=$_POST['mdp'];
	
	//On récupère l'id associée à l'utilisateur
	$query='select est_un(select idUtilisateur from utilisateur where login='.$login.'AND mdp='.$mdp.') from dual';
	
	$sql_result = oci_parse($connection,$query);
	oci_execute($sql_result);
	
	oci_fetch($sql_result);
	
	$reponse = oci_result($sql_result,1);
	
	if($reponse!=1 || $reponse!=2)
	{
		echo "Vous n'etes pas un employé de l'agence Miss." ;
		oci_free_statement($sql_result);
		exit ;
	}
	
	oci_free_statement($sql_result);
	
	$query='select idUtilisateur from utilisateur where login='.$login.'AND mdp='.$mdp;
	
	$sql_result = oci_parse($connection,$query);
	oci_execute($sql_result);
	
	oci_fetch($sql_result);
	
	$idUtilisateur = oci_result($sql_result,1);
	oci_free_statement($sql_result);
?>

<html>
	<head>
		<title>Page d'accueil des employés.</title>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" >
	</head>
	<body>
		<?php
			echo "Choisissez l'action à réaliser"
		?>
		<form action="gestionBienIMMO.php" method="post">
			<?php                
				echo "<input type=\"hidden\" name=\"idUtilisateur\" value=\"";
				echo $idUtilisateur;
				echo "\"/>";
			?>
			<input type="submit" value="Afficher (ou modifier) un (ou des) bien(s) immobilier(s)."><br>
		</form>
		<form action="gestionVisite.php" method="post">
			<?php                
				echo "<input type=\"hidden\" name=\"idUtilisateur\" value=\"";
				echo $idUtilisateur;
				echo "\"/>";
			?>
			<input type="submit" value="Gestion des visites."><br>
		</form>
	</body>
</html>
