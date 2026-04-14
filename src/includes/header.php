<?php

declare(strict_types=1);
?>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Restaurant Management System</title>
    <style>
        :root {
            --bg: #f4f6ef;
            --surface: #ffffff;
            --ink: #1c2a1f;
            --muted: #506150;
            --brand: #2f7d46;
            --brand-2: #f0b429;
            --line: #dbe3d4;
            --danger: #b3261e;
        }
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            color: var(--ink);
            background: radial-gradient(circle at top right, #edf6e9, var(--bg) 45%);
        }
        .wrap { width: min(1100px, 94vw); margin: 24px auto 48px; }
        .hero {
            background: linear-gradient(120deg, #294d36, #2f7d46 58%, #66b879);
            color: #fff;
            padding: 18px 20px;
            border-radius: 14px;
            box-shadow: 0 12px 30px rgba(26, 70, 40, 0.2);
        }
        .hero h1 { margin: 0; font-size: 1.35rem; }
        .hero p { margin: 6px 0 0; opacity: 0.95; }
        nav {
            margin: 16px 0;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }
        nav a {
            text-decoration: none;
            color: var(--ink);
            background: #fff;
            border: 1px solid var(--line);
            border-radius: 999px;
            padding: 8px 14px;
            font-weight: 600;
        }
        nav a:hover { border-color: var(--brand); color: var(--brand); }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 14px;
        }
        .card {
            background: var(--surface);
            border: 1px solid var(--line);
            border-radius: 12px;
            padding: 14px;
            box-shadow: 0 8px 18px rgba(10, 20, 10, 0.04);
        }
        .card h2 { margin: 0 0 10px; font-size: 1.05rem; }
        form {
            display: grid;
            gap: 8px;
        }
        label { font-size: 0.88rem; color: var(--muted); font-weight: 600; }
        input, select, button {
            font: inherit;
            border: 1px solid var(--line);
            border-radius: 8px;
            padding: 9px 10px;
            width: 100%;
            background: #fff;
        }
        button {
            background: var(--brand);
            color: #fff;
            border: none;
            font-weight: 700;
            cursor: pointer;
        }
        button:hover { filter: brightness(1.03); }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 8px;
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
        }
        th, td {
            border-bottom: 1px solid var(--line);
            padding: 9px;
            text-align: left;
            font-size: 0.92rem;
        }
        th { background: #f0f5ec; font-weight: 700; }
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 0.78rem;
            font-weight: 700;
            background: #e4f4e8;
            color: #1d6b35;
        }
        .error { color: var(--danger); margin: 8px 0; font-weight: 600; }
        .ok { color: #1f7a39; margin: 8px 0; font-weight: 600; }
    </style>
</head>
<body>
    <div class="wrap">
        <section class="hero">
            <h1>Restaurant Management System</h1>
            <p>PHP + MySQL web app on top of your DBMS schema.</p>
        </section>
        <nav>
            <a href="index.php">Dashboard</a>
            <a href="index.php?page=orders">Orders</a>
            <a href="index.php?page=bills">Bills</a>
            <a href="index.php?page=health">Health</a>
        </nav>
