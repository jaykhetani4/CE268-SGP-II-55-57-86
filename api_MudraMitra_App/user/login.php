<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

error_reporting(0); // Hide warnings for clean JSON response
include("../connection.php");

$data = json_decode(file_get_contents("php://input"), true);

if (!empty($data['user_mobile_num']) && !empty($data['user_password'])) {
    $mobile = $data['user_mobile_num'];
    $password = $data['user_password'];

    // Fetch user record
    $stmt = $conn->prepare("SELECT user_name, user_password FROM users_login WHERE user_mobile_num = ?");
    $stmt->bind_param("s", $mobile);
    $stmt->execute();
    $stmt->store_result();

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
} else {
    echo json_encode(["success" => false, "message" => "Please enter mobile number and password."]);
}
?>
