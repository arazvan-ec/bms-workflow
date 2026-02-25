#!/usr/bin/env php
<?php

declare(strict_types=1);

/**
 * Software Factory - Scaffolding Generator
 *
 * Genera la estructura completa de archivos para una nueva feature
 * basándose en las plantillas del factory.
 *
 * Uso:
 *   php .factory/scaffold.php <ResourceName> [--no-tests] [--no-controller]
 *
 * Ejemplo:
 *   php .factory/scaffold.php Product
 *   php .factory/scaffold.php OrderItem --no-controller
 */

// =============================================================================
// Configuración
// =============================================================================

$templateDir = __DIR__ . '/templates';
$projectRoot = dirname(__DIR__);

$mapping = [
    'entity'          => ['tpl' => 'entity.php.tpl',          'target' => 'src/Entity/{Name}.php'],
    'repository'      => ['tpl' => 'repository.php.tpl',      'target' => 'src/Repository/{Name}Repository.php'],
    'request_dto'     => ['tpl' => 'request_dto.php.tpl',     'target' => 'src/DTO/Request/Create{Name}Request.php'],
    'response_dto'    => ['tpl' => 'response_dto.php.tpl',    'target' => 'src/DTO/Response/{Name}Response.php'],
    'exception'       => ['tpl' => 'exception.php.tpl',       'target' => 'src/Exception/{Name}NotFoundException.php'],
    'service'         => ['tpl' => 'service.php.tpl',         'target' => 'src/Service/{Name}Service.php'],
    'controller'      => ['tpl' => 'controller.php.tpl',      'target' => 'src/Controller/{Name}Controller.php'],
    'unit_test'       => ['tpl' => 'unit_test.php.tpl',       'target' => 'tests/Unit/Service/{Name}ServiceTest.php'],
    'functional_test' => ['tpl' => 'functional_test.php.tpl', 'target' => 'tests/Functional/Controller/{Name}ControllerTest.php'],
];

// =============================================================================
// Parse arguments
// =============================================================================

if ($argc < 2) {
    echo <<<USAGE
    \033[33mSoftware Factory - Scaffolding Generator\033[0m

    Uso: php .factory/scaffold.php <ResourceName> [opciones]

    Opciones:
      --no-tests        No generar archivos de test
      --no-controller   No generar controller ni functional test
      --dry-run         Mostrar qué archivos se crearían sin crearlos

    Ejemplo:
      php .factory/scaffold.php Product
      php .factory/scaffold.php OrderItem --no-controller
      php .factory/scaffold.php User --dry-run

    USAGE;
    exit(1);
}

$resourceName = $argv[1];
$noTests = in_array('--no-tests', $argv, true);
$noController = in_array('--no-controller', $argv, true);
$dryRun = in_array('--dry-run', $argv, true);

// Validate name
if (!preg_match('/^[A-Z][a-zA-Z0-9]+$/', $resourceName)) {
    echo "\033[31mError: El nombre del recurso debe ser PascalCase (ej: Product, OrderItem)\033[0m\n";
    exit(1);
}

// =============================================================================
// Replacements
// =============================================================================

$tableName = strtolower(preg_replace('/(?<!^)[A-Z]/', '_$0', $resourceName));
$resourcePlural = $tableName . 's';

$replacements = [
    '{EntityName}'       => $resourceName,
    '{Name}'             => $resourceName,
    '{Resource}'         => $resourceName,
    '{Action}'           => 'Create',
    '{table_name}'       => $tableName,
    '{resource_plural}'  => $resourcePlural,
];

// =============================================================================
// Filter mapping based on options
// =============================================================================

if ($noTests) {
    unset($mapping['unit_test'], $mapping['functional_test']);
}

if ($noController) {
    unset($mapping['controller'], $mapping['functional_test']);
}

// =============================================================================
// Generate files
// =============================================================================

echo "\n\033[33m╔══════════════════════════════════════════════════════════╗\033[0m\n";
echo "\033[33m║  Software Factory - Generando scaffolding               ║\033[0m\n";
echo "\033[33m╚══════════════════════════════════════════════════════════╝\033[0m\n\n";
echo "  Recurso: \033[32m{$resourceName}\033[0m\n";
echo "  Tabla:   \033[32m{$tableName}\033[0m\n\n";

$created = 0;
$skipped = 0;

foreach ($mapping as $type => $config) {
    $templatePath = $templateDir . '/' . $config['tpl'];
    $targetPath = $projectRoot . '/' . str_replace(array_keys($replacements), array_values($replacements), $config['target']);

    // Check if file already exists
    if (file_exists($targetPath)) {
        echo "  \033[33m[SKIP]\033[0m {$targetPath} (ya existe)\n";
        $skipped++;
        continue;
    }

    if ($dryRun) {
        echo "  \033[36m[DRY]\033[0m  {$targetPath}\n";
        $created++;
        continue;
    }

    // Read template
    if (!file_exists($templatePath)) {
        echo "  \033[31m[ERR]\033[0m  Template no encontrado: {$templatePath}\n";
        continue;
    }

    $content = file_get_contents($templatePath);
    $content = str_replace(array_keys($replacements), array_values($replacements), $content);

    // Remove template header comments
    $content = preg_replace(
        '/\/\/ =+\n\/\/ Software Factory Template:.*?\n\/\/ =+\n\/\/.*?\n\/\/ =+\n/s',
        '',
        $content,
    );

    // Create directory if needed
    $dir = dirname($targetPath);
    if (!is_dir($dir)) {
        mkdir($dir, 0755, true);
    }

    // Write file
    file_put_contents($targetPath, $content);
    echo "  \033[32m[OK]\033[0m   {$targetPath}\n";
    $created++;
}

echo "\n  ────────────────────────────────────────\n";
echo "  Creados: \033[32m{$created}\033[0m | Omitidos: \033[33m{$skipped}\033[0m\n\n";

if (!$dryRun && $created > 0) {
    echo "  \033[36mSiguientes pasos:\033[0m\n";
    echo "  1. Completar las propiedades de la entidad en src/Entity/{$resourceName}.php\n";
    echo "  2. Generar migración: php bin/console doctrine:migrations:diff\n";
    echo "  3. Completar la lógica del servicio en src/Service/{$resourceName}Service.php\n";
    echo "  4. Descomentar y completar los endpoints del controller\n";
    echo "  5. Descomentar y completar los tests\n";
    echo "  6. Ejecutar quality gate: make quality\n\n";
}
