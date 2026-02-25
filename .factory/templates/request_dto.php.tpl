<?php
// =============================================================================
// Software Factory Template: Request DTO
// =============================================================================
// Uso: Copiar y reemplazar {Action}, {Resource} por los nombres reales.
//      Añadir/modificar propiedades con sus validaciones.
// =============================================================================

declare(strict_types=1);

namespace App\DTO\Request;

use Symfony\Component\Validator\Constraints as Assert;

final readonly class {Action}{Resource}Request
{
    public function __construct(
        // --- Añadir propiedades con validación aquí ---
        // Ejemplo:
        //
        // #[Assert\NotBlank(message: 'El email es obligatorio')]
        // #[Assert\Email(message: 'El email no es válido')]
        // public string $email,
        //
        // #[Assert\NotBlank(message: 'El nombre es obligatorio')]
        // #[Assert\Length(min: 2, max: 100)]
        // public string $name,
        //
        // #[Assert\NotBlank]
        // #[Assert\Length(min: 8, message: 'La contraseña debe tener al menos 8 caracteres')]
        // public string $password,
        //
        // #[Assert\Type('bool')]
        // public bool $active = true,
    ) {
    }
}
