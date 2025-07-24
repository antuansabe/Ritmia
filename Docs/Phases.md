# Ritmia - Plan de Fases de Desarrollo

## Resumen Ejecutivo de Fases

| Fase | Nombre | Duración | Objetivo Principal |
|------|--------|----------|-------------------|
| F0 | Bootstrap | 2 horas | Crear estructura base del proyecto |
| F1 | Core Data + WeekEngine | 8 horas | Implementar modelo de datos y lógica de negocio |
| F2 | Seguridad & Legal | 6 horas | Implementar seguridad y compliance |
| F3 | UI MVP | 12 horas | Crear todas las pantallas principales |
| F4 | Auth + Onboarding | 8 horas | Flujo completo de autenticación |
| F5 | QA Final | 6 horas | Testing exhaustivo y optimización |
| F6 | RC & TestFlight | 4 horas | Preparar release candidate |
| F7 | App Store | 2 horas | Submission final |

**Total estimado: 48 horas de desarrollo**

---

## FASE 0: Bootstrap del Proyecto

### Objetivos
- Crear proyecto Xcode limpio con configuración correcta
- Establecer estructura de carpetas profesional
- Configurar herramientas de calidad de código
- Preparar entorno de desarrollo

### Tareas Detalladas

#### 0.1 Crear Proyecto Xcode
```bash
# Configuración del proyecto
- Product Name: Ritmia
- Team: (Configurar después)
- Organization Identifier: com.ritmia
- Bundle Identifier: com.ritmia.app
- Language: Swift
- User Interface: SwiftUI
- Use Core Data: ✓
- Include Tests: ✓
```

#### 0.2 Estructura de Carpetas
```
Ritmia/
├── App/
│   ├── RitmiaApp.swift
│   ├── AppDelegate.swift
│   ├── Configuration/
│   └── Resources/
├── Core/
│   ├── Data/
│   ├── Domain/
│   └── Extensions/
├── Features/
│   ├── Auth/
│   ├── Home/
│   ├── Record/
│   ├── History/
│   └── Profile/
├── Shared/
│   ├── UI/
│   ├── Utils/
│   └── Services/
├── Resources/
│   ├── Assets.xcassets
│   ├── Localizable.strings
│   └── Info.plist
└── SupportingFiles/
    ├── Ritmia.entitlements
    └── PrivacyInfo.xcprivacy
```

#### 0.3 Configurar SwiftLint
```yaml
# .swiftlint.yml
included:
  - Ritmia
excluded:
  - Ritmia/Resources
  - ${PWD}/swiftshield-output

rules:
  - force_cast
  - force_unwrapping
  - implicitly_unwrapped_optional
  - large_tuple
  - line_length
  - file_length
  - type_body_length
  - function_body_length
  - cyclomatic_complexity

line_length:
  warning: 120
  error: 150

file_length:
  warning: 400
  error: 600

type_body_length:
  warning: 300
  error: 500

function_body_length:
  warning: 50
  error: 100
```

#### 0.4 Configurar Git
```bash
# .gitignore
# Xcode
*.xcuserstate
xcuserdata/
*.xcscmblueprint
*.xccheckout

# Swift Package Manager
.build/
.swiftpm/

# CocoaPods
Pods/
*.xcworkspace

# Secrets
Config.plist
*.p12
*.cer
*.mobileprovision

# Build
build/
DerivedData/
*.ipa
*.dSYM.zip
*.dSYM

# SwiftShield
swiftshield-output/
```

### Criterios de Aceptación
- [ ] Proyecto compila sin errores
- [ ] SwiftLint ejecuta sin warnings
- [ ] Estructura de carpetas creada
- [ ] Git inicializado con .gitignore correcto
- [ ] README.md básico creado

### Entregables
- Proyecto Xcode configurado
- Estructura de carpetas completa
- Herramientas de linting activas
- Documentación inicial

