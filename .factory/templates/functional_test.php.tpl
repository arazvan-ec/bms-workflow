<?php
// =============================================================================
// Software Factory Template: Functional Test (Controller/API)
// =============================================================================
// Uso: Copiar y reemplazar {Resource} y {resource_plural} por los nombres reales.
//      Testear endpoints HTTP completos.
//      Verificar códigos de respuesta y estructura JSON.
// =============================================================================

declare(strict_types=1);

namespace App\Tests\Functional\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use Symfony\Component\HttpFoundation\Response;

final class {Resource}ControllerTest extends WebTestCase
{
    // --- Test: listar recursos ---
    // public function testListReturnsOk(): void
    // {
    //     $client = static::createClient();
    //
    //     $client->request('GET', '/api/{resource_plural}');
    //
    //     $this->assertResponseIsSuccessful();
    //     $this->assertResponseHeaderSame('content-type', 'application/json');
    //
    //     $data = json_decode(
    //         $client->getResponse()->getContent(),
    //         true,
    //         512,
    //         JSON_THROW_ON_ERROR,
    //     );
    //     $this->assertIsArray($data);
    // }

    // --- Test: crear recurso ---
    // public function testCreateReturnsCreated(): void
    // {
    //     $client = static::createClient();
    //
    //     $client->request(
    //         'POST',
    //         '/api/{resource_plural}',
    //         [],
    //         [],
    //         ['CONTENT_TYPE' => 'application/json'],
    //         json_encode([
    //             // ... datos del recurso
    //         ], JSON_THROW_ON_ERROR),
    //     );
    //
    //     $this->assertResponseStatusCodeSame(Response::HTTP_CREATED);
    //
    //     $data = json_decode(
    //         $client->getResponse()->getContent(),
    //         true,
    //         512,
    //         JSON_THROW_ON_ERROR,
    //     );
    //     // $this->assertArrayHasKey('id', $data);
    // }

    // --- Test: crear recurso con datos inválidos ---
    // public function testCreateWithInvalidDataReturnsError(): void
    // {
    //     $client = static::createClient();
    //
    //     $client->request(
    //         'POST',
    //         '/api/{resource_plural}',
    //         [],
    //         [],
    //         ['CONTENT_TYPE' => 'application/json'],
    //         json_encode([], JSON_THROW_ON_ERROR),
    //     );
    //
    //     $this->assertResponseStatusCodeSame(Response::HTTP_UNPROCESSABLE_ENTITY);
    // }

    // --- Test: recurso no encontrado ---
    // public function testShowNotFoundReturns404(): void
    // {
    //     $client = static::createClient();
    //
    //     $client->request('GET', '/api/{resource_plural}/99999');
    //
    //     $this->assertResponseStatusCodeSame(Response::HTTP_NOT_FOUND);
    // }
}
