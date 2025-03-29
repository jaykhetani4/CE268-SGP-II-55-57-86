<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

$data = json_decode(file_get_contents("php://input"), true);

// Debugging: Log received JSON data
file_put_contents("log.txt", print_r($data, true));

if (!$data) {
    echo json_encode(["success" => false, "message" => "JSON parsing error or empty request."]);
    exit();
}

if (!empty($data['user_name']) && !empty($data['user_mobile_num']) && !empty($data['parents_mobile_num']) && !empty($data['user_password'])) {
    // Assign variables
    $name = $data['user_name'];
    $mobile = $data['user_mobile_num'];
    $parentMobile = $data['parents_mobile_num'];
    $password = $data['user_password'];
    $hashedPassword=password_hash($password,PASSWORD_DEFAULT);
if (!$hashedPassword) {
    die(json_encode(["success" => false, "message" => "Password hashing failed."]));
}

    // Database connection
    include '../connection.php';
    file_put_contents("log.txt", "Hashed Password: " . $hashedPassword . "\n", FILE_APPEND);

    $stmt = $connectNow->prepare("INSERT INTO users_login (user_name, user_mobile_num, parents_mobile_num, user_password) VALUES (?,?,?,?)");
    if (!$stmt) {
        echo json_encode(["success" => false, "message" => "SQL Prepare Error: " . $connectNow->error]);
        exit();
    }

    $stmt->bind_param("ssss", $name, $mobile, $parentMobile, $hashedPassword);

    if ($stmt->execute()) {
        echo json_encode(["success" => true, "message" => "User registered successfully."]);
    } else {
        echo json_encode(["success" => false, "message" => "SQL Execution Error: " . $stmt->error]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Invalid or missing data."]);
}
?>
