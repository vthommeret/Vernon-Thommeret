<?php

/** main page */

include('includes/wc.main.inc.php');

$db = connect_to_db();

if ($signed_in) {
    $who_you_want = select_p($db, "select crushee_id, (select name from wes_users where username = (select username from user where user_id = crushee_id)) as name from crushes where crusher_id = ?", array($signed_in_id), 'getAll');
    $who_want_you = select_p($db, "select crusher_id, crusher_alias from crushes where crushee_id = ?", array($signed_in_id), 'getAll');
    
    for ($i = 0; $i < count($who_you_want); $i++) {
        $crushee_id = $who_you_want[$i]['crushee_id'];
        $match = select_p($db, "select count(*) from crushes where crusher_id = ? and crushee_id = ?", array($crushee_id, $signed_in_id), 'getOne');
        $who_you_want[$i]['match'] = $match;
    }
    
    for ($i = 0; $i < count($who_want_you); $i++) {
        $crusher_id = $who_want_you[$i]['crusher_id'];
        $match = select_p($db, "select count(*) from crushes where crusher_id = ? and crushee_id = ?", array($signed_in_id, $crusher_id), 'getOne');
        
        // the big reveal... don't fuck up this code
        if ($match) {
            $name = select_p($db, "select name from wes_users where username = (select username from user where user_id = ?)", array($crusher_id), 'getOne');
            $who_want_you[$i]['name'] = $name;
        }
        
        $who_want_you[$i]['match'] = $match;
    }
    
    $smarty->assign('who_you_want', $who_you_want);
    $smarty->assign('who_want_you', $who_want_you);
    
    $quote = select_p($db, "select * from quotes order by rand() limit 1", array(), 'getRow');
    $smarty->assign('quote', $quote['quote']);
    $smarty->assign('quoted', $quote['quoted']);
}

$smarty->display('index.tpl');

close_db($db);

?>