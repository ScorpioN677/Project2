<?php
// Enable CORS
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// Database connection
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "library";

// Create connection
$conn = mysqli_connect($servername, $username, $password, $dbname);

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Get the search query
$search = $_GET['query'] ?? '';

// Sanitize the search input
$search = mysqli_real_escape_string($conn, $search);

// Query to search for books by author or subject
$sql = "SELECT * FROM books WHERE author LIKE '%$search%' OR subject LIKE '%$search%'";
$result = mysqli_query($conn, $sql);

// Initialize an empty array for storing the results
$books = [];

if (mysqli_num_rows($result) > 0) {
    // Fetch all books and store them in the $books array
    while($row = mysqli_fetch_assoc($result)) {
        $books[] = $row;
    }
}

// Output the results as JSON
echo json_encode($books);

// Close the database connection
mysqli_close($conn);
?>
