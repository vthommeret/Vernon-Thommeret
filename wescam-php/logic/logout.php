<?php

/**
    logout page
*/

include('includes/wc.main.inc.php');

$_SESSION = array();
session_destroy();

header('Location: ' . SITE);

?>