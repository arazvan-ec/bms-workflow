<?php
// =============================================================================
// Software Factory Template: Domain Exception
// =============================================================================
// Uso: Copiar y reemplazar {Name} por el nombre descriptivo de la excepción.
//      Usar para errores de dominio específicos, NUNCA lanzar \Exception genérica.
// =============================================================================

declare(strict_types=1);

namespace App\Exception;

use Symfony\Component\HttpKernel\Exception\HttpExceptionInterface;

final class {Name}Exception extends \RuntimeException implements HttpExceptionInterface
{
    // --- Ajustar el código HTTP según el caso ---
    // 404 para "not found", 409 para conflictos, 422 para validación de negocio
    private int $statusCode;

    public function __construct(
        string $message,
        int $statusCode = 404,
        ?\Throwable $previous = null,
    ) {
        $this->statusCode = $statusCode;
        parent::__construct($message, 0, $previous);
    }

    public function getStatusCode(): int
    {
        return $this->statusCode;
    }

    public function getHeaders(): array
    {
        return [];
    }

    // --- Factory methods para casos comunes ---
    // Ejemplo:
    //
    // public static function notFound(int $id): self
    // {
    //     return new self(
    //         sprintf('{Resource} with id %d not found', $id),
    //         404,
    //     );
    // }
    //
    // public static function alreadyExists(string $identifier): self
    // {
    //     return new self(
    //         sprintf('{Resource} with identifier "%s" already exists', $identifier),
    //         409,
    //     );
    // }
}
