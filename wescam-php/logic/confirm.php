<?php

/**
    registration confirmation page
*/

// rework logic

include('includes/wc.main.inc.php');

$confirm_code = $_GET['confirm_code'];
$username = $_POST['username'];

if (empty($confirm_code)) {
    $smarty->assign('no_code', true);
    $smarty->display('confirm.tpl');
} else if (!empty($_POST['submit'])) {
    if (empty($username)) {
        $smarty->assign('empty_user', true);
        $smarty->display('confirm.tpl');
    } else {
        $db = connect_to_db();

        if (!select_p($db, 'select username from user where username = ?', array($username), 'getOne')) {
            $smarty->assign('username', stripslashes($username));
            $smarty->assign('incorrect_user', true);
            $smarty->display('confirm.tpl');
        } else {
            $real_code = select_p($db, 'select code from user_confirm where username = ?', array($username), 'getOne');

            if (!$real_code) {
                $smarty->assign('already', true);
                $smarty->display('confirm.tpl');
            } else {
                if ($confirm_code == $real_code) {
                    query_p($db, 'delete from user_confirm where username = ?', array($username));
                    query_p($db, 'update user set registered = 1 where username = ?', array($username));

                    $smarty->assign('username', stripslashes($username));
                    $smarty->assign('success', true);
                    $smarty->display('confirm.tpl');
                } else {
                    $smarty->assign('username', stripslashes($username));
                    $smarty->assign('incorrect_code', true);
                    $smarty->display('confirm.tpl');
                }
            }
        }
    }
} else {
    $smarty->display('confirm.tpl');
}

?>
