<?php
include './config.php';

$instance = R::dispense('instance');
$instance->import(array(
    "name" => "heroku instance1", 
    "provider"=> "Heroku", 
    "url"=> "scaling-hipster.herokuapp.com", 
    "owner" => "perera.pasindu@gmail.com", 
    "status"=> "Live", 
    "cpu"=>"80",
    "memory"=>"70"
    ));
R::store($instance);
$instance->import(array(
    "name" => "heroku instance1",
    "provider"=> "Heroku",
    "url"=> "scaling-hipster.herokuapp.com",
    "owner" => "perera.pasindu@gmail.com",
    "status"=> "Live",
    "cpu"=>"80",
    "memory"=>"60"
    ));
R::store($instance);
?>
