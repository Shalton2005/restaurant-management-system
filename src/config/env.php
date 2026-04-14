<?php

declare(strict_types=1);

function env(string $key, ?string $default = null): ?string
{
    static $loaded = false;

    if (!$loaded) {
        $root = dirname(__DIR__, 2);
        $envFile = $root . DIRECTORY_SEPARATOR . '.env';

        if (is_file($envFile)) {
            $lines = file($envFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) ?: [];

            foreach ($lines as $line) {
                $trimmed = trim($line);
                if ($trimmed === '' || str_starts_with($trimmed, '#') || !str_contains($trimmed, '=')) {
                    continue;
                }

                [$name, $value] = explode('=', $trimmed, 2);
                $_ENV[trim($name)] = trim($value);
            }
        }

        $loaded = true;
    }

    return $_ENV[$key] ?? $default;
}
