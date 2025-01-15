<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "library";

$conn = mysqli_connect($servername, $username, $password, $dbname);

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

$search = $_GET['query'] ?? '';

$search = mysqli_real_escape_string($conn, $search);

$sql = "SELECT * FROM books WHERE author LIKE '%$search%' OR subject LIKE '%$search%'";
$result = mysqli_query($conn, $sql);

$books = [];

if (mysqli_num_rows($result) > 0) {
    while($row = mysqli_fetch_assoc($result)) {
        $books[] = $row;
    }
}

echo json_encode($books);

mysqli_close($conn);
?>
