<?php

/** This is the 404 error page */

include('../includes/wc.main.inc.php');

header('HTTP/1.0 404 Not Found');

$smarty->assign('error', 'move along');
$smarty->assign('description', "this never should have happened");

$smarty->display('error.tpl');

?>