<?php

declare(strict_types=1);

$pdo = db();
$orders = $pdo->query('SELECT order_no FROM orders ORDER BY order_no DESC')->fetchAll();
$bills = $pdo->query('SELECT bill_no, order_no, total_price, payment_notes FROM bill ORDER BY bill_no DESC LIMIT 20')->fetchAll();

$flash = $_SESSION['flash'] ?? null;
unset($_SESSION['flash']);
?>
<section class="grid">
    <article class="card">
        <h2>Add Food Item (Auto Updates Bill)</h2>
        <?php if ($flash): ?>
            <p class="<?= h($flash['type']) ?>"><?= h($flash['message']) ?></p>
        <?php endif; ?>
        <form method="post" action="../src/actions/add_food_item.php">
            <input type="hidden" name="csrf_token" value="<?= h(csrf_token()) ?>">

            <label>Order Number</label>
            <select name="order_no" required>
                <?php foreach ($orders as $order): ?>
                    <option value="<?= h((string) $order['order_no']) ?>"><?= h((string) $order['order_no']) ?></option>
                <?php endforeach; ?>
            </select>

            <label>Item Description</label>
            <input type="text" name="item_description" maxlength="120" required>

            <label>Quantity</label>
            <input type="number" name="quantity" min="1" required>

            <label>Unit Price</label>
            <input type="number" name="unit_price" min="0" step="0.01" required>

            <button type="submit">Add Food Item</button>
        </form>
    </article>

    <article class="card">
        <h2>Latest Bills</h2>
        <table>
            <thead>
            <tr>
                <th>Bill</th>
                <th>Order</th>
                <th>Total</th>
                <th>Notes</th>
            </tr>
            </thead>
            <tbody>
            <?php foreach ($bills as $bill): ?>
                <tr>
                    <td><?= h((string) $bill['bill_no']) ?></td>
                    <td><?= h((string) $bill['order_no']) ?></td>
                    <td>INR <?= h(number_format((float) $bill['total_price'], 2)) ?></td>
                    <td><?= h((string) $bill['payment_notes']) ?></td>
                </tr>
            <?php endforeach; ?>
            </tbody>
        </table>
    </article>
</section>
