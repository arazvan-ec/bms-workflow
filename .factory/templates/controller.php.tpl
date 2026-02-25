<?php
// =============================================================================
// Software Factory Template: Controller
// =============================================================================
// Uso: Copiar y reemplazar {Resource} por el nombre real del recurso.
//      El controller SOLO orquesta: deserializa, valida, delega, responde.
//      NUNCA poner lógica de negocio aquí.
// =============================================================================

declare(strict_types=1);

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Serializer\SerializerInterface;
use Symfony\Component\Validator\Validator\ValidatorInterface;
// use App\DTO\Request\Create{Resource}Request;
// use App\DTO\Response\{Resource}Response;
// use App\Service\{Resource}Service;

#[Route('/api/{resource_plural}')]
final class {Resource}Controller extends AbstractController
{
    public function __construct(
        // private {Resource}Service $service,
        private SerializerInterface $serializer,
        private ValidatorInterface $validator,
    ) {
    }

    // #[Route('', methods: ['GET'])]
    // public function list(): JsonResponse
    // {
    //     $entities = $this->service->findAll();
    //     $response = {Resource}Response::fromEntities($entities);
    //
    //     return $this->json($response);
    // }

    // #[Route('/{id}', methods: ['GET'])]
    // public function show(int $id): JsonResponse
    // {
    //     $entity = $this->service->findOrFail($id);
    //     $response = {Resource}Response::fromEntity($entity);
    //
    //     return $this->json($response);
    // }

    // #[Route('', methods: ['POST'])]
    // public function create(Request $request): JsonResponse
    // {
    //     // 1. Deserializar
    //     $dto = $this->serializer->deserialize(
    //         $request->getContent(),
    //         Create{Resource}Request::class,
    //         'json',
    //     );
    //
    //     // 2. Validar
    //     $errors = $this->validator->validate($dto);
    //     if (count($errors) > 0) {
    //         return $this->json(
    //             ['errors' => (string) $errors],
    //             Response::HTTP_UNPROCESSABLE_ENTITY,
    //         );
    //     }
    //
    //     // 3. Delegar al servicio
    //     $entity = $this->service->create($dto);
    //
    //     // 4. Responder
    //     return $this->json(
    //         {Resource}Response::fromEntity($entity),
    //         Response::HTTP_CREATED,
    //     );
    // }

    // #[Route('/{id}', methods: ['DELETE'])]
    // public function delete(int $id): JsonResponse
    // {
    //     $this->service->delete($id);
    //
    //     return $this->json(null, Response::HTTP_NO_CONTENT);
    // }
}
