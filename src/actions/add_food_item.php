<?php

declare(strict_types=1);

session_start();

require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../includes/helpers.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    redirect('../../public/index.php?page=bills');
}

require_csrf();

$orderNo = filter_input(INPUT_POST, 'order_no', FILTER_VALIDATE_INT);
$itemDescription = trim((string) ($_POST['item_description'] ?? ''));
$quantity = filter_input(INPUT_POST, 'quantity', FILTER_VALIDATE_INT);
$unitPrice = filter_input(INPUT_POST, 'unit_price', FILTER_VALIDATE_FLOAT);

if (
    !$orderNo ||
    $itemDescription === '' ||
    strlen($itemDescription) > 120 ||
    !$quantity ||
    $quantity < 1 ||
    $quantity > 100 ||
    $unitPrice === false ||
    $unitPrice < 0 ||
    $unitPrice > 100000
) {
    $_SESSION['flash'] = ['type' => 'error', 'message' => 'Invalid form input.'];
    redirect('../../public/index.php?page=bills');
}

$normalizedPrice = number_format((float) $unitPrice, 2, '.', '');

$pdo = db();

try {
    $existsStmt = $pdo->prepare('SELECT 1 FROM orders WHERE order_no = ? LIMIT 1');
    $existsStmt->execute([$orderNo]);
    if (!$existsStmt->fetchColumn()) {
        throw new RuntimeException('Order does not exist.');
    }

    $stmt = $pdo->prepare(
        'INSERT INTO food_item (quantity, unit_price, item_description, order_no) VALUES (?, ?, ?, ?)'
    );
    $stmt->execute([$quantity, $normalizedPrice, $itemDescription, $orderNo]);

    $_SESSION['flash'] = ['type' => 'ok', 'message' => 'Food item added and bill recalculated.'];
} catch (Throwable $e) {
    $_SESSION['flash'] = ['type' => 'error', 'message' => 'Failed to add food item. Check input data and try again.'];
}

redirect('../../public/index.php?page=bills');
