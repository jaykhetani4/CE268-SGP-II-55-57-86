<?php

//include '..connection,php';
$serverHost="localhost";
$user="root";
$password="";
$database="mudramitra";

$connectNow=new mysqli($serverHost,$user,$password,$database);
$mobileNumber=$_POST['mobile_number'];

$sqlQuery="SELECT * from users_login WHERE user_mobile_num='$mobileNumber'";

$resultOfQuery=$connectNow->query($sqlQuery);

if($resultOfQuery->num_rows > 0)
{
    //num rows =1  i.e :mobile number already exists in database so user cant register
    echo json_encode(array("mobileNumberFound"=>true));
    
}
else
{
    //mobile number does not exist i.e: user is allowed to signup
    echo json_encode(array("mobileNumberFound"=>false)); 
}