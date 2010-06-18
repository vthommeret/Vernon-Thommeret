<?php

/** ajax add code */

include('includes/wc.main.inc.php');

$crushee = strtolower($_POST['crushee']);

if ($crushee == $signed_in) {
    $first_name = explode(' ', $signed_in_name);
    $first_name = $first_name[0];
    $return = array('error' => "I'm afraid I can't let you do that, $first_name.");
} else {
    $db = connect_to_db();
    $name = select_p($db, "select name from wes_users where username = ?", array($crushee), 'getOne');
    
    if (!$name)
        $return = array('error' => 'Invalid username: Not a Wesleyan student.');
    else {
        $num_crushes = select_p($db, 'select count(*) from crushes where crusher_id = ?', array($signed_in_id), 'getOne');
    
        $crushee_division = select_p($db, 'select division from wes_users where username = ?', array($crushee), 'getOne');
    
        $already_added = select_p($db, 'select * from crushes where crusher_id = ? and crushee_id = (select user_id from user where username = ?)', array($signed_in_id, $crushee), 'getOne');
        
        if (!preg_match('/[0-9][0-9][0-9][0-9]/', $crushee_division)) {
            $return = array('error' => "Sorry, you can only add students to your list!");
        } else if ($num_crushes >= 40) {
            $return = array('error' => "Sorry, you can only add up to 40 people to your list!");
        } else if ($signed_in_division != '2010' && $crushee_division != '2010') {
            $return = array('error' => "Sorry, underclassmen can only add seniors!");
        } else if ($already_added) {
            $crushee_name = select_p($db, "select name from wes_users where username = ?", array($crushee), 'getOne');
            $crushee_name = explode(' ', $crushee_name);
            $crushee_name = $crushee_name[0];
            
            $return = array('error' => "Leave $crushee_name alone!");
        } else {
            $already_registered = select_p($db, "select user_id from user where username = ?", array($crushee), 'getOne');
            
            // add dummy account
            if (!$already_registered) {
                query_p($db, "insert into user (username, password, registered) values (?,'hashed',0)", array($crushee));
            }

            do {
                $adjective = ucfirst(select_p($db, "select word from words where type = 'adjective' order by rand() limit 1", array(), 'getOne'));
                $noun = ucfirst(select_p($db, "select word from words where type = 'noun' order by rand() limit 1", array(), 'getOne'));
                $num = rand(1, select_p($db, "select count(*) from wes_users", array(), 'getOne'));
                
                $crusher_alias = "$adjective $noun $num";
                
                $already = select_p($db, 'select crusher_alias from crushes where crusher_alias = ?', array($crusher_alias), 'getOne');
            } while ($already);
            
            $crushee_id = select_p($db, 'select user_id from user where username = ?', array($crushee), 'getOne');
            query_p($db, 'insert into crushes (crusher_id, crusher_alias, crushee_id) values (?,?,?)', array($signed_in_id, $crusher_alias, $crushee_id));
            
            /** send e-mail */
            
            $they_like_you = select_p($db, 'select * from crushes where crusher_id = ? and crushee_id = ?', array($crushee_id, $signed_in_id), 'getOne');
            $successful_match = false;
            
            if ($they_like_you) {
                $successful_match = select_p($db, 'select user_id from user where username = ?', array($crushee), 'getOne');
                $email_subject = "Wescam - $signed_in_name likes you, too!";
                $email_body = "Wow... I mean, we always thought Wescam was a great idea, but we never thought it would actually, you know, *work*!. From everyone at Wescam, congrats!\n\n-Wescam";
            } else {
                $email_subject = "Wescam - Someone on campus has added you";
                $email_body = "Wescam 2010 is a site developed by Wesleyan students for seniors on campus interested in meeting up and someone has added you! Sign in below to learn more!\n\nhttp://cam.weshub.com/";
            }

            require_once "/home/syn/swift/swift_required.php";
            
            $transport = Swift_MailTransport::newInstance();
            $mailer = Swift_Mailer::newInstance($transport);
            
            $message = Swift_Message::newInstance() -> setSubject($email_subject)
                -> setFrom(array('noreply@cam.weshub.com' => 'Wescam'))
                -> setTo(array("$crushee@wesleyan.edu"))
                -> setBody($email_body);

            $mailer->send($message);

            /** end e-mail */

            $return = array('name' => "$name", 'successful_match' => $successful_match, 'error' => false);
        }
    }
    close_db($db);
}

echo json_encode($return);

?>