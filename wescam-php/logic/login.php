<?php

/** login page */

include('includes/wc.main.inc.php');

$username = strtolower(trim($_POST['username']));
$password = trim($_POST['password']);

if (empty($_POST['submit'])) {
    $smarty->display('login.tpl');
} else {
    $errors = array();

    $db = connect_to_db();

    if (empty($username))
        $errors['username'] = 'required';
    else if (strlen($username) > 32)
        $errors['username'] = 'invalid username';
    else if (!select_p($db, 'select username from user where username = ? and registered = 1', array($username), 'getOne'))
        $errors['username'] = 'invalid username';
    else if (select_p($db, 'select username from user_confirm where username = ?', array($username), 'getOne'))
        $errors['username'] = 'username not confirmed';

    close_db($db);

    if (empty($password))
        $errors['password'] = 'required';
    else if (strlen($password) > 32)
        $errors['password'] = 'invalid password';

    if (!empty($errors)) {
        $smarty->assign('username', stripslashes($username));
        $smarty->assign('errors', $errors);
        $smarty->display('login.tpl');
    } else {
        $db = connect_to_db();

        $db_pass = select_p($db, 'select password from user where username = ?', array($username), 'getOne');

        if (generateHash($password, $db_pass) != $db_pass) {
            $errors['username'] = 'username or password incorrect';

            $smarty->assign('username', stripslashes($username));
            $smarty->assign('errors', $errors);
            $smarty->display('login.tpl');
        } else {
            $_SESSION['signed_in'] = stripslashes($username);
            $_SESSION['signed_in_id'] = select_p($db, 'select user_id from user where username = ?', array($username), 'getOne');
            $_SESSION['signed_in_name'] = select_p($db, 'select name from wes_users where username = ?', array($username), 'getOne');
            $_SESSION['signed_in_division'] = select_p($db, 'select division from wes_users where username = ?', array($username), 'getOne');
            header('Location: '. SITE);
        }
    }
}

?>