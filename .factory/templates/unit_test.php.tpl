<?php
// =============================================================================
// Software Factory Template: Unit Test (Service)
// =============================================================================
// Uso: Copiar y reemplazar {Name} por el nombre del servicio a testear.
//      Mockear TODAS las dependencias externas.
//      Un método de test por caso de uso.
// =============================================================================

declare(strict_types=1);

namespace App\Tests\Unit\Service;

// use App\Entity\{Resource};
// use App\Repository\{Resource}Repository;
// use App\Service\{Name}Service;
use PHPUnit\Framework\MockObject\MockObject;
use PHPUnit\Framework\TestCase;

final class {Name}ServiceTest extends TestCase
{
    // --- Declarar mocks y SUT (System Under Test) ---
    // private {Resource}Repository&MockObject $repository;
    // private {Name}Service $service;

    protected function setUp(): void
    {
        // --- Crear mocks e instanciar el servicio ---
        // $this->repository = $this->createMock({Resource}Repository::class);
        // $this->service = new {Name}Service($this->repository);
    }

    // --- Test: caso exitoso ---
    // public function testCreateReturnsEntity(): void
    // {
    //     // Arrange
    //     $request = new Create{Resource}Request(
    //         // ... parámetros del DTO
    //     );
    //
    //     $this->repository
    //         ->expects($this->once())
    //         ->method('save');
    //
    //     // Act
    //     $result = $this->service->create($request);
    //
    //     // Assert
    //     $this->assertInstanceOf({Resource}::class, $result);
    // }

    // --- Test: caso de error ---
    // public function testFindOrFailThrowsWhenNotFound(): void
    // {
    //     // Arrange
    //     $this->repository
    //         ->method('find')
    //         ->willReturn(null);
    //
    //     // Assert
    //     $this->expectException({Resource}NotFoundException::class);
    //
    //     // Act
    //     $this->service->findOrFail(999);
    // }
}
