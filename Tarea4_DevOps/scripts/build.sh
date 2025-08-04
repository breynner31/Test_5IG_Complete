#!/bin/bash

# Script de Build para CI/CD Pipeline
# Test 5IG - DevOps Task

set -e

echo "🏗️ Iniciando proceso de build..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para logging
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Verificar que estamos en el directorio correcto
if [ ! -d "Tarea3_Frontend" ]; then
    log_error "Directorio Tarea3_Frontend no encontrado"
    exit 1
fi

cd Tarea3_Frontend

# 1. Limpiar builds anteriores
log_step "Limpiando builds anteriores..."
if [ -d "build" ]; then
    rm -rf build
    log_info "Build anterior eliminado"
fi

# 2. Verificar dependencias
log_step "Verificando dependencias..."
if [ ! -f "package.json" ]; then
    log_error "package.json no encontrado"
    exit 1
fi

# 3. Instalar dependencias
log_step "Instalando dependencias..."
npm ci --production=false

# 4. Ejecutar build de producción
log_step "Ejecutando build de producción..."
export CI=false  # Evitar errores de warnings en CI
if npm run build; then
    log_info "Build de producción completado exitosamente"
else
    log_error "Build de producción falló"
    exit 1
fi

# 5. Verificar archivos básicos generados
log_step "Verificando archivos generados..."
if [ -f "build/index.html" ]; then
    log_info "✅ index.html encontrado"
else
    log_error "❌ index.html no encontrado"
    exit 1
fi

# 6. Verificar directorios básicos
if [ -d "build/static" ]; then
    log_info "✅ Directorio static encontrado"
else
    log_warn "⚠️ Directorio static no encontrado (puede ser normal)"
fi

# 7. Verificar tamaño del bundle
log_step "Verificando tamaño del build..."
BUNDLE_SIZE=$(du -sh build | cut -f1)
log_info "Tamaño total del build: $BUNDLE_SIZE"

# 8. Verificar que el HTML principal es válido
log_step "Verificando HTML principal..."
if grep -q "<!DOCTYPE html>" build/index.html; then
    log_info "HTML principal válido"
else
    log_error "HTML principal inválido"
    exit 1
fi

# 9. Crear archivo de metadatos del build
log_step "Creando metadatos del build..."
BUILD_INFO="build/build-info.json"
cat > "$BUILD_INFO" << EOF
{
  "buildDate": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "buildSize": "$BUNDLE_SIZE",
  "nodeVersion": "$(node --version)",
  "npmVersion": "$(npm --version)",
  "gitCommit": "$(git rev-parse HEAD 2>/dev/null || echo 'unknown')",
  "gitBranch": "$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')"
}
EOF

log_info "Metadatos del build guardados en $BUILD_INFO"

echo "✅ Build completado exitosamente!"
echo "📊 Resumen del build:"
echo "   - Tamaño: $BUNDLE_SIZE"
echo "   - Build válido: ✅"
echo "   - Listo para deploy: ✅"

exit 0 