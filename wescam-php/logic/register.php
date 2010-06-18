<?php

/**
    register page
*/

include('includes/wc.main.inc.php');

// clean up our $_POST variables

$username = strtolower(trim($_POST['username']));
$password = trim($_POST['password']);
$submit = $_POST['submit'];

// if the form was submitted
if (empty($submit)) {
    $smarty->display('register.tpl');
} else {
    $errors = array();

    // check all of the variables and build an errors array, if necessary

    if (empty($username))
        $errors['username'] = 'required';
    else if (strlen($username) > 32)
        $errors['username'] = 'username must be less than 32 characters';

    if (empty($password))
        $errors['password'] = 'required';

    // if there are errors, redisplay the login page and report them to the user
    if (!empty($errors)) {
        displayWithErrors($errors);
    // otherwise, try and register them
    } else {
        $db = connect_to_db();

        if (count(select_p($db, "select * from user_confirm where username = ?", array($username),'getAll')) > 0) {
            $errors['username'] = 'already registered - check your e-mail';
            displayWithErrors($errors);
        } else if (count(select_p($db, "select * from user where username = ? and registered = 1", array($username),'getAll')) > 0) {
            $errors['username'] = 'already registered';
            displayWithErrors($errors);
        } else if (!preg_match('/[0-9][0-9][0-9][0-9]/', select_p($db, 'select division from wes_users where username = ?', array($username), 'getOne'))) {
            $errors['username'] = 'only students can sign up';
            displayWithErrors($errors);
        } else {
            $password = generateHash($password);
            $code = randomString();

            $has_dummy_account = select_p($db, "select * from user where username = ? and registered = 0", array($username),'getOne');

            query_p($db, 'start transaction');
            
            if ($has_dummy_account) {
                query_p($db, 'update user set password = ? where username = ?', array($password, $username));
            } else {
                query_p($db, 'insert into user (username, password, registered) values (?,?,0)', array($username, $password));
            }                   
                   
            query_p($db, 'insert into user_confirm (username, code) values (?,?)', array($username, $code));
            query_p($db, 'commit');

            /** start e-mail */

            require_once "/home/syn/swift/swift_required.php";

            $transport = Swift_MailTransport::newInstance();
            $mailer = Swift_Mailer::newInstance($transport);

            $message = Swift_Message::newInstance() -> setSubject("Wescam Confirmation - You did it!")
              -> setFrom(array('noreply@cam.weshub.com' => 'Wescam'))
              -> setTo(array("$username@wesleyan.edu"))
              -> setBody("You're almost there! Just click on the link below!\n\nhttp://cam.weshub.com/confirm/$code/");
            
            $result = $mailer->send($message);

            /** end e-mail */

            $smarty->assign('username', stripslashes($username));
            $smarty->assign('success', true);

            $smarty->display('register.tpl');
        }

        close_db($db);
    }
}

function displayWithErrors($errors) {
    global $smarty, $username;

    $smarty->assign('username', stripslashes($username));
    $smarty->assign('errors', $errors);

    $smarty->display('register.tpl');
}
?>