# Ritmia - Ritmo Fitness

<img src="Resources/app-icon.png" alt="Ritmia Logo" width="120" height="120">

## 📱 Acerca de Ritmia

Ritmia es una aplicación iOS de fitness diseñada para ayudarte a mantener el ritmo en tu vida fitness. Con un enfoque en la simplicidad y la motivación, Ritmia te permite registrar tus entrenamientos, visualizar tu progreso semanal y mantener tu racha de días activos.

## ✨ Características

- 🏃 **Registro de Entrenamientos**: 8 tipos diferentes de actividades
- 📊 **Visualización Semanal**: Ve tu progreso de lunes a domingo
- 🔥 **Sistema de Rachas**: Mantén tu motivación con rachas semanales
- ☁️ **Sincronización con iCloud**: Tus datos siempre seguros y sincronizados
- 🔐 **Sign in with Apple**: Autenticación segura y privada
- 📸 **Compartir en Instagram**: Presume tus logros en Stories

## 🛠 Stack Técnico

- **UI Framework**: SwiftUI
- **Persistencia**: Core Data + CloudKit
- **Arquitectura**: MVVM
- **Mínimo iOS**: 16.0
- **Lenguajes**: Swift 5.9+

## 🚀 Configuración del Proyecto

### Prerrequisitos

- Xcode 15.0+
- macOS Ventura 13.0+
- Cuenta de desarrollador de Apple (para ciertas funcionalidades)

### Instalación

1. Clona el repositorio:
   ```bash
   git clone https://github.com/antuansabe/Ritmia.git
   cd "Ritmia APP"
   ```

2. Abre el proyecto en Xcode:
   ```bash
   open Ritmia/Ritmia.xcodeproj
   ```

3. Selecciona tu Development Team en Signing & Capabilities

4. Build and Run (⌘R)

## 📁 Estructura del Proyecto

```
Ritmia/
├── App/                    # Entry point y configuración
├── Core/                   # Lógica de negocio y datos
│   ├── Data/              # Core Data y repositorios
│   ├── Domain/            # Modelos y casos de uso
│   └── Extensions/        # Extensiones de Swift
├── Features/              # Módulos de funcionalidad
│   ├── Auth/             # Autenticación
│   ├── Home/             # Pantalla principal
│   ├── Record/           # Registro de entrenamientos
│   ├── History/          # Historial
│   └── Profile/          # Perfil y ajustes
├── Shared/               # Componentes compartidos
│   ├── UI/              # Componentes de UI
│   ├── Utils/           # Utilidades
│   └── Services/        # Servicios
└── Resources/           # Assets e Info.plist
```

## 🧪 Testing

Ejecutar todos los tests:
```bash
xcodebuild test -scheme Ritmia -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 📋 Estándares de Código

- Usamos SwiftLint para mantener consistencia
- Conventional Commits para mensajes
- 90%+ cobertura de tests en lógica core

## 🤝 Contribuir

1. Fork el proyecto
2. Crea tu feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'feat: add amazing feature'`)
4. Push al branch (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto es privado y propietario. Todos los derechos reservados.

## 📧 Contacto

Antonio Fernandez - antuansabe@gmail.com

---

Hecho con ❤️ y ☕ en México