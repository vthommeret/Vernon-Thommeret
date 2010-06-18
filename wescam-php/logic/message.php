<?php

include('includes/wc.main.inc.php');

if ($_GET['to_id'])
    $to_id = $_GET['to_id'];
else if ($_POST['to_id'])
    $to_id = $_POST['to_id'];

$message_body = $_POST['message_body'];

$db = connect_to_db();

$errors = array();

$you_like_them = select_p($db, 'select * from crushes where crusher_id = ? and crushee_id = ?', array($signed_in_id, $to_id), 'getOne');
$they_like_you = select_p($db, 'select * from crushes where crusher_id = ? and crushee_id = ?', array($to_id, $signed_in_id), 'getOne');

if (!($you_like_them || $they_like_you)) {
    $errors['auth'] = "You're not allowed to message this person.";
} else {
    if ($you_like_them) {
        $to_name = select_p($db, 'select name from wes_users where username = (select username from user where user_id = ?)', array($to_id), 'getOne');
    } else if ($they_like_you) {
        $to_name = select_p($db, 'select crusher_alias from crushes where crusher_id = ? and crushee_id = ?', array($to_id, $signed_in_id), 'getOne');
    }
    
    if ($you_like_them && $they_like_you) {
        $from_name = $signed_in_name;
    } else if ($they_like_you) {
        $from_name = select_p($db, 'select name from wes_users where username = (select username from user where user_id = ?)', array($signed_in_id), 'getOne');
    } else if ($you_like_them) {
        $from_name = select_p($db, 'select crusher_alias from crushes where crusher_id = ? and crushee_id = ?', array($signed_in_id, $to_id), 'getOne');
    }

    $to_username = select_p($db, 'select username from wes_users where username = (select username from user where user_id = ?)', array($to_id), 'getOne');

    /** start e-mail */

    if ($message_body) {
        require_once "/home/syn/swift/swift_required.php";
    
        $transport = Swift_MailTransport::newInstance();
        $mailer = Swift_Mailer::newInstance($transport);
    
        $message = Swift_Message::newInstance() -> setSubject("Wescam - $from_name has messaged you")
          -> setFrom(array('noreply@cam.weshub.com' => 'Wescam'))
          -> setTo(array("$to_username@wesleyan.edu"))
          -> setBody("$from_name sent you the following message. Sign in to respond!\n-----------\n\n$message_body\n\n-----------\nhttp://cam.weshub.com/");
        
        $result = $mailer->send($message);
        
        $smarty->assign('sent_message', true);
    }

    /** end e-mail */
}

close_db($db);

$smarty->assign('to_id', $to_id);
$smarty->assign('to_name', $to_name);
$smarty->assign('errors', $errors);
$smarty->display('message.tpl');

?>