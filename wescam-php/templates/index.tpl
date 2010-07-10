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
{if $signed_in}
            <div id="who-you-want">
                <h3>who you want <span style="margin-left: .2em; font-size: 12px">(<strike>25</strike> 40 slots)</span></h3>
                <form action="." method="post" id="add_someone">
                <ol>
                    <li value="{math equation="x + 1" x=$who_you_want|@count}"><input id="crushee" class="text" type="text" maxlength="12" size="12" type="text" /> <img src="{$site}images/load.gif" id="load" alt="" /> <input type="submit" disabled="disabled" value="add username" id="add" /></li>
    {section name=i loop=$who_you_want step=-1}
                    <li id="crushee_{$who_you_want[i].crushee_id}"{if $who_you_want[i].match} class="match"{/if} value="{math equation="x + 1" x=$smarty.section.i.index}">{$who_you_want[i].name}{if $who_you_want[i].match} &hearts;{/if} <a href="{$site}message/{$who_you_want[i].crushee_id}/">msg</a></li>
    {/section}
                </ol>
                </form>
                <p style="margin: 15em 0 .2em; line-height: 1.2;"><span style="font-size: 11px">Don't know their username?<br>Try using <a href="http://scihall.com/find/" target="_blank">this directory</a> (more convenient).<br>Or the official <a href="http://www.wesleyan.edu/directory/" target="_blank">Wesleyan directory</a> (more official?).</span></p>
            </div>
            <div id="who-want-you">
                <h3>who want you</h3>
    {if $who_want_you}
                <ol>
    {section name=i loop=$who_want_you step=-1}
                    <li id="crusher_{$who_want_you[i].crusher_id}"{if $who_want_you[i].match} class="match"{/if} value="{math equation="x + 1" x=$smarty.section.i.index}">{if $who_want_you[i].match}{$who_want_you[i].name}{else}{$who_want_you[i].crusher_alias}{/if}{if $who_want_you[i].match} &hearts;{/if} <a href="{$site}message/{$who_want_you[i].crusher_id}/">msg</a></li>
    {/section}
                </ol>
    {else}
                <p><span><em>{$quote}</em></p>
                <p><span>{$quoted}</span></p>
    {/if}
            </div>
{else}
    {if $wesnetwork or $woodframe}
        {if $wesnetwork}
            <p>Good, you're on the Wesleyan network. Login or register in the sidebar.</p>
        {elseif $woodframe}
            <p>Good, you're in a woodframe. Login or register in the sidebar.</p>
        {/if}
        
            <p>Also, read the <a href="{$site}faq/">frequently asked questions</a>.</p>
    {else}
            <p>You're not on the Wesleyan network or in a woodframe. Maybe go to ST Lab.</p>
            <p>Feel free to read the <a href="{$site}faq/">frequently asked questions</a>, however.</p>
    {/if}
            <p><span>Some people have already asked us if you can reset your password. You can't. At least not yet. We're working on adding password reset. For now, just try and make sure your password is correct :).</span></p>
            <p><span><em>Also, for the love of god, can someone tell us what Wescam means? We have no idea either.</em></span></p>
{/if}
        </div>
        <div id="nav">
            <h1><a href="{$site}">Wescam</a></h1>
            <ul>
{if $signed_in}
                <li><a href="{$site}logout/">logout</a></li>
{elseif $wesnetwork or $woodframe}

                <li><a href="{$site}login/">login</a></li>
                <li><a href="{$site}register/">register</a></li>
{/if}
                <li><a href="{$site}faq/">faq</a></li>
            </ul>
{include file='includes/stats.tpl'}
        </div>
        <input value="{$site}" name="wc_site" id="wc_site" type="hidden" />
    </body>
</html>