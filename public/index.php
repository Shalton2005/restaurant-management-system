<?php

declare(strict_types=1);

session_start();

require_once __DIR__ . '/../src/config/db.php';
require_once __DIR__ . '/../src/includes/helpers.php';

$page = $_GET['page'] ?? 'dashboard';
$allowedPages = ['dashboard', 'orders', 'bills', 'health'];

if (!in_array($page, $allowedPages, true)) {
    $page = 'dashboard';
}

require __DIR__ . '/../src/includes/header.php';
require __DIR__ . '/../src/pages/' . $page . '.php';
require __DIR__ . '/../src/includes/footer.php';
