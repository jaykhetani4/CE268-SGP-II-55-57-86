<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include "../connection.php";

// Read incoming data
$data = json_decode(file_get_contents("php://input"), true);

// Log received data
file_put_contents("log.txt", "Received Data: " . print_r($data, true), FILE_APPEND);

// Check if data is received
if (!isset($data['user_mobile_num']) || !isset($data['user_password'])) {
    echo json_encode(["success" => false, "message" => "Missing parameters"]);
    exit();
}

$mobile = $data['user_mobile_num'];
$password = $data['user_password'];

// Check if mobile number exists
$stmt = $connectNow->prepare("SELECT user_name, user_password FROM users_login WHERE user_mobile_num = ?");
$stmt->bind_param("s", $mobile);
$stmt->execute();
$stmt->store_result();

// Log SQL execution
file_put_contents("log.txt", "SQL Executed: Rows Found = " . $stmt->num_rows . "\n", FILE_APPEND);

if ($stmt->num_rows > 0) {
    $stmt->bind_result($userName, $hashedPassword);
    $stmt->fetch();

    // Verify password
    if (password_verify($password, $hashedPassword)) {
        echo json_encode(["success" => true, "message" => "Login successful!", "user_name" => $userName]);
    } else {
        echo json_encode(["success" => false, "message" => "Incorrect password."]);
    }
} else {
    echo json_encode(["success" => false, "message" => "User not found."]);
}
?>
