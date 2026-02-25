---
paths:
  - "tests/**/*.php"
---

# Convenciones de testing

## Unit Tests (`tests/Unit/`)
- Para Services y Entities
- Mockear todas las dependencias externas (repositories, otros services)
- Testear cada método público del service
- Testear casos edge y errores (excepciones esperadas)
- Nombre: `{ClaseOriginal}Test.php`
- Ubicación: `tests/Unit/Service/` o `tests/Unit/Entity/`

## Integration Tests (`tests/Integration/`)
- Para Repositories
- Usar base de datos de test real
- Testear queries complejas y relaciones
- Ubicación: `tests/Integration/Repository/`

## Functional Tests (`tests/Functional/`)
- Para Controllers/API endpoints
- Extender `WebTestCase` de Symfony
- Testear endpoints HTTP completos (status codes, estructura JSON, headers)
- Testear autenticación/autorización
- Ubicación: `tests/Functional/Controller/`

## Patrones obligatorios en tests
- Usar `#[Test]` atributo en lugar de prefijo `test` en nombre del método
- Un assert lógico por test (relacionados se pueden agrupar)
- Nombres descriptivos: `itThrowsExceptionWhenEmailAlreadyExists`
- Usar data providers para casos con múltiples inputs
- NO mockear la clase bajo test
