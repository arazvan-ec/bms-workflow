---
paths:
  - "src/**/*.php"
---

# Arquitectura de capas

- **Entity** (`src/Entity/`): Solo dominio. Sin lógica de negocio. Getters/setters y métodos de dominio puros. Usar atributos ORM de PHP 8.
- **Repository** (`src/Repository/`): Solo queries a BD. Extiende `ServiceEntityRepository`. Nombres descriptivos (`findActiveByEmail`, no `find2`).
- **Service** (`src/Service/`): Lógica de negocio. Una responsabilidad por servicio. NUNCA acceder al Request HTTP. Lanzar excepciones de dominio específicas.
- **Controller** (`src/Controller/`): Solo orquestación HTTP. Patrón: deserializar → validar → delegar al service → retornar JsonResponse.
- **DTO** (`src/DTO/`): `readonly class`. Request DTOs con atributos `#[Assert\...]`. Response DTOs con método estático `fromEntity()`.
- **Exception** (`src/Exception/`): Excepciones de dominio descriptivas. Implementar `HttpExceptionInterface` para mapeo automático de HTTP status codes.

## Flujo de dependencias permitido

```
Controller → Service → Repository → Entity
Controller → DTO (Request/Response)
Service → DTO, Entity, Exception
```

## Flujo de dependencias prohibido

- Controller NO depende directamente de Repository o EntityManager
- Service NO depende de Request HTTP o Controller
- Entity NO depende de ninguna otra capa
