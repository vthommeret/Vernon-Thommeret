<?php

/** This is the 401 error page */

include('../includes/wc.main.inc.php');

header('HTTP/1.0 401 Unauthorized');

$smarty->assign('error', 'unauthorized');
$smarty->assign('description', "you can't see this.");
$smarty->display('error.tpl');

?>