<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
{if $success || $already}
        <meta http-equiv="Refresh" content="3; URL={$site}login/" />
{/if}
{if $already}
        <title>Wescam - Registration already confirmed</title>
{else}
        <title>Wescam - Confirm registration</title>
{/if}
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

{if $signed_in}
            <h2>uhh...</h2>
            <p>You're already confirmed as {$signed_in}.</p>
{elseif $success}
            <h2>good job!</h2>
            <p>You have successfully confirmed your account. You will be redirected to the login page in five seconds.</p>
{elseif $already}
            <h2>umm...</h2>
            <p>Your account has already been confirmed. You will be redirected to the login page in three seconds.</p>
{else}
            <h2>are you... you?</h2>
{if $no_code}
            <p>An error occurred: no confirmation code was passed.</p>
{else}
            <form method="post">
                <input class="text" value="{$username}" name="username" id="focus" type="text" /> <span>@wesleyan.edu</span>
{if $incorrect_user || $incorrect_code}
                <span class="error">username was incorrect</span>
{elseif $empty_user}
                <span class="error">required</span>
{/if}

                <input name="submit" type="submit" value="confirm" id="submit" />
            </form>
{/if}
{/if}

{else}
            <p>You need to be on the Wesleyan network or in a woodframe to access this page.</p>
{/if}
        </div>

        <div id="nav">
            <h1><a href="{$site}">Wescam</a></h1>
{if $signed_in}
            <ul>
                <li><a href="{$site}logout/">log out</a></li>
            </ul>
{/if}
        </div>
    </body>
</html>