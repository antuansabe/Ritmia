#!/bin/bash

# security_scan.sh - Script de análisis de seguridad para Ritmia
# Este script busca potenciales problemas de seguridad en el código

echo "🔍 Iniciando análisis de seguridad para Ritmia..."
echo "================================================"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Contadores
ISSUES_FOUND=0

# Función para reportar issues
report_issue() {
    echo -e "${RED}❌ ISSUE:${NC} $1"
    ((ISSUES_FOUND++))
}

# Función para reportar warnings
report_warning() {
    echo -e "${YELLOW}⚠️  WARNING:${NC} $1"
}

# Función para reportar éxito
report_success() {
    echo -e "${GREEN}✅ OK:${NC} $1"
}

echo ""
echo "1️⃣  Buscando hardcoded secrets..."
echo "-----------------------------------"

# Buscar strings sospechosos
if grep -r "password\s*=\s*\"" --include="*.swift" . 2>/dev/null | grep -v "// TEST" | grep -v "Example"; then
    report_issue "Encontrado password hardcodeado"
else
    report_success "No se encontraron passwords hardcodeados"
fi

if grep -r "api[_-]?key\s*=\s*\"" --include="*.swift" . 2>/dev/null | grep -v "// TEST"; then
    report_issue "Encontrada API key hardcodeada"
else
    report_success "No se encontraron API keys hardcodeadas"
fi

if grep -r "secret\s*=\s*\"" --include="*.swift" . 2>/dev/null | grep -v "// TEST"; then
    report_issue "Encontrado secret hardcodeado"
else
    report_success "No se encontraron secrets hardcodeados"
fi

echo ""
echo "2️⃣  Verificando uso de HTTPS..."
echo "--------------------------------"

# Buscar URLs HTTP no seguras
if grep -r "http://" --include="*.swift" . 2>/dev/null | grep -v "localhost" | grep -v "127.0.0.1"; then
    report_issue "Encontradas URLs HTTP no seguras"
else
    report_success "Todas las URLs usan HTTPS"
fi

echo ""
echo "3️⃣  Verificando almacenamiento seguro..."
echo "-----------------------------------------"

# Verificar uso de UserDefaults para datos sensibles
if grep -r "UserDefaults.*password\|UserDefaults.*token\|UserDefaults.*secret" --include="*.swift" . 2>/dev/null; then
    report_warning "UserDefaults usado para datos potencialmente sensibles"
else
    report_success "UserDefaults no usado para datos sensibles"
fi

# Verificar uso de Keychain
if grep -r "KeychainManager\|SecItemAdd\|kSecClass" --include="*.swift" . 2>/dev/null > /dev/null; then
    report_success "Keychain está siendo utilizado"
else
    report_warning "No se detectó uso de Keychain"
fi

echo ""
echo "4️⃣  Verificando File Protection..."
echo "------------------------------------"

# Buscar configuración de File Protection
if grep -r "FileProtectionType\|protectionKey" --include="*.swift" . 2>/dev/null > /dev/null; then
    report_success "File Protection configurado"
else
    report_warning "No se detectó configuración de File Protection"
fi

echo ""
echo "5️⃣  Verificando configuración de ATS..."
echo "----------------------------------------"

# Verificar Info.plist para ATS
if [ -f "*/Info.plist" ] || [ -f "Info.plist" ]; then
    if grep -l "NSAllowsArbitraryLoads" */Info.plist 2>/dev/null || grep -l "NSAllowsArbitraryLoads" Info.plist 2>/dev/null; then
        report_warning "NSAllowsArbitraryLoads encontrado en Info.plist"
    else
        report_success "ATS configurado correctamente"
    fi
else
    report_warning "Info.plist no encontrado para verificar ATS"
fi

echo ""
echo "6️⃣  Verificando logs en producción..."
echo "--------------------------------------"

# Buscar prints que no deberían estar en producción
if grep -r "print(" --include="*.swift" . 2>/dev/null | grep -v "#if DEBUG" -B2 | grep "print("; then
    report_warning "Encontrados print() statements sin guard DEBUG"
else
    report_success "Logs correctamente protegidos con DEBUG flag"
fi

echo ""
echo "7️⃣  Verificando force unwrapping..."
echo "------------------------------------"

# Contar force unwraps
FORCE_UNWRAPS=$(grep -r "!" --include="*.swift" . 2>/dev/null | grep -v "!=" | grep -v "// swiftlint:disable" | wc -l)
if [ $FORCE_UNWRAPS -gt 50 ]; then
    report_warning "Alto número de force unwraps detectados: $FORCE_UNWRAPS"
else
    report_success "Número aceptable de force unwraps: $FORCE_UNWRAPS"
fi

echo ""
echo "8️⃣  Verificando SwiftShield..."
echo "-------------------------------"

# Verificar configuración de SwiftShield
if [ -f "swiftshield.yml" ]; then
    report_success "SwiftShield configurado"
    
    # Verificar que está configurado solo para Release
    if grep -q "release_only" swiftshield.yml; then
        report_success "SwiftShield configurado solo para Release"
    else
        report_warning "SwiftShield no está limitado a Release builds"
    fi
else
    report_warning "swiftshield.yml no encontrado"
fi

echo ""
echo "9️⃣  Verificando Privacy Manifest..."
echo "------------------------------------"

# Buscar PrivacyInfo.xcprivacy
if find . -name "PrivacyInfo.xcprivacy" 2>/dev/null | grep -q .; then
    report_success "Privacy Manifest encontrado"
else
    report_issue "Privacy Manifest no encontrado (requerido para iOS 17+)"
fi

echo ""
echo "🔟  Verificando Entitlements..."
echo "-------------------------------"

# Buscar archivo de entitlements
if find . -name "*.entitlements" 2>/dev/null | grep -q .; then
    report_success "Archivo de Entitlements encontrado"
    
    # Verificar CloudKit
    if grep -q "com.apple.developer.icloud-container-identifiers" *.entitlements 2>/dev/null; then
        report_success "CloudKit entitlement configurado"
    else
        report_warning "CloudKit entitlement no encontrado"
    fi
else
    report_issue "Archivo de Entitlements no encontrado"
fi

echo ""
echo "================================================"
echo "📊 RESUMEN DEL ANÁLISIS"
echo "================================================"

if [ $ISSUES_FOUND -eq 0 ]; then
    echo -e "${GREEN}✅ ¡Excelente! No se encontraron problemas críticos de seguridad.${NC}"
    exit 0
else
    echo -e "${RED}❌ Se encontraron $ISSUES_FOUND problemas que requieren atención.${NC}"
    echo ""
    echo "Recomendaciones:"
    echo "1. Revisa cada issue reportado arriba"
    echo "2. Nunca hardcodees credenciales en el código"
    echo "3. Usa Keychain para datos sensibles"
    echo "4. Asegúrate de que File Protection esté habilitado"
    echo "5. Configura SwiftShield para ofuscar el código en Release"
    exit 1
fi