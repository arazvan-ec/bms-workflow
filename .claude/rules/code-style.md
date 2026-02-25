---
paths:
  - "src/**/*.php"
  - "tests/**/*.php"
---

# Estilo de código obligatorio

## Cada archivo PHP debe tener
- `declare(strict_types=1)` como primera declaración después del `<?php`
- Type hints en todos los parámetros y valores de retorno
- Sin `mixed` a menos que sea genuinamente necesario

## Clases
- `final` en clases que no se van a extender (la mayoría)
- `readonly` en DTOs
- Constructor injection siempre (NO setter injection)
- Una clase por archivo

## Prohibiciones estrictas
- NO usar arrays asociativos cuando un DTO es más apropiado
- NO atrapar excepciones genéricas (`catch \Exception`)
- NO usar `static` methods para servicios
- NO acceder a superglobals (`$_GET`, `$_POST`, etc.)
- NO usar `new` para instanciar servicios (usar autowiring)
- NO dejar `var_dump`, `dd()`, `dump()` o `die()` en código

## Ejecutar después de cada cambio
- `vendor/bin/php-cs-fixer fix` para auto-corregir estilo
- `vendor/bin/phpstan analyse` para verificar tipos
