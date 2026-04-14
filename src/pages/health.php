<?php

declare(strict_types=1);

$status = 'OK';
$message = 'Database connection successful.';

try {
    db()->query('SELECT 1');
} catch (Throwable $e) {
    $status = 'ERROR';
    $message = 'Database connection failed. Check .env settings and MySQL service.';
}
?>
<section class="card">
    <h2>System Health</h2>
    <p>Status: <span class="badge"><?= h($status) ?></span></p>
    <p><?= h($message) ?></p>
</section>
