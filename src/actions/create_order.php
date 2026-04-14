<?php

declare(strict_types=1);

session_start();

require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../includes/helpers.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    redirect('../../public/index.php?page=orders');
}

require_csrf();

$itemCount = filter_input(INPUT_POST, 'item_count', FILTER_VALIDATE_INT);
$orderTime = trim((string) ($_POST['order_time'] ?? ''));
$customerId = filter_input(INPUT_POST, 'customer_id', FILTER_VALIDATE_INT);
$waiterId = filter_input(INPUT_POST, 'waiter_id', FILTER_VALIDATE_INT);
$chefId = filter_input(INPUT_POST, 'chef_id', FILTER_VALIDATE_INT);

if (
    !$itemCount ||
    $itemCount < 1 ||
    $itemCount > 100 ||
    !preg_match('/^([01]\d|2[0-3]):[0-5]\d$/', $orderTime) ||
    !$customerId ||
    !$waiterId ||
    !$chefId
) {
    $_SESSION['flash'] = ['type' => 'error', 'message' => 'Invalid form input.'];
    redirect('../../public/index.php?page=orders');
}

$pdo = db();

try {
    $pdo->beginTransaction();

    $customerExistsStmt = $pdo->prepare('SELECT 1 FROM customer WHERE customer_id = ? LIMIT 1');
    $customerExistsStmt->execute([$customerId]);
    $waiterExistsStmt = $pdo->prepare('SELECT 1 FROM waiter WHERE waiter_id = ? LIMIT 1');
    $waiterExistsStmt->execute([$waiterId]);
    $chefExistsStmt = $pdo->prepare('SELECT 1 FROM chef WHERE chef_id = ? LIMIT 1');
    $chefExistsStmt->execute([$chefId]);

    if (!$customerExistsStmt->fetchColumn() || !$waiterExistsStmt->fetchColumn() || !$chefExistsStmt->fetchColumn()) {
        throw new RuntimeException('Reference ID does not exist.');
    }

    $stmt = $pdo->prepare(
        'INSERT INTO orders (item_count, order_time, customer_id, waiter_id, chef_id) VALUES (?, ?, ?, ?, ?)'
    );
    $stmt->execute([$itemCount, $orderTime, $customerId, $waiterId, $chefId]);

    $orderNo = (int) $pdo->lastInsertId();

    $billStmt = $pdo->prepare('INSERT INTO bill (total_price, payment_notes, order_no) VALUES (0.00, ?, ?)');
    $billStmt->execute(['Pending calculation', $orderNo]);

    $pdo->commit();

    $_SESSION['flash'] = ['type' => 'ok', 'message' => 'Order created successfully.'];
} catch (Throwable $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }
    $_SESSION['flash'] = ['type' => 'error', 'message' => 'Failed to create order. Check input data and try again.'];
}

redirect('../../public/index.php?page=orders');