### Commit
```bash
git commit -m "chore(project): bootstrap clean iOS project with SwiftUI & Core Data

- Created Xcode project with proper configuration
- Set up folder structure following clean architecture
- Added SwiftLint configuration
- Configured git with comprehensive .gitignore
- Added basic README"
```

---

## FASE 1: Core Data + WeekEngine

### Objetivos
- Implementar stack de Core Data con CloudKit
- Crear todas las entidades del modelo
- Implementar lógica de cálculo semanal
- Crear repositorios y tests

### Tareas Detalladas

#### 1.1 Core Data Stack
```swift
// PersistenceController.swift
import CoreData
import CloudKit

class PersistenceController {
    static let shared = PersistenceController()
    
    lazy var container: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Ritmia")
        
        // CloudKit configuration
        let storeURL = FileManager.default.urls(for: .documentDirectory, 
                                               in: .userDomainMask).first!
            .appendingPathComponent("Ritmia.sqlite")
        
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        storeDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
            containerIdentifier: "iCloud.com.ritmia.app"
        )
        
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    // Preview container for SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        // Add sample data
        return controller
    }()
}
```

#### 1.2 Entidades Core Data
- WorkoutEntity (con todos los campos especificados)
- UserProfileEntity
- AppSettingsEntity
- Configurar relaciones e índices

#### 1.3 WeekEngine Implementation
```swift
// WeekEngine.swift
final class WeekEngine {
    private let calendar = Calendar.current
    private let timeZone: TimeZone
    
    func currentWeekBounds() -> (start: Date, end: Date)
    func calculateStreak(from workouts: [Workout]) -> Int
    func workoutsForCurrentWeek(_ workouts: [Workout]) -> [Workout]
    func groupWorkoutsByDay(_ workouts: [Workout]) -> [Date: [Workout]]
    func shouldResetStreak(lastReset: Date) -> Bool
}
```

#### 1.4 Repositorios
```swift
// WorkoutRepository.swift
protocol WorkoutRepositoryProtocol {
    func save(_ workout: Workout) async throws
    func fetchAll() async throws -> [Workout]
    func fetchWeek(start: Date, end: Date) async throws -> [Workout]
    func delete(_ workout: Workout) async throws
    func update(_ workout: Workout) async throws
}
```

#### 1.5 Unit Tests
- Test week bounds calculation
- Test streak calculation with edge cases
- Test CRUD operations
- Test CloudKit sync simulation

### Criterios de Aceptación
- [ ] Core Data stack funciona sin crashes
- [ ] Todas las entidades creadas con campos correctos
- [ ] WeekEngine calcula correctamente lunes-domingo
- [ ] Repositorios implementados con async/await
- [ ] 90% cobertura en tests de lógica core
- [ ] No warnings de SwiftLint

### Entregables
- Core Data model file (.xcdatamodeld)
- PersistenceController implementation
- WeekEngine con tests
- Repositorios implementados
- Suite de unit tests

### Commit
```bash
git commit -m "feat(coredata): models + week engine + tests

- Implemented NSPersistentCloudKitContainer with proper configuration
- Created WorkoutEntity, UserProfileEntity, AppSettingsEntity
- Implemented WeekEngine with Monday-Sunday week calculation
- Added repositories with async/await pattern
- Comprehensive unit test coverage (90%+)"
```

---

## FASE 2: Seguridad & Legal

### Objetivos
- Implementar almacenamiento seguro con Keychain
- Configurar protección de archivos
- Añadir documentos legales
- Crear Privacy Manifest
- Preparar scripts de seguridad

### Tareas Detalladas

#### 2.1 Keychain Implementation
```swift
// KeychainManager.swift
final class KeychainManager {
    enum KeychainError: Error {
        case duplicateItem
        case itemNotFound
        case unexpectedData
        case unhandledError(status: OSStatus)
    }
    
    func save(_ data: Data, for key: String) throws
    func load(key: String) throws -> Data
    func delete(key: String) throws
    func updateData(_ data: Data, for key: String) throws
}
```

