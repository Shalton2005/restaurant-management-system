<?php

declare(strict_types=1);

$pdo = db();
$customers = $pdo->query('SELECT customer_id, customer_name FROM customer ORDER BY customer_name')->fetchAll();
$waiters = $pdo->query('SELECT waiter_id, waiter_name FROM waiter ORDER BY waiter_name')->fetchAll();
$chefs = $pdo->query('SELECT chef_id, chef_name FROM chef ORDER BY chef_name')->fetchAll();
$orders = $pdo->query('SELECT order_no, item_count, order_time, customer_id, waiter_id, chef_id FROM orders ORDER BY order_no DESC LIMIT 20')->fetchAll();

$flash = $_SESSION['flash'] ?? null;
unset($_SESSION['flash']);
?>
<section class="grid">
    <article class="card">
        <h2>Create Order</h2>
        <?php if ($flash): ?>
            <p class="<?= h($flash['type']) ?>"><?= h($flash['message']) ?></p>
        <?php endif; ?>
        <form method="post" action="../src/actions/create_order.php">
            <input type="hidden" name="csrf_token" value="<?= h(csrf_token()) ?>">
            <label>Item Count</label>
            <input type="number" name="item_count" min="1" required>

            <label>Order Time</label>
            <input type="time" name="order_time" required>

            <label>Customer</label>
            <select name="customer_id" required>
                <?php foreach ($customers as $customer): ?>
                    <option value="<?= h((string) $customer['customer_id']) ?>"><?= h($customer['customer_name']) ?></option>
                <?php endforeach; ?>
            </select>

            <label>Waiter</label>
            <select name="waiter_id" required>
                <?php foreach ($waiters as $waiter): ?>
                    <option value="<?= h((string) $waiter['waiter_id']) ?>"><?= h($waiter['waiter_name']) ?></option>
                <?php endforeach; ?>
            </select>

            <label>Chef</label>
            <select name="chef_id" required>
                <?php foreach ($chefs as $chef): ?>
                    <option value="<?= h((string) $chef['chef_id']) ?>"><?= h($chef['chef_name']) ?></option>
                <?php endforeach; ?>
            </select>

            <button type="submit">Create Order</button>
        </form>
    </article>

    <article class="card">
        <h2>Recent Orders</h2>
        <table>
            <thead>
            <tr>
                <th>Order</th>
                <th>Items</th>
                <th>Time</th>
                <th>Customer</th>
                <th>Waiter</th>
                <th>Chef</th>
            </tr>
            </thead>
            <tbody>
            <?php foreach ($orders as $order): ?>
                <tr>
                    <td><?= h((string) $order['order_no']) ?></td>
                    <td><?= h((string) $order['item_count']) ?></td>
                    <td><?= h($order['order_time']) ?></td>
                    <td><?= h((string) $order['customer_id']) ?></td>
                    <td><?= h((string) $order['waiter_id']) ?></td>
                    <td><?= h((string) $order['chef_id']) ?></td>
                </tr>
            <?php endforeach; ?>
            </tbody>
        </table>
    </article>
</section>
