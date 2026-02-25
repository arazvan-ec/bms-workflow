# BMS Microservice - Software Factory

Template base para microservicios PHP/Symfony siguiendo la filosofía **Software Factory**: procesos de desarrollo automatizados, repetibles y estandarizados.

## Requisitos

- Docker y Docker Compose
- Make (opcional, para usar los atajos del Makefile)

## Inicio rápido

```bash
# 1. Levantar el entorno de desarrollo
make up

# 2. Instalar dependencias
make install

# 3. Verificar que todo funciona
make quality
```

La aplicación estará disponible en `http://localhost:8080`.

## Comandos disponibles

Ejecuta `make help` para ver todos los comandos. Los principales son:

| Comando             | Descripción                                      |
|---------------------|--------------------------------------------------|
| `make install`      | Instalar dependencias con Composer               |
| `make lint`         | Corregir estilo de código automáticamente         |
| `make lint-check`   | Verificar estilo de código (sin corregir)         |
| `make analyse`      | Ejecutar análisis estático (PHPStan nivel 6)      |
| `make test`         | Ejecutar tests unitarios (PHPUnit)                |
| `make quality`      | Ejecutar lint-check + analyse + test              |
| `make up`           | Levantar contenedores Docker                      |
| `make down`         | Detener contenedores Docker                       |
| `make shell`        | Abrir shell en el contenedor PHP                  |

## Estándares de desarrollo

### Estilo de código

Se usa **PHP-CS-Fixer** con reglas PSR-12 + Symfony. La configuración está en `.php-cs-fixer.dist.php`.

Reglas principales:
- PSR-12 estricto
- `declare(strict_types=1)` obligatorio
- Imports ordenados alfabéticamente
- Sin imports no utilizados
- Trailing comma en arrays y parámetros multilinea

### Análisis estático

**PHPStan** nivel 6 con extensión para Symfony. Configuración en `phpstan.neon`.

### Pre-commit hooks

**GrumPHP** se activa automáticamente tras `composer install`. Antes de cada commit verifica:

1. **Estilo de código** - PHP-CS-Fixer en modo dry-run
2. **Análisis estático** - PHPStan
3. **Tests** - PHPUnit (solo si hay archivos PHP modificados)
4. **Mensaje de commit** - Debe seguir el formato Conventional Commits

### Convención de commits

Formato: `<tipo>(<ámbito>): <descripción>`

Tipos válidos:
- `feat` - Nueva funcionalidad
- `fix` - Corrección de bug
- `docs` - Documentación
- `style` - Formateo (sin cambios de lógica)
- `refactor` - Refactorización
- `test` - Tests
- `chore` - Mantenimiento
- `ci` - CI/CD
- `perf` - Rendimiento
- `build` - Build system
- `revert` - Revert de commit anterior

Ejemplos:
```
feat(user): add user registration endpoint
fix(auth): resolve token expiration issue
docs: update README with setup instructions
ci: add PHPStan job to pipeline
```

## Pipeline CI/CD (GitLab CI)

El archivo `.gitlab-ci.yml` define las siguientes etapas:

```
quality  →  test  →  build  →  deploy
```

| Stage     | Job                | Descripción                              | Trigger                 |
|-----------|--------------------|------------------------------------------|-------------------------|
| quality   | `php-cs-fixer`     | Verifica estilo de código                | MR + rama principal     |
| quality   | `phpstan`          | Análisis estático                        | MR + rama principal     |
| test      | `phpunit`          | Tests unitarios + cobertura              | MR + rama principal     |
| build     | `build-image`      | Build de imagen Docker                   | Solo rama principal     |
| deploy    | `deploy-staging`   | Deploy a staging (manual)                | Solo rama principal     |
| deploy    | `deploy-production`| Deploy a producción (manual, tras staging)| Solo rama principal    |

## Estructura del proyecto

```
├── bin/
│   └── console              # CLI de Symfony
├── config/
│   ├── bundles.php           # Bundles registrados
│   ├── packages/             # Configuración de paquetes
│   └── services.yaml         # Definición de servicios
├── docker/
│   ├── nginx/
│   │   └── default.conf      # Configuración de Nginx
│   └── php/
│       └── php.ini           # Configuración de PHP
├── public/
│   └── index.php             # Entry point
├── src/
│   └── Kernel.php            # Kernel de Symfony
├── tests/
│   └── bootstrap.php         # Bootstrap de PHPUnit
├── .env                      # Variables de entorno
├── .gitlab-ci.yml            # Pipeline de CI/CD
├── .php-cs-fixer.dist.php    # Configuración PHP-CS-Fixer
├── composer.json              # Dependencias
├── docker-compose.yml         # Docker Compose
├── Dockerfile                 # Imagen Docker (multi-stage)
├── grumphp.yml               # Pre-commit hooks
├── Makefile                   # Comandos de desarrollo
├── phpstan.neon               # Configuración PHPStan
└── phpunit.xml.dist           # Configuración PHPUnit
```

## Cómo replicar para un nuevo microservicio

La filosofía **Software Factory** permite replicar este template para cada nuevo microservicio:

1. Copiar este repositorio como base
2. Actualizar `name` en `composer.json`
3. Configurar variables de entorno en `.env`
4. Desarrollar la lógica de negocio en `src/`
5. Los estándares y el pipeline se aplican automáticamente
