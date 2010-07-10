<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="Content-Language" content="en-us" />
{if $signed_in}
        <title>Wescam - {$signed_in_name}</title>
{else}
        <title>Wescam</title>
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
            {if $errors.auth}
                <p>{$errors.auth}</p>
            {else}
                {if $sent_message}
                    <h2>Success!</h2>
                    <p>Your message was successfully sent to {$to_name}.</p>
                {else}
                    <h2>To: {$to_name}</h2>
                    
                    <form action="." method="post" id="message">
                        <input type="hidden" name="to_id" id="to_id" value="{$to_id}" />
                        <textarea id="message_body" name="message_body"></textarea>
                        <input type="submit" disabled="disabled" value="send anonymous message" />
                    </form>
                {/if}
            {/if}
{else}
            <p>You need to be on the Wesleyan network or in a woodframe to access this page.</p>
{/if}
        </div>
        <div id="nav">
            <h1><a href="{$site}">Wescam</a></h1>
            <ul>
                <li><a href="{$site}logout/">logout</a></li>
            </ul>
        </div>
        <input value="{$site}" name="wc_site" id="wc_site" type="hidden" />
    </body>
</html>