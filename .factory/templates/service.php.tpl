<?php
// =============================================================================
// Software Factory Template: Service
// =============================================================================
// Uso: Copiar y reemplazar {Name} por el nombre real del servicio.
//      Inyectar dependencias por constructor.
//      Implementar la lógica de negocio.
// =============================================================================

declare(strict_types=1);

namespace App\Service;

// use App\DTO\Request\{Action}{Resource}Request;
// use App\Entity\{Resource};
// use App\Exception\{Resource}NotFoundException;
// use App\Repository\{Resource}Repository;

final readonly class {Name}Service
{
    public function __construct(
        // --- Inyectar dependencias aquí ---
        // Ejemplo:
        //
        // private {Resource}Repository $repository,
        // private LoggerInterface $logger,
    ) {
    }

    // --- Implementar métodos de negocio aquí ---
    // Ejemplo:
    //
    // public function create({Action}{Resource}Request $request): {Resource}
    // {
    //     $entity = new {Resource}();
    //     // ... mapear propiedades desde el DTO
    //     $this->repository->save($entity, flush: true);
    //
    //     return $entity;
    // }
    //
    // public function findOrFail(int $id): {Resource}
    // {
    //     $entity = $this->repository->find($id);
    //
    //     if ($entity === null) {
    //         throw new {Resource}NotFoundException($id);
    //     }
    //
    //     return $entity;
    // }
}
