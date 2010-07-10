<?php

// old import code. don't run it.

/*

die;

include('includes/rb.main.inc.php');

echo '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />';

$chars = array("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z");

$ds = ldap_connect('ldap.wesleyan.edu', 389);

if (!$ds) die;

$db = connect_to_db();

ldap_set_option($ds, LDAP_OPT_PROTOCOL_VERSION, 3);
$r = ldap_bind($ds);

for ($i = 24; $i < count($chars); $i++) {
//    if ($i == 24)
//        break;

    for ($j = 0; $j < count($chars); $j++) {
        $pattern = $chars[$i] . $chars[$j];
        
        searchLdap("name=$pattern*");
    }
}


close_db($db);

ldap_close($ds);

function searchLdap($query) {
    global $ds, $db;

    echo "<br>\n$query<br><br>\n";

    $sr = ldap_search($ds, "o=Wesleyan University,c=US", $query);
    
    $info = ldap_get_entries($ds, $sr);
    
    for ($i = 0; $i < $info["count"]; $i++) {
        $username = $info[$i]["cn"][0];
        $division = $info[$i]["division"][0];
        $name = $info[$i]["personaltitle"][0];
        
        $extrauser = strpos($username, '-');
        
        if ($extrauser === false) {
            if ($username != '') {
                echo "$name ($username) $division<br>\n";
                query_p($db, 'insert into wes_users (username, name, division) values (?,?, ?)', array($username, $name, $division));
            }
        }
    }
}
*/

?>