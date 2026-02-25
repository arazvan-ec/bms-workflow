#!/usr/bin/env php
<?php

declare(strict_types=1);

/**
 * Software Factory - Workflow Validator
 *
 * Verifica que el código del proyecto sigue las convenciones de la Software Factory:
 * - Cada Entity tiene su Repository
 * - Cada Service tiene su Unit Test
 * - Cada Controller tiene su Functional Test
 * - Todos los archivos PHP tienen declare(strict_types=1)
 * - Los DTOs son readonly
 *
 * Uso:
 *   php .factory/validate.php
 */

$projectRoot = dirname(__DIR__);
$errors = [];
$warnings = [];

echo "\n\033[33m╔══════════════════════════════════════════════════════════╗\033[0m\n";
echo "\033[33m║  Software Factory - Validación de estructura            ║\033[0m\n";
echo "\033[33m╚══════════════════════════════════════════════════════════╝\033[0m\n\n";

// =============================================================================
// 1. Check strict_types in all PHP files
// =============================================================================

echo "  \033[36m[CHECK]\033[0m declare(strict_types=1) en archivos PHP...\n";

$phpFiles = new RegexIterator(
    new RecursiveIteratorIterator(
        new RecursiveDirectoryIterator($projectRoot . '/src'),
    ),
    '/\.php$/',
);

foreach ($phpFiles as $file) {
    $content = file_get_contents($file->getPathname());
    if (!str_contains($content, 'declare(strict_types=1)')) {
        $relative = str_replace($projectRoot . '/', '', $file->getPathname());
        $errors[] = "Falta declare(strict_types=1) en {$relative}";
    }
}

// =============================================================================
// 2. Check Entity <-> Repository consistency
// =============================================================================

echo "  \033[36m[CHECK]\033[0m Consistencia Entity <-> Repository...\n";

$entityDir = $projectRoot . '/src/Entity';
$repoDir = $projectRoot . '/src/Repository';

if (is_dir($entityDir)) {
    foreach (glob($entityDir . '/*.php') as $entityFile) {
        $entityName = basename($entityFile, '.php');
        if ($entityName === 'Kernel') {
            continue;
        }
        $repoFile = $repoDir . '/' . $entityName . 'Repository.php';
        if (!file_exists($repoFile)) {
            $warnings[] = "Entity {$entityName} no tiene Repository correspondiente ({$entityName}Repository.php)";
        }
    }
}

// =============================================================================
// 3. Check Service <-> Unit Test consistency
// =============================================================================

echo "  \033[36m[CHECK]\033[0m Consistencia Service <-> Unit Test...\n";

$serviceDir = $projectRoot . '/src/Service';
$unitTestDir = $projectRoot . '/tests/Unit/Service';

if (is_dir($serviceDir)) {
    foreach (glob($serviceDir . '/*.php') as $serviceFile) {
        $serviceName = basename($serviceFile, '.php');
        $testFile = $unitTestDir . '/' . $serviceName . 'Test.php';
        if (!file_exists($testFile)) {
            $warnings[] = "Service {$serviceName} no tiene Unit Test ({$serviceName}Test.php)";
        }
    }
}

// =============================================================================
// 4. Check Controller <-> Functional Test consistency
// =============================================================================

echo "  \033[36m[CHECK]\033[0m Consistencia Controller <-> Functional Test...\n";

$controllerDir = $projectRoot . '/src/Controller';
$funcTestDir = $projectRoot . '/tests/Functional/Controller';

if (is_dir($controllerDir)) {
    foreach (glob($controllerDir . '/*.php') as $controllerFile) {
        $controllerName = basename($controllerFile, '.php');
        $testFile = $funcTestDir . '/' . $controllerName . 'Test.php';
        if (!file_exists($testFile)) {
            $warnings[] = "Controller {$controllerName} no tiene Functional Test ({$controllerName}Test.php)";
        }
    }
}

// =============================================================================
// 5. Check DTOs are readonly
// =============================================================================

echo "  \033[36m[CHECK]\033[0m DTOs son readonly...\n";

$dtoDir = $projectRoot . '/src/DTO';

if (is_dir($dtoDir)) {
    $dtoFiles = new RegexIterator(
        new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($dtoDir),
        ),
        '/\.php$/',
    );

    foreach ($dtoFiles as $file) {
        $content = file_get_contents($file->getPathname());
        if (!str_contains($content, 'readonly class') && !str_contains($content, 'readonly final class') && !str_contains($content, 'final readonly class')) {
            $relative = str_replace($projectRoot . '/', '', $file->getPathname());
            $errors[] = "DTO {$relative} no es readonly";
        }
    }
}

// =============================================================================
// 6. Check Controllers don't contain business logic patterns
// =============================================================================

echo "  \033[36m[CHECK]\033[0m Controllers sin l\u00f3gica de negocio...\n";

if (is_dir($controllerDir)) {
    foreach (glob($controllerDir . '/*.php') as $controllerFile) {
        $content = file_get_contents($controllerFile);
        $relative = str_replace($projectRoot . '/', '', $controllerFile);

        // Check for direct repository usage (should go through service)
        if (preg_match('/->createQueryBuilder\(/', $content)) {
            $warnings[] = "Controller {$relative} usa QueryBuilder directamente (debe delegarse al Service)";
        }

        // Check for EntityManager direct usage
        if (preg_match('/EntityManagerInterface/', $content) && !str_contains($content, '// factory:allow-em')) {
            $warnings[] = "Controller {$relative} inyecta EntityManager directamente (debe delegarse al Service)";
        }
    }
}

// =============================================================================
// Results
// =============================================================================

echo "\n  ────────────────────────────────────────\n\n";

if (count($errors) === 0 && count($warnings) === 0) {
    echo "  \033[32m✓ Todo correcto. La estructura sigue las convenciones de la Software Factory.\033[0m\n\n";
    exit(0);
}

if (count($errors) > 0) {
    echo "  \033[31mErrores ({" . count($errors) . "}):\033[0m\n";
    foreach ($errors as $error) {
        echo "    \033[31m✗\033[0m {$error}\n";
    }
    echo "\n";
}

if (count($warnings) > 0) {
    echo "  \033[33mAdvertencias ({" . count($warnings) . "}):\033[0m\n";
    foreach ($warnings as $warning) {
        echo "    \033[33m!\033[0m {$warning}\n";
    }
    echo "\n";
}

exit(count($errors) > 0 ? 1 : 0);
