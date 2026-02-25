# Software Factory - Workflow de Desarrollo Symfony

## Filosofía

Este proyecto sigue la metodología **Software Factory**: cada feature se construye
siguiendo un proceso estandarizado por capas. Nunca se escribe código directamente
sin seguir las fases. El objetivo es que el resultado sea predecible, testeable y
consistente independientemente de quién desarrolle.

---

## Proceso de desarrollo (OBLIGATORIO)

Cuando se pida desarrollar una feature, fix, o cualquier cambio de código, seguir
**siempre** estas fases en orden:

### Fase 1: Análisis

Antes de escribir código:

1. Leer los archivos existentes relevantes en `src/` y `tests/`
2. Identificar entidades, servicios y controladores que se verán afectados
3. Determinar si se necesitan nuevas entidades o modificar existentes
4. Definir los endpoints HTTP que se crearán/modificarán (si aplica)
5. Listar los casos de test que se necesitan

**Output**: Un listado claro de qué archivos se van a crear/modificar y por qué.

### Fase 2: Capa de Dominio (Entity + Repository)

Crear/modificar en este orden:

1. **Entity** (`src/Entity/`) - Entidad Doctrine con:
   - `declare(strict_types=1)` en CADA archivo
   - Atributos PHP 8 para mapping (`#[ORM\Entity]`, `#[ORM\Column]`, etc.)
   - Propiedades tipadas, constructor cuando tenga sentido
   - Sin lógica de negocio (solo getters/setters y métodos de dominio puros)

2. **Repository** (`src/Repository/`) - Extiende `ServiceEntityRepository`:
   - Solo métodos de consulta a BD
   - Métodos con nombres descriptivos (`findActiveByEmail`, no `find2`)
   - Usar QueryBuilder para consultas complejas

3. **Migración** - Generar con `doctrine:migrations:diff` después de crear/modificar entidades

### Fase 3: Capa de Servicio (Service + DTO)

1. **DTO** (`src/DTO/`) - Para input/output:
   - Clases readonly con propiedades tipadas
   - Atributos de validación de Symfony (`#[Assert\NotBlank]`, etc.)
   - Un DTO de request y uno de response por operación si es necesario

2. **Service** (`src/Service/`) - Lógica de negocio:
   - Una responsabilidad por servicio
   - Inyección de dependencias por constructor
   - Métodos con tipos de retorno explícitos
   - Lanzar excepciones de dominio específicas (NO genéricas)
   - NUNCA acceder al Request HTTP directamente desde un servicio

### Fase 4: Capa HTTP (Controller)

1. **Controller** (`src/Controller/`) - Solo orquestación HTTP:
   - Usar atributos de routing (`#[Route]`)
   - Validar input con el Validator de Symfony
   - Delegar lógica al Service
   - Retornar JsonResponse con códigos HTTP apropiados
   - Documentar con atributos de OpenAPI si es un API endpoint

Patrón de un action en controller:
```php
#[Route('/api/resource', methods: ['POST'])]
public function create(Request $request): JsonResponse
{
    // 1. Deserializar input a DTO
    // 2. Validar DTO
    // 3. Llamar al servicio
    // 4. Retornar respuesta
}
```

### Fase 5: Tests

Crear tests para cada capa:

1. **Unit Tests** (`tests/Unit/`) - Para Services y Entities:
   - Mockear dependencias externas
   - Testear cada método público
   - Testear casos edge y errores
   - Nombre: `{Clase}Test.php`

2. **Integration Tests** (`tests/Integration/`) - Para Repositories:
   - Usar base de datos de test real
   - Testear queries complejas
   - Verificar relaciones

3. **Functional Tests** (`tests/Functional/`) - Para Controllers/API:
   - Testear endpoints HTTP completos
   - Verificar códigos de respuesta, estructura JSON
   - Testear autenticación/autorización
   - Usar `WebTestCase` de Symfony

### Fase 6: Quality Gate

Después de escribir todo el código, ejecutar:

1. `vendor/bin/php-cs-fixer fix` - Corregir estilo
2. `vendor/bin/phpstan analyse` - Verificar tipos
3. `vendor/bin/phpunit` - Pasar todos los tests

**NO se considera terminado si falla alguno de estos pasos.**

### Fase 7: Commit

Hacer commit siguiendo Conventional Commits:
- `feat(scope): description` para nueva funcionalidad
- `fix(scope): description` para correcciones
- El scope debe ser el dominio (ej: `user`, `order`, `product`)

---

## Estructura de directorios

```
src/
├── Controller/          # Solo orquestación HTTP
├── DTO/                 # Request/Response objects
│   ├── Request/         # Input DTOs con validación
│   └── Response/        # Output DTOs
├── Entity/              # Entidades Doctrine (dominio)
├── EventListener/       # Listeners de eventos
├── EventSubscriber/     # Subscribers de eventos
├── Exception/           # Excepciones de dominio
├── Repository/          # Acceso a datos
└── Service/             # Lógica de negocio

tests/
├── Unit/                # Tests unitarios (Services, Entities)
│   ├── Service/
│   └── Entity/
├── Integration/         # Tests de integración (Repositories)
│   └── Repository/
└── Functional/          # Tests funcionales (Controllers/API)
    └── Controller/
```

---

## Convenciones de código

### Nombrado
- **Entities**: Singular, PascalCase (`User`, `OrderItem`)
- **Repositories**: `{Entity}Repository` (`UserRepository`)
- **Services**: Describe la acción, sufijo `Service` (`UserRegistrationService`)
- **Controllers**: `{Resource}Controller` (`UserController`)
- **DTOs**: `{Action}{Resource}Request/Response` (`CreateUserRequest`)
- **Tests**: `{ClaseOriginal}Test` (`UserRegistrationServiceTest`)
- **Excepciones**: Descriptivas (`UserNotFoundException`, `InsufficientStockException`)

### Patrones obligatorios
- Siempre `declare(strict_types=1)` en cada archivo PHP
- Siempre type hints en parámetros y retorno
- Siempre readonly en DTOs
- Siempre constructor injection (no setter injection)
- Siempre final en clases que no se van a extender

### Patrones prohibidos
- NO poner lógica de negocio en Controllers
- NO poner lógica de negocio en Entities (excepto métodos de dominio puros)
- NO usar arrays asociativos cuando un DTO es más apropiado
- NO atrapar excepciones genéricas (catch \Exception)
- NO usar static methods para servicios
- NO acceder a superglobals ($_GET, $_POST, etc.)

---

## Plantillas de referencia

Las plantillas de código están en `.factory/templates/`. Usarlas como referencia
al crear nuevos archivos para mantener consistencia.

---

## Ejemplo de flujo completo

**Tarea**: "Crear un endpoint para registrar usuarios"

1. **Análisis**: Se necesita Entity User, UserRepository, CreateUserRequest DTO,
   UserResponse DTO, UserRegistrationService, UserController, y tests.

2. **Entity**: `src/Entity/User.php` con campos email, password, name, createdAt

3. **Repository**: `src/Repository/UserRepository.php` con findByEmail()

4. **DTO**: `src/DTO/Request/CreateUserRequest.php` (email, password, name con validación)
   + `src/DTO/Response/UserResponse.php`

5. **Service**: `src/Service/UserRegistrationService.php` con register(CreateUserRequest): User

6. **Controller**: `src/Controller/UserController.php` con POST /api/users

7. **Tests**:
   - `tests/Unit/Service/UserRegistrationServiceTest.php`
   - `tests/Functional/Controller/UserControllerTest.php`

8. **Quality Gate**: lint + analyse + test

9. **Commit**: `feat(user): add user registration endpoint`
