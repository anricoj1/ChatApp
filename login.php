<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

$servername = "localhost";
$username = #" ";
$password = #" ";
$dbname = #" ";

$userEmail = $_GET["email"];
$userpassword= $_GET["password"];

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 

$sql = "SELECT * FROM users where email = '$userEmail' && password = '$userpassword' ";
$result = $conn->query($sql);

$user_info = [];

if ($result->num_rows > 0) {

	//valid login

	array_push($user_info, array('output' => "Successfully logged in!"));

    echo json_encode($user_info);

} else {
	//invalid login
    array_push($user_info, array('output' => "Invalid username or password"));

    echo json_encode($user_info);
}
$conn->close();

?>
