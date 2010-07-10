<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Wescam - Login</title>
        <style type="text/css">@import "{$site}styles/main.css";</style>
        <script type="text/javascript" src="{$site}scripts/jquery.js"></script>
        <script type="text/javascript" src="{$site}scripts/main.js"></script>
        <link rel="shortcut icon" type="image/png" href="{$site}images/favicon.png" />
    </head>
    <body>
        <div id="body">
{if $wesnetwork or $woodframe}
            <h2>log in</h2>
            <form method="post">
                <input class="text" value="{$username}" name="username" id="focus" type="text" /> <span>@wesleyan.edu</span>
{if $errors.username}
                <span class="error">{$errors.username}</span>
{/if}
                <input class="text" value="{$password}" name="password" type="password" />
{if $errors.password}
                <span class="error">{$errors.password}</span>
{/if}

                <input name="submit" type="submit" value="log in" id="submit" />
            </form>
{else}
            <p>You need to be on the Wesleyan network or in a woodframe to access this page.</p>
{/if}
        </div>

        <div id="nav">
            <h1><a href="{$site}">Wescam</a></h1>
            <ul>
{if $wesnetwork or $woodframe}
                <li><a href="{$site}register/">register</a></li>
{/if}
                <li><a href="{$site}faq/">faq</a></li>
            </ul>
        </div>
    </body>
</html>