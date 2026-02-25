<?php
// =============================================================================
// Software Factory Template: Repository
// =============================================================================
// Uso: Copiar y reemplazar {EntityName} por el nombre real de la entidad.
//      Añadir métodos de consulta personalizados.
// =============================================================================

declare(strict_types=1);

namespace App\Repository;

use App\Entity\{EntityName};
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<{EntityName}>
 */
final class {EntityName}Repository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, {EntityName}::class);
    }

    public function save({EntityName} $entity, bool $flush = false): void
    {
        $this->getEntityManager()->persist($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    public function remove({EntityName} $entity, bool $flush = false): void
    {
        $this->getEntityManager()->remove($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    // --- Añadir métodos de consulta personalizados aquí ---
    // Ejemplo:
    //
    // /**
    //  * @return {EntityName}[]
    //  */
    // public function findAllActive(): array
    // {
    //     return $this->createQueryBuilder('e')
    //         ->andWhere('e.active = :active')
    //         ->setParameter('active', true)
    //         ->orderBy('e.createdAt', 'DESC')
    //         ->getQuery()
    //         ->getResult();
    // }
}
