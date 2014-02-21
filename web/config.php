<?php
include_once './libs/rb.php';
$MYSQL_HOSTNAME = 'localhost';
$MYSQL_DATABASE = 'scaling_hipster';
$MYSQL_USERNAME = 'root';
$MYSQL_PASSWORD = '123';
R::setup('mysql:host=' . $MYSQL_HOSTNAME . '; dbname=' . $MYSQL_DATABASE, $MYSQL_USERNAME, $MYSQL_PASSWORD);
?>
