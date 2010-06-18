<?php

/** This is the 500 error page */

include('../includes/wc.main.inc.php');

header('HTTP/1.0 500 Internal Server Error');

$smarty->assign('code', 500);
$smarty->assign('error', 'coffee break');
$smarty->assign('description', "we're taking a coffee break. any updates will be on this page.");

$smarty->display('error.tpl');

?>