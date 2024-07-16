#!/bin/bash
apt update && apt upgrade -y
apt install -y nginx
systemctl enable nginx
systemctl start nginx
echo "<!-- HTML Codes by Quackit.com -->
<!DOCTYPE html>
<title>Text Example</title>
<style>
div.container {
background-color: #ffffff;
}
div.container p {
text-align: center;
font-family: Helvetica;
font-size: 14px;
font-style: normal;
font-weight: bold;
text-decoration: blink;
text-transform: capitalize;
color: #000000;
background-color: #ffffff;
}
</style>

<div class="container">
<h1>Team success caught me today.</h1>
<p>I love AWS!</p>
</div>" > /var/www/html/index.html