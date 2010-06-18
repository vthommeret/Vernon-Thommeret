<?php

include('includes/wc.main.inc.php');

$stats_file = '../../private/stats.txt';

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

?>