#### 2.2 Secure Storage Wrapper
```swift
// SecureStorage.swift
@propertyWrapper
struct SecurelyStored {
    private let key: String
    private let keychain = KeychainManager()
    
    var wrappedValue: String? {
        get { 
            // Retrieve from keychain
        }
        set { 
            // Store in keychain
        }
    }
}
```

#### 2.3 File Protection
```swift
// FileProtectionManager.swift
extension FileManager {
    func applyProtection(to url: URL) throws {
        try setAttributes([
            .protectionKey: FileProtectionType.completeUnlessOpen
        ], ofItemAtPath: url.path)
    }
}
```

#### 2.4 Privacy Manifest
- Crear PrivacyInfo.xcprivacy
- Declarar uso de UserDefaults
- Declarar recolección de datos fitness
- No tracking, no ads

#### 2.5 Legal Documents
- Embed PrivacyPolicy.md
- Embed TermsOfService.md
- Crear LegalView para mostrarlos
- Asegurar que son accesibles offline

#### 2.6 Security Scripts
- security_scan.sh: Buscar strings hardcodeados
- privacy_report.sh: Generar reporte de APIs usadas
- final_stress.sh: Tests de penetración básicos

### Criterios de Aceptación
- [ ] Keychain funciona para guardar/recuperar datos
- [ ] File protection aplicado a Core Data
- [ ] Privacy manifest válido
- [ ] Documentos legales embebidos y visibles
- [ ] Scripts de seguridad ejecutables
- [ ] No secrets en el código

### Entregables
- KeychainManager + SecureStorage
- PrivacyInfo.xcprivacy configurado
- Legal documents bundle
- Security scripts funcionales
- Tests de seguridad

### Commit
```bash
git commit -m "feat(security+legal): keychain, privacy manifest, legal docs & tests

- Implemented KeychainManager with proper error handling
- Added SecureStorage property wrapper
- Created PrivacyInfo.xcprivacy with required declarations
- Embedded legal documents (Privacy Policy & Terms)
- Added security validation scripts
- File protection enabled for sensitive data"
```

---

## FASE 3: UI MVP

### Objetivos
- Implementar todas las pantallas principales
- Crear componentes reutilizables
- Implementar navegación con TabView
- Añadir view models con lógica
- Asegurar responsive design

### Tareas Detalladas

#### 3.1 Componentes Base
```swift
// Theme/Colors.swift
extension Color {
    static let ritmiaBlue = Color("RitmiaBlue")
    static let ritmiaGreen = Color("RitmiaGreen")
    // etc...
}

// Components/Cards/MetricCard.swift
struct MetricCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
}
```

#### 3.2 Home Screen
- Header con saludo dinámico
- 3 metric cards (workouts, minutes, calories)
- Streak visualization
- Weekly goal progress
- CTA for recording workout

#### 3.3 Record Workout Screen
- Workout type selector (horizontal scroll)
- Duration picker
- Calories input (auto/manual toggle)
- Notes field
- Save with validation
- Success feedback

#### 3.4 History Screen
- Weekly calendar header
- Grouped list by days
- Workout detail rows
- Filter options
- Empty state
- Pull to refresh

#### 3.5 Profile Screen
- User info section
- Settings sections
- Legal links
- Account actions
- Version info (debug only)

#### 3.6 Tab Navigation
```swift
struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Inicio", systemImage: "house.fill")
                }
                .tag(0)
            
            RecordView()
                .tabItem {
                    Label("Registrar", systemImage: "plus.circle.fill")
                }
                .tag(1)
            
            HistoryView()
                .tabItem {
                    Label("Historial", systemImage: "clock.fill")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person.fill")
                }
                .tag(3)
        }
    }
}
```

