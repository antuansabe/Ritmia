# Instrucciones para Claude Code - Tareas Manuales

## Antes de Comenzar

Claude Code puede hacer casi todo el desarrollo, pero hay algunas tareas que requerirán tu intervención manual. Este documento lista exactamente qué necesitarás hacer tú.

---

## 1. Configuración Inicial del Proyecto

### Apple Developer Account
**Cuándo**: Antes de comenzar o durante Fase 0
**Qué hacer**:
1. Asegúrate de tener una cuenta de Apple Developer activa ($99/año)
2. Ten a mano tu Apple ID y contraseña
3. Verifica que tienes acceso a App Store Connect

### Xcode Setup
**Cuándo**: Fase 0
**Qué hacer**:
1. Abre el proyecto en Xcode cuando Claude Code lo cree
2. Ve a "Signing & Capabilities"
3. Selecciona tu Team (tu Apple Developer account)
4. Xcode generará automáticamente el provisioning profile

---

## 2. Configuración de CloudKit

**Cuándo**: Fase 1 (Core Data setup)
**Qué hacer**:
1. En Xcode, selecciona el proyecto
2. Ve a "Signing & Capabilities"
3. Click en "+ Capability"
4. Añade "iCloud"
5. Marca "CloudKit"
6. Xcode creará el container automáticamente

**Verificación**:
- Deberías ver "iCloud.com.ritmia.app" en la lista de containers

---

## 3. Sign in with Apple

**Cuándo**: Fase 4 (Authentication)
**Qué hacer**:
1. En "Signing & Capabilities"
2. Click en "+ Capability"
3. Añade "Sign in with Apple"
4. En App Store Connect:
   - Ve a tu app
   - App Information
   - Verifica que "Sign in with Apple" esté habilitado

---

## 4. Creación de Assets Visuales

**Cuándo**: Fase 7 (App Store Submission)
**Qué necesitas crear**:

### App Icon
- Tamaño: 1024x1024px
- Formato: PNG sin transparencia
- Diseño: Logo de Ritmia (puedes usar Canva o similar)
- Sin texto, bordes redondeados los añade iOS

### Screenshots
Claude Code no puede generar estos, necesitas:
1. Ejecutar la app en simulador
2. Tomar screenshots (Cmd+S)
3. Tamaños requeridos:
   - iPhone 6.7": 1290 × 2796 (iPhone 15 Pro Max)
   - iPhone 6.5": 1284 × 2778 (iPhone 11 Pro Max)
   - iPhone 5.5": 1242 × 2208 (iPhone 8 Plus)

### Herramientas recomendadas:
- **Para el icon**: Canva, Figma, o Sketch
- **Para screenshots**: [Screenshot Creator](https://screenshots.pro) o Figma

---

## 5. Configuración en App Store Connect

**Cuándo**: Fase 6-7
**Qué hacer**:

### Crear la App
1. Login en [App Store Connect](https://appstoreconnect.apple.com)
2. My Apps → "+"
3. Llena:
   - Platform: iOS
   - Name: Ritmia - Ritmo Fitness
   - Primary Language: Spanish (Mexico)
   - Bundle ID: com.ritmia.app (selecciónalo del dropdown)
   - SKU: ritmia-v1

### Información Básica
Copia y pega del documento que Claude Code generó:
- Descripción
- Keywords
- Support URL: https://ritmia.app/support (créala después)
- Privacy Policy URL: https://ritmia.app/privacy

---

## 6. TestFlight Setup

**Cuándo**: Fase 6
**Qué hacer**:
1. En App Store Connect → TestFlight
2. Sube el build (Xcode lo hace automático)
3. Añade información de testing:
   - What to Test (Claude Code lo genera)
   - Beta App Description
4. Añade testers:
   - Internos: tu email
   - Externos: invita 10-20 amigos/familia

---

## 7. Certificados y Provisioning

**Cuándo**: Si hay problemas de signing
**Qué hacer**:
1. En Xcode → Preferences → Accounts
2. Manage Certificates
3. Click "+" → Apple Distribution
4. Si hay errores, "Download Manual Profiles"

---

## 8. Tareas Post-Desarrollo

### Dominio Web (Opcional pero recomendado)
1. Registra ritmia.app o similar
2. Crea página simple con:
   - Link a App Store
   - Política de Privacidad
   - Términos de Servicio
   - Contacto/Soporte

### Monitoreo Post-Launch
1. Configurar notificaciones en App Store Connect
2. Responder reviews en primeras 48h
3. Monitorear crashes en Xcode Organizer

---

## 9. Scripts - Hacer Ejecutables

**Cuándo**: Cuando Claude Code cree los scripts
**Qué hacer**:
```bash
cd "/Users/Antonn/Desktop/Ritmia APP/Scripts"
chmod +x security_scan.sh
chmod +x export_privacy_report.sh
chmod +x final_stress.sh
```

---

## 10. Troubleshooting Común

### "No account for team"
- Solución: Selecciona tu team en Signing & Capabilities

### "Bundle identifier is not available"
- Solución: Cambia a com.tudominio.ritmia

### "Missing compliance"
- Solución: En App Store Connect, declara que no usas encriptación

### Build falla en TestFlight
- Verifica version y build number son únicos
- Incrementa build number y reintenta

---

## Checklist Final Pre-Launch

- [ ] Apple Developer account activa
- [ ] Dominio web registrado
- [ ] App icon creado (1024x1024)
- [ ] Screenshots tomados (3 tamaños)
- [ ] TestFlight con 10+ testers
- [ ] Política de privacidad online
- [ ] Términos de servicio online
- [ ] App Store listing completo
- [ ] Waiting for Review

---

## Estimación de Tiempo para Tareas Manuales

| Tarea | Tiempo Estimado |
|-------|----------------|
| Configurar Xcode signing | 5 min |
| Configurar capabilities | 10 min |
| Crear App Icon | 30 min |
| Tomar screenshots | 20 min |
| App Store Connect setup | 30 min |
| TestFlight setup | 15 min |
| **Total** | **~2 horas** |

---

**IMPORTANTE**: El 95% del trabajo lo hará Claude Code. Estas tareas manuales son necesarias por restricciones de Apple y acceso a cuentas. Mantén este documento a mano durante el desarrollo.