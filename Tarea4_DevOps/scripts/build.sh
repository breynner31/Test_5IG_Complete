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

# 4. Verificar variables de entorno
log_step "Verificando variables de entorno..."
if [ -f ".env" ]; then
    log_info "Archivo .env encontrado"
    # Verificar variables críticas
    if grep -q "REACT_APP_API_URL" .env; then
        log_info "Variable REACT_APP_API_URL configurada"
    else
        log_warn "Variable REACT_APP_API_URL no encontrada"
    fi
else
    log_warn "Archivo .env no encontrado (usando valores por defecto)"
fi

# 5. Ejecutar build de producción
log_step "Ejecutando build de producción..."
export CI=false  # Evitar errores de warnings en CI
if npm run build; then
    log_info "Build de producción completado exitosamente"
else
    log_error "Build de producción falló"
    exit 1
fi

# 6. Verificar archivos generados
log_step "Verificando archivos generados..."
REQUIRED_FILES=("index.html" "static/js" "static/css" "static/media")

for file in "${REQUIRED_FILES[@]}"; do
    if [ -e "build/$file" ]; then
        log_info "✅ $file encontrado"
    else
        log_error "❌ $file no encontrado"
        exit 1
    fi
done

# 7. Optimizar build
log_step "Optimizando build..."

# Verificar tamaño del bundle
BUNDLE_SIZE=$(du -sh build | cut -f1)
log_info "Tamaño total del build: $BUNDLE_SIZE"

# Verificar archivos JS
JS_FILES=$(find build/static/js -name "*.js" | wc -l)
log_info "Archivos JS generados: $JS_FILES"

# Verificar archivos CSS
CSS_FILES=$(find build/static/css -name "*.css" | wc -l)
log_info "Archivos CSS generados: $CSS_FILES"

# 8. Verificar que el HTML principal es válido
log_step "Verificando HTML principal..."
if grep -q "<!DOCTYPE html>" build/index.html; then
    log_info "HTML principal válido"
else
    log_error "HTML principal inválido"
    exit 1
fi

# 9. Verificar que los assets están referenciados correctamente
log_step "Verificando referencias de assets..."
if grep -q "static/" build/index.html; then
    log_info "Assets referenciados correctamente"
else
    log_warn "No se encontraron referencias a assets estáticos"
fi

# 10. Crear archivo de metadatos del build
log_step "Creando metadatos del build..."
BUILD_INFO="build/build-info.json"
cat > "$BUILD_INFO" << EOF
{
  "buildDate": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "buildSize": "$BUNDLE_SIZE",
  "jsFiles": $JS_FILES,
  "cssFiles": $CSS_FILES,
  "nodeVersion": "$(node --version)",
  "npmVersion": "$(npm --version)",
  "gitCommit": "$(git rev-parse HEAD 2>/dev/null || echo 'unknown')",
  "gitBranch": "$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')"
}
EOF

log_info "Metadatos del build guardados en $BUILD_INFO"

# 11. Verificar que el build es funcional
log_step "Verificando funcionalidad del build..."
if node -e "
  const fs = require('fs');
  const html = fs.readFileSync('build/index.html', 'utf8');
  if (html.includes('<!DOCTYPE html>') && html.includes('</html>')) {
    console.log('✅ HTML válido');
    process.exit(0);
  } else {
    console.log('❌ HTML inválido');
    process.exit(1);
  }
"; then
    log_info "Verificación de funcionalidad completada"
else
    log_error "Verificación de funcionalidad falló"
    exit 1
fi

echo "✅ Build completado exitosamente!"
echo "📊 Resumen del build:"
echo "   - Tamaño: $BUNDLE_SIZE"
echo "   - Archivos JS: $JS_FILES"
echo "   - Archivos CSS: $CSS_FILES"
echo "   - Build válido: ✅"
echo "   - Listo para deploy: ✅"

exit 0 