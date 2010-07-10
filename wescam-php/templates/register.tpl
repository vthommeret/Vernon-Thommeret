<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Wescam - Register</title>
        <style type="text/css">
            @import "{$site}styles/main.css";
        </style>
        <script type="text/javascript" src="{$site}scripts/jquery.js"></script>
        <script type="text/javascript" src="{$site}scripts/main.js"></script>
        <link rel="shortcut icon" type="image/png" href="{$site}images/favicon.png" />
    </head>
    <body>
        <div id="body">
{if $wesnetwork or $woodframe}

{if $success}
            <h2>success!</h2>
            <p>You've successfully registered a Wescam account. There's just one last step. We've just sent an e-mail to {$username}@wesleyan.edu with a link to confirm your registration. As soon as you confirm your registration, you'll be ready to go.</p>
{else}
            <h2>register</h2>
            <form action="./" method="post">
                <input class="text" name="username" value="{$username}" id="focus" type="text" /> <span>@wesleyan.edu</span>
{if $errors.username}
                <span class="error">{$errors.username}</span>
{/if}
                <input class="text" name="password" type="password" />
{if $errors.password}
                <span class="error">{$errors.password}</span>
{/if}

                <input name="submit" type="submit" value="register" id="submit" />
            </form>
{/if}

{else}
            <p>You need to be on the Wesleyan network or in a woodframe to access this page.</p>
{/if}
        </div>

        <div id="nav">
            <h1><a href="{$site}">Wescam</a></h1>
            <ul>
{if $wesnetwork or $woodframe}
                <li><a href="{$site}login/">login</a></li>
{/if}
                <li><a href="{$site}faq/">faq</a></li>
            </ul>
        </div>
    </body>
</html>
