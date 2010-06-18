<?php
include('DB.php');

function connect_to_db() {
	$db_user = "removed";
	$db_password = "removed";
	$db_host = "removed";
	$db = "removed";
	$db_type = "removed";

	$dsn = DB::parseDSN("$db_type://$db_user:$db_password@$db_host/$db");
	$db = DB::connect($dsn);
	
	if (DB::isError($db)) {
		print "Error connecting to the database... ";
		die ($db->getMessage());
	}

	$db->setFetchMode(DB_FETCHMODE_ASSOC);
	$db->query("SET NAMES 'utf8' COLLATE 'utf8_unicode_ci'");

	return $db;
}

function close_db($db) {
	$db->disconnect();
}

function select_p($db, $sql, $values = array(), $mode, $description = '') {
	if (get_magic_quotes_gpc()) {
		for ($i = 0; $i < count($values); $i++)
			$values[$i] = stripslashes($values[$i]);
	}

	if (count($values) > 0) {
		$prepared = $db->prepare($sql);
		$resource = $db->execute($prepared, $values);
	} else {
		$resource = $db->query($sql);
	}

	if (DB::isError($resource)) {
		if ($description)
			echo "<strong>Error: $description</strong> <br />\n";
		
		echo $resource->message."<br />\n";
		echo $resource->userinfo;
		
		die;
	}

	$results = array();

	if ($mode == 'getAll') {
		while ($row =& $resource->fetchRow(DB_FETCHMODE_ASSOC))
			$results[] = $row;
	} else if ($mode == 'getRow') {
		$results =& $resource->fetchRow(DB_FETCHMODE_ASSOC);
	} else if ($mode == 'getCol') {
		while ($row =& $resource->fetchRow(DB_FETCHMODE_ORDERED))
			$results[] = $row[0];
	} else if ($mode == 'getOne') {
		$row =& $resource->fetchRow(DB_FETCHMODE_ORDERED);
		$results = $row[0];
	}

	return $results;
}

function query_p($db, $sql, $values = array()) {
	if (get_magic_quotes_gpc()) {
		for ($i = 0; $i < count($values); $i++)
			$values[$i] = stripslashes($values[$i]);
	}

	if (count($values) > 0) {
		$prepared = $db->prepare($sql);
		$resource = $db->execute($prepared, $values);
	} else {
		$resource = $db->query($sql);
	}

	if (DB::isError($resource)) {
		if ($description)
			echo "<strong>Error: $description</strong> <br />\n";
		
		echo $resource->message."<br />\n";
		echo $resource->userinfo;
		
		die;
	}
}

function catchDbError($query, $note='', $line='') {
	if (DB::isError($query)) {
		if ($line)
			$line = "on line $line";
		 
		if ($note)
			echo "<strong>Error $line: $note</strong> <br />\n";
		
		echo $query->message."<br />\n";
		echo $query->userinfo;
		
		die;
	}

	// if there was no error, then just pass on the results of the query
	return $query;
}
?>