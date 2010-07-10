<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>Wescam - {$error}</title>
		<style type="text/css">@import "{$site}styles/main.css";</style>
        <script type="text/javascript" src="{$site}scripts/jquery.js"></script>
        <script type="text/javascript" src="{$site}scripts/main.js"></script>
		<link rel="shortcut icon" type="image/png" href="{$site}images/favicon.png" />
	</head>
	<body>
		<div id="body">
			<h2>{$error}</h2>
			<p>{$description}</p>
		</div>

        <div id="nav">
    		<h1><a href="{$site}">Wescam</a></h1>
{if $code < 500}
    		<ul>
    			<li>&larr; <a href="{$site}">return home</a></li>
    		</ul>
{/if}
		</div>
	</body>
</html>