### Criterios de Aceptación
- [ ] Todas las pantallas principales implementadas
- [ ] Navegación fluida entre tabs
- [ ] View models conectados a repositories
- [ ] Empty states correctos (no placeholders)
- [ ] Componentes reutilizables extraídos
- [ ] Responsive en todos los tamaños de iPhone
- [ ] Modo claro/oscuro funcionando

### Entregables
- 4 pantallas principales completas
- Sistema de navegación
- Componentes UI reutilizables
- View models con lógica
- Theme system implementado

### Commit
```bash
git commit -m "feat(ui): main flows + view models + empty states fixed

- Implemented Home, Record, History, and Profile screens
- Created reusable component library
- Added TabView navigation
- Connected ViewModels to repositories
- Fixed all empty states (no placeholders)
- Dark mode support"
```

---

## FASE 4: Apple Sign-In + Onboarding

### Objetivos
- Implementar Sign in with Apple completo
- Crear flujo de onboarding post-login
- Implementar pantalla de bienvenida personalizada
- Gestionar estado de autenticación
- Tests del flujo completo

### Tareas Detalladas

#### 4.1 Apple Sign In Implementation
```swift
// AppleSignInManager.swift
import AuthenticationServices

class AppleSignInManager: NSObject {
    func signIn() async throws -> AppleUser
    func handleAuthorization(_ authorization: ASAuthorization) throws -> AppleUser
    private func saveToKeychain(_ user: AppleUser) throws
}
```

#### 4.2 Auth State Management
```swift
// AuthViewModel.swift
@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var showOnboarding = false
    
    func checkAuthStatus() async
    func signIn() async throws
    func signOut() async throws
}
```

#### 4.3 Onboarding Flow
- Screen 1: Welcome to Ritmia
- Screen 2: Key features
- Screen 3: Set weekly goal
- Screen 4: Notifications opt-in
- Screen 5: Ready to start

#### 4.4 Welcome Screen
```swift
struct WelcomeView: View {
    let userName: String
    
    var body: some View {
        VStack {
            Text("¡Hola, \(userName)!")
                .font(.largeTitle)
            
            Text("¡Bienvenido a Ritmia!")
                .font(.title2)
            
            // Animated celebration
            LottieView("celebration")
            
            Button("Comenzar") {
                // Navigate to main app
            }
        }
    }
}
```

#### 4.5 Root Navigation
```swift
struct RootView: View {
    @StateObject private var authVM = AuthViewModel()
    
    var body: some View {
        Group {
            if authVM.isAuthenticated {
                if authVM.showOnboarding {
                    OnboardingView()
                } else {
                    MainTabView()
                }
            } else {
                LoginView()
            }
        }
        .animation(.default, value: authVM.isAuthenticated)
    }
}
```

### Criterios de Aceptación
- [ ] Sign in with Apple funciona en sandbox
- [ ] Credenciales guardadas en Keychain
- [ ] Onboarding se muestra solo una vez
- [ ] Welcome muestra nombre del usuario
- [ ] Transiciones suaves entre estados
- [ ] Logout limpia todos los datos de auth
- [ ] Tests de flujo completo pasan

### Entregables
- Apple Sign In manager
- Auth view model
- Onboarding screens
- Welcome screen
- Root navigation logic
- UI tests del flujo

### Commit
```bash
git commit -m "feat(auth): apple sign in, onboarding & welcome with name

- Implemented Sign in with Apple with proper error handling
- Created 5-screen onboarding flow
- Added personalized welcome screen
- Secure credential storage in Keychain
- Root navigation based on auth state
- Full flow UI tests"
```

---

## FASE 5: QA Final & Stress

### Objetivos
- Ejecutar suite completa de tests
- Realizar stress testing
- Auditar accesibilidad
- Optimizar performance
- Generar reportes de calidad

### Tareas Detalladas

#### 5.1 Test Suite Execution
```bash
# Run all tests
xcodebuild test \
    -scheme Ritmia \
    -destination 'platform=iOS Simulator,name=iPhone 15' \
    -resultBundlePath TestResults.xcresult
```

