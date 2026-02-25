<?php
// =============================================================================
// Software Factory Template: Entity
// =============================================================================
// Uso: Copiar y reemplazar {EntityName} por el nombre real de la entidad.
//      Añadir/modificar propiedades según necesidad.
// =============================================================================

declare(strict_types=1);

namespace App\Entity;

use App\Repository\{EntityName}Repository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: {EntityName}Repository::class)]
#[ORM\Table(name: '{table_name}')]
#[ORM\HasLifecycleCallbacks]
class {EntityName}
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    // --- Añadir propiedades aquí ---
    // Ejemplo:
    // #[ORM\Column(length: 255)]
    // private string $name;
    //
    // #[ORM\Column(type: Types::TEXT, nullable: true)]
    // private ?string $description = null;
    //
    // #[ORM\Column]
    // private bool $active = true;

    #[ORM\Column(type: Types::DATETIME_IMMUTABLE)]
    private \DateTimeImmutable $createdAt;

    #[ORM\Column(type: Types::DATETIME_IMMUTABLE, nullable: true)]
    private ?\DateTimeImmutable $updatedAt = null;

    public function __construct()
    {
        $this->createdAt = new \DateTimeImmutable();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    // --- Añadir getters/setters aquí ---

    public function getCreatedAt(): \DateTimeImmutable
    {
        return $this->createdAt;
    }

    public function getUpdatedAt(): ?\DateTimeImmutable
    {
        return $this->updatedAt;
    }

    #[ORM\PreUpdate]
    public function setUpdatedAtValue(): void
    {
        $this->updatedAt = new \DateTimeImmutable();
    }
}
