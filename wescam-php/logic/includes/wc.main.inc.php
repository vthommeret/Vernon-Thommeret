<?php
define('SITE', '/');

include('wc.db.inc.php');

$smarty = new Smarty();

$smarty->assign('site', SITE);

/*
header('HTTP/1.1 503 Service Unavailable');
$smarty->assign('code', 503);
$smarty->assign('error', 'coffee break');
$smarty->assign('description', "we're taking a coffee break and should be up in a few. any updates will be on this page.");
$smarty->display('error.tpl');
die;
*/

$user_ip = $_SERVER['REMOTE_ADDR'];
$smarty->assign('wesnetwork', preg_match("/129\.133\..+/", $user_ip));
$smarty->assign('woodframe', preg_match("/99\.50\..+/", $user_ip));

session_start();

$prefix = SITE . 'logic';
$allowed = array(
	"$prefix/confirm.php",
	"$prefix/index.php",
	"$prefix/login.php",
	"$prefix/register.php",
	"$prefix/faq.php",
	"$prefix/errors/404.php",
	"$prefix/errors/500.php"
);

$can_view_page = in_array($_SERVER['PHP_SELF'], $allowed);

// retrieve some stats
if ($_SESSION['signed_in'] || $can_view_page) {
    $stats_file = 'removed';

    $diff = time() - filemtime($stats_file);
    
    if ($diff > 60 * 60) {
        $db = connect_to_db();
        
        $students_registered = select_p($db, 'select count(*) from user where registered = 1', array(), 'getOne');
        $students_added = select_p($db, 'select count(distinct crushee_id) from crushes', array(), 'getOne');
        $matches_made = select_p($db, 'select count(c1.crusher_id) from crushes c1, crushes c2 where c1.crusher_id = c2.crushee_id and c1.crushee_id = c2.crusher_id', array(), 'getOne');
        
        close_db($db);
        
        $stats = "{$students_registered},{$students_added},{$matches_made}";
        
        $fh = fopen($stats_file, 'w');
        fwrite($fh, $stats);
        fclose($fh);
    } else {
        $fh = fopen($stats_file, 'r');
        $stats = fread($fh, filesize($stats_file));
        fclose($fh);
        
        $stats = explode(',', $stats);
        
        $students_registered = $stats[0];
        $students_added = $stats[1];
        $matches_made = $stats[2];
    }
    
	$smarty->assign('students_registered', $students_registered);
	$smarty->assign('students_added', $students_added);
	$smarty->assign('matches_made', $matches_made);
}

if ($_SESSION['signed_in']) {
	$signed_in = $_SESSION['signed_in'];
    $signed_in_id = $_SESSION['signed_in_id'];
    $signed_in_name = $_SESSION['signed_in_name'];
    $signed_in_division = $_SESSION['signed_in_division'];

	$smarty->assign('signed_in', $_SESSION['signed_in']);
	$smarty->assign('signed_in_id', $_SESSION['signed_in_id']);
	$smarty->assign('signed_in_name', $_SESSION['signed_in_name']);
	$smarty->assign('signed_in_division', $_SESSION['signed_in_division']);
} else if (!$can_view_page) {
	header('Location: ' . SITE . 'login/');
	die;
}

// from http://phpsec.org/articles/2005/password-hashing.html
// generates a salted hash for our passwords
function generateHash($plainText, $salt = null) {
	define('SALT_LENGTH', 9);

    if ($salt === null)
        $salt = substr(md5(uniqid(rand(), true)), 0, SALT_LENGTH);
	else
        $salt = substr($salt, 0, SALT_LENGTH);

    return $salt . sha1($salt . $plainText);
}

// from http://www.laughing-buddha.net/jon/php/password/
// used for our confirm code
function randomString ($length = 15) {
	$randomString = '';

	$possible = '0123456789bcdfghjkmnpqrstvwxyz';

	$i = 0; 

	// add random characters to $password until $length is reached
	while ($i < $length) { 
		// pick a random character from the possible ones
		$char = substr($possible, mt_rand(0, strlen($possible)-1), 1);

		// we don't want this character if it's already in the password
		if (!strstr($randomString, $char)) { 
			$randomString = $randomString.$char;
			$i++;
		}
	}

  return $randomString;
}

?>