#### 5.2 Stress Testing
- Crear 10,000 workouts
- Scroll performance en History
- Memory leaks con Instruments
- Battery usage profiling
- Network interruption handling

#### 5.3 Accessibility Audit
```swift
// AccessibilityAudit.swift
func auditAccessibility() {
    // Check all interactive elements have labels
    // Verify Dynamic Type support
    // Test with VoiceOver
    // Validate color contrast ratios
    // Generate report
}
```

#### 5.4 Performance Optimization
- Core Data fetch optimization
- Image loading optimization
- Animation performance
- Launch time optimization
- Memory footprint reduction

#### 5.5 Security Validation
```bash
# security_scan.sh
#!/bin/bash

echo "🔍 Scanning for security issues..."

# Check for hardcoded secrets
grep -r "password\|secret\|key\|token" --include="*.swift" .

# Check for HTTP URLs
grep -r "http://" --include="*.swift" .

# Verify file protection
# Check Keychain usage
# Validate entitlements
```

#### 5.6 Final Reports
- Test coverage report
- Performance benchmarks
- Accessibility compliance
- Security audit results
- Known issues list

### Criterios de Aceptación
- [ ] 95%+ tests passing
- [ ] No memory leaks detected
- [ ] Launch time < 2 seconds
- [ ] Scroll performance 60 FPS
- [ ] Accessibility audit passed
- [ ] Security scan clean
- [ ] Crash-free for 30 min stress test

### Entregables
- Test results bundle
- Performance profile
- Accessibility report
- Security audit report
- QA sign-off document

### Commit
```bash
git commit -m "chore(qa): final stress & accessibility pass

- All tests passing (98% coverage)
- Fixed memory leaks in History view
- Optimized launch time to 1.3s
- Accessibility audit passed with AA compliance
- Security scan completed successfully
- 30-minute stress test passed without crashes"
```

---

## FASE 6: RC & TestFlight

### Objetivos
- Crear Release Candidate build
- Configurar TestFlight
- Distribuir a beta testers
- Recolectar feedback
- Fix críticos si hay

### Tareas Detalladas

#### 6.1 Release Configuration
```bash
# Update version and build number
agvtool new-marketing-version 1.0.0
agvtool next-version -all
```

#### 6.2 Archive Build
```bash
# Create archive
xcodebuild archive \
    -scheme Ritmia \
    -configuration Release \
    -archivePath ./build/Ritmia.xcarchive
```

#### 6.3 TestFlight Setup
- Export for App Store
- Upload to App Store Connect
- Configure test information
- Add external testers
- Set feedback email

#### 6.4 Beta Test Plan
```markdown
## TestFlight Beta Test

### Testers Needed: 10-20
### Duration: 3-5 days

### Focus Areas:
1. Onboarding flow completion
2. Workout recording accuracy
3. Sync reliability
4. Crash reporting
5. UI/UX feedback

### Known Issues:
- (List any known issues)

### Feedback Template:
- Device model:
- iOS version:
- Issue description:
- Steps to reproduce:
- Expected vs actual:
```

#### 6.5 Feedback Collection
- Monitor TestFlight crashes
- Collect user feedback
- Prioritize issues
- Quick fixes if needed
- Update release notes

### Criterios de Aceptación
- [ ] RC build created successfully
- [ ] TestFlight configured
- [ ] 10+ beta testers added
- [ ] Test plan distributed
- [ ] No critical crashes in 48h
- [ ] Feedback collected and triaged

### Entregables
- Release candidate build
- TestFlight configuration
- Beta test plan
- Feedback summary
- Go/No-Go decision

### Commit
```bash
git commit -m "release(v1.0.0-rc1): candidate build

- Version bumped to 1.0.0
- Created Release configuration archive
- Uploaded to TestFlight
- Beta test plan created
- Ready for external testing"
```

---

## FASE 7: App Store Submission

### Objetivos
- Preparar todos los assets
- Completar App Store listing
- Submit para review
- Monitorear proceso
- Release management

### Tareas Detalladas

#### 7.1 App Store Assets
- App Icon (1024x1024)
- Screenshots iPhone 6.5" (1284 × 2778)
- Screenshots iPhone 5.5" (1242 × 2208)
- Preview video (opcional)

#### 7.2 App Store Metadata
```yaml
App Name: Ritmia - Ritmo Fitness
Subtitle: Mantén tu ritmo de ejercicio
Category: Health & Fitness
Age Rating: 4+

Keywords: |
  fitness,ejercicio,entrenamiento,racha,gym,
  deporte,salud,rutina,workout,correr

Description: |
  Ritmia te ayuda a mantener el ritmo en tu vida fitness.
  
  Con Ritmia puedes:
  • Registrar tus entrenamientos fácilmente
  • Ver tu progreso semanal de un vistazo
  • Mantener tu racha de días activos
  • Compartir tus logros en Instagram Stories
  • Sincronizar datos con iCloud
  
  Simple, motivador y efectivo.

What's New: |
  ¡Primera versión de Ritmia!
  - Registro rápido de entrenamientos
  - Visualización de progreso semanal
  - Rachas motivacionales
  - Sincronización con iCloud
  - Compartir en redes sociales
```

#### 7.3 App Review Information
```yaml
Review Notes: |
  - Use Sign in with Apple in sandbox mode
  - All features available without payment
  - No external accounts needed
  - Instagram sharing is optional

Demo Account: Use Sign in with Apple
Contact Email: support@ritmia.app
Contact Phone: +52 555 123 4567
```

#### 7.4 Privacy & Compliance
- Export compliance (no encryption)
- Privacy policy URL
- Terms of service URL
- Data usage descriptions

#### 7.5 Submit & Monitor
- Final build upload
- Submit for review
- Monitor status
- Respond to reviewer quickly
- Plan release timing

### Criterios de Aceptación
- [ ] All assets uploaded
- [ ] Metadata complete
- [ ] Screenshots approved
- [ ] Privacy compliance done
- [ ] Submitted successfully
- [ ] No validation errors

### Entregables
- App Store listing complete
- Final build submitted
- Review notes prepared
- Release plan ready
- Marketing materials

### Commit
```bash
git commit -m "release(v1.0.0): App Store submission

- Final production build created
- App Store assets prepared
- Metadata and descriptions finalized
- Privacy compliance completed
- Submitted for App Store review
- Version 1.0.0 ready for release"
```

---

## Post-Release Plan

### Immediate (Week 1)
- Monitor crash reports
- Respond to reviews
- Fix critical issues
- Collect user feedback

### Short Term (Month 1)
- Version 1.0.1 with fixes
- Analyze usage metrics
- Plan v1.1 features
- Engage with community

### Medium Term (Month 2-3)
- Instagram Stories templates
- Performance improvements
- More workout types
- User requested features

### Long Term (v2.0)
- Apple Watch app
- Social challenges
- AI recommendations
- Premium features

---

## Definition of Done (DoD)

### Para cada fase:
1. ✅ Código compila sin warnings
2. ✅ Tests pasan (cuando aplique)
3. ✅ SwiftLint sin violaciones
4. ✅ Documentación actualizada
5. ✅ Commit con mensaje descriptivo
6. ✅ Build en Debug y Release
7. ✅ No memory leaks
8. ✅ Accesibilidad verificada

### Para el proyecto completo:
1. ✅ App Store listing completo
2. ✅ TestFlight beta exitoso
3. ✅ Documentación técnica final
4. ✅ Scripts de deployment
5. ✅ Backup del código
6. ✅ Handoff completado

---

**Documento generado para Claude Code**
Versión: 1.0
Última actualización: Octubre 2024