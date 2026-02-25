<?php
// =============================================================================
// Software Factory Template: Response DTO
// =============================================================================
// Uso: Copiar y reemplazar {Resource} por el nombre real del recurso.
//      Añadir propiedades que se expondrán en la respuesta.
// =============================================================================

declare(strict_types=1);

namespace App\DTO\Response;

use App\Entity\{Resource};

final readonly class {Resource}Response
{
    public function __construct(
        // --- Añadir propiedades de respuesta aquí ---
        // Ejemplo:
        //
        // public int $id,
        // public string $email,
        // public string $name,
        // public string $createdAt,
    ) {
    }

    public static function fromEntity({Resource} $entity): self
    {
        return new self(
            // --- Mapear desde la entidad ---
            // Ejemplo:
            //
            // id: $entity->getId(),
            // email: $entity->getEmail(),
            // name: $entity->getName(),
            // createdAt: $entity->getCreatedAt()->format(\DateTimeInterface::ATOM),
        );
    }

    /**
     * @param {Resource}[] $entities
     *
     * @return self[]
     */
    public static function fromEntities(array $entities): array
    {
        return array_map(
            static fn ({Resource} $entity): self => self::fromEntity($entity),
            $entities,
        );
    }
}
