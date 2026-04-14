<?php

declare(strict_types=1);

$pdo = db();

$metrics = [
    'restaurants' => (int) $pdo->query('SELECT COUNT(*) FROM restaurant')->fetchColumn(),
    'customers' => (int) $pdo->query('SELECT COUNT(*) FROM customer')->fetchColumn(),
    'orders' => (int) $pdo->query('SELECT COUNT(*) FROM orders')->fetchColumn(),
    'total_revenue' => (float) $pdo->query('SELECT IFNULL(SUM(total_price), 0) FROM bill')->fetchColumn(),
];

$recentOrders = $pdo->query('SELECT * FROM vw_order_summary ORDER BY order_no DESC LIMIT 10')->fetchAll();
?>
<section class="grid">
    <article class="card"><h2>Restaurants</h2><p><span class="badge"><?= h((string) $metrics['restaurants']) ?></span></p></article>
    <article class="card"><h2>Customers</h2><p><span class="badge"><?= h((string) $metrics['customers']) ?></span></p></article>
    <article class="card"><h2>Orders</h2><p><span class="badge"><?= h((string) $metrics['orders']) ?></span></p></article>
    <article class="card"><h2>Total Revenue</h2><p><span class="badge">INR <?= h(number_format($metrics['total_revenue'], 2)) ?></span></p></article>
</section>

<section class="card" style="margin-top:14px;">
    <h2>Recent Order Summary</h2>
    <table>
        <thead>
            <tr>
                <th>Order</th>
                <th>Customer</th>
                <th>Restaurant</th>
                <th>Time</th>
                <th>Total</th>
                <th>Payment Notes</th>
            </tr>
        </thead>
        <tbody>
        <?php foreach ($recentOrders as $row): ?>
            <tr>
                <td><?= h((string) $row['order_no']) ?></td>
                <td><?= h($row['customer_name']) ?></td>
                <td><?= h($row['restaurant_name']) ?></td>
                <td><?= h($row['order_time']) ?></td>
                <td>INR <?= h(number_format((float) $row['total_price'], 2)) ?></td>
                <td><?= h($row['payment_notes']) ?></td>
            </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
</section>
