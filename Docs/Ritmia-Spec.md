# Ritmia - Especificación Técnica Completa v1.0

## 1. Resumen Ejecutivo

### 1.1 Visión
Ritmia es una aplicación iOS de fitness diseñada para motivar a usuarios a mantener una rutina de ejercicio consistente mediante el seguimiento visual de su progreso semanal, rachas de entrenamiento y la capacidad de compartir logros en redes sociales.

### 1.2 Público Objetivo
- **Primario**: Adultos (25-45 años) con dispositivos iPhone, interesados en mantener o iniciar una rutina de ejercicio
- **Secundario**: Jóvenes adultos (18-25 años) activos en redes sociales que buscan compartir sus logros fitness

### 1.3 Plataformas
- iOS 16.0+ (iPhone únicamente en v1.0)
- Idiomas: Español (México) como default, Inglés (US)
- Sincronización: iCloud (CloudKit privado)

### 1.4 Restricciones
- Sin conexión a backend propio en v1.0
- Sin monetización inicial
- Cumplimiento estricto con App Store Guidelines
- GDPR/Privacy compliance

## 2. Arquitectura Técnica

### 2.1 Stack Tecnológico
- **UI Framework**: SwiftUI 5.0
- **Persistencia**: Core Data + CloudKit
- **Arquitectura**: MVVM-C (Model-View-ViewModel-Coordinator)
- **Dependency Injection**: Lightweight DI Container
- **Concurrencia**: Swift Concurrency (async/await)
- **Seguridad**: Keychain Services + CryptoKit

### 2.2 Arquitectura Offline-First
```swift
// Principio de diseño
protocol OfflineCapable {
    func saveLocally() async throws
    func syncWhenAvailable() async
    func resolveConflicts(_ conflicts: [SyncConflict]) async throws
}
```

### 2.3 CloudKit Integration
- **Container**: NSPersistentCloudKitContainer
- **Database**: Private Database only
- **Sync Strategy**: 
  - Automatic background sync
  - Manual pull-to-refresh
  - Conflict resolution: Last-Write-Wins con merge inteligente

### 2.4 Cifrado y Seguridad
- **En Reposo**: FileProtection.completeUnlessOpen
- **Credenciales**: Keychain con kSecAttrAccessibleWhenUnlockedThisDeviceOnly
- **Obfuscación**: SwiftShield solo en Release builds
- **Rationale SQLCipher**: No se usará SQLCipher debido a:
  - Complejidad adicional de mantenimiento
  - FileProtection es suficiente para datos fitness no-críticos
  - Impacto en performance vs beneficio marginal

## 3. Módulos / Capas

### 3.1 App / Bootstrap Layer
```
/App
├── RitmiaApp.swift          // @main App entry point
├── AppDelegate.swift        // UIApplicationDelegate
├── AppState.swift          // Global app state
├── AppDependencies.swift   // DI Container
└── AppConfiguration.swift  // Environment config
```

### 3.2 Data Layer
```
/Data
├── CoreData/
│   ├── Ritmia.xcdatamodeld
│   ├── PersistenceController.swift
│   ├── NSManagedObject+Extensions.swift
│   └── Migration/
│       └── CoreDataMigrationPolicy.swift
├── Repositories/
│   ├── WorkoutRepository.swift
│   ├── UserRepository.swift
│   └── SettingsRepository.swift
└── CloudKit/
    ├── CloudKitManager.swift
    ├── ConflictResolver.swift
    └── SyncCoordinator.swift
```

### 3.3 Domain / Services Layer
```
/Domain
├── Models/
│   ├── Workout.swift
│   ├── User.swift
│   ├── WeeklyProgress.swift
│   └── Achievement.swift
├── Services/
│   ├── WeekEngine.swift
│   ├── StreakCalculator.swift
│   ├── MetricsService.swift
│   ├── AuthService.swift
│   └── NotificationScheduler.swift
└── UseCases/
    ├── RecordWorkoutUseCase.swift
    ├── CalculateWeeklyProgressUseCase.swift
    └── ShareToInstagramUseCase.swift
```

### 3.4 UI / Presentation Layer
```
/UI
├── Theme/
│   ├── Colors.swift
│   ├── Typography.swift
│   └── Spacing.swift
├── Components/
│   ├── Cards/
│   ├── Buttons/
│   └── Charts/
├── Screens/
│   ├── Auth/
│   ├── Onboarding/
│   ├── Home/
│   ├── Record/
│   ├── History/
│   └── Profile/
└── ViewModels/
    ├── AuthViewModel.swift
    ├── HomeViewModel.swift
    ├── RecordViewModel.swift
    └── HistoryViewModel.swift
```

### 3.5 Security Module
```
/Security
├── SecureStorage.swift
├── KeychainManager.swift
├── BiometricAuthManager.swift
└── SecurityUtils.swift
```

### 3.6 Legal Module
```
/Legal
├── LegalDocumentsManager.swift
├── ConsentManager.swift
└── Documents/
    ├── PrivacyPolicy.md
    └── TermsOfService.md
```

## 4. Modelo de Datos (Core Data)

### 4.1 WorkoutEntity
```swift
// Core Data Entity
@objc(WorkoutEntity)
class WorkoutEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var type: String // enum rawValue
    @NSManaged var duration: Int32 // minutos
    @NSManaged var calories: Int32
    @NSManaged var date: Date // UTC
    @NSManaged var createdAt: Date
    @NSManaged var updatedAt: Date
    @NSManaged var notes: String?
    @NSManaged var source: String // "manual", "import", "healthkit"
    @NSManaged var deviceModel: String // iPhone14,2
    @NSManaged var isDeleted: Bool // soft delete
    @NSManaged var syncStatus: String // "pending", "synced", "conflict"
}

// Indexes
// - date (para queries por día/semana)
// - type + date (para estadísticas por tipo)
// - syncStatus (para sync queue)
```

### 4.2 UserProfileEntity
```swift
@objc(UserProfileEntity)
class UserProfileEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var appleUserID: String // desde Sign in with Apple
    @NSManaged var displayName: String
    @NSManaged var email: String? // opcional, puede no compartirse
    @NSManaged var avatarData: Data? // foto perfil
    @NSManaged var createdAt: Date
    @NSManaged var lastActiveAt: Date
    @NSManaged var preferredLanguage: String // es-MX, en-US
    @NSManaged var timeZone: String // America/Mexico_City
}
```

### 4.3 AppSettingsEntity
```swift
@objc(AppSettingsEntity)
class AppSettingsEntity: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var weeklyGoal: Int16 // 1-7 días
    @NSManaged var didShowOnboarding: Bool
    @NSManaged var lastStreakReset: Date
    @NSManaged var theme: String // "light", "dark", "system"
    @NSManaged var notificationsEnabled: Bool
    @NSManaged var notificationTime: Date? // hora preferida
    @NSManaged var shareToSocialEnabled: Bool
    @NSManaged var hapticFeedbackEnabled: Bool
    @NSManaged var soundsEnabled: Bool
    @NSManaged var caloriesCalculationMode: String // "automatic", "manual"
    @NSManaged var instagramUsername: String? // para pre-fill en shares
}
```

### 4.4 Predicados y Queries Optimizados
```swift
// Semana actual (lunes-domingo)
NSPredicate(format: "date >= %@ AND date <= %@ AND isDeleted == NO", 
            weekStart, weekEnd)

// Mes actual
NSPredicate(format: "date >= %@ AND date <= %@ AND isDeleted == NO", 
            monthStart, monthEnd)

// Por tipo en rango
NSPredicate(format: "type == %@ AND date >= %@ AND date <= %@ AND isDeleted == NO", 
            workoutType, startDate, endDate)
```

## 5. Lógica de Semana / Racha

### 5.1 Definición de Semana
```swift
struct WeekDefinition {
    // Semana: Lunes 00:00:00 → Domingo 23:59:59 (zona horaria local)
    static func currentWeekBounds(in timeZone: TimeZone) -> (start: Date, end: Date) {
        let calendar = Calendar(identifier: .gregorian)
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 2 // Lunes
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        let weekStart = calendar.date(from: components)!
        let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart)!
            .addingTimeInterval(86399) // 23:59:59
        
        return (weekStart, weekEnd)
    }
}
```

### 5.2 Cálculo de Racha
```swift
class StreakCalculator {
    // Racha = días únicos con al menos 1 entrenamiento en la semana actual
    func calculateCurrentStreak(workouts: [Workout], timeZone: TimeZone) -> Int {
        let (weekStart, weekEnd) = WeekDefinition.currentWeekBounds(in: timeZone)
        
        let weekWorkouts = workouts.filter { 
            $0.date >= weekStart && $0.date <= weekEnd 
        }
        
        let uniqueDays = Set(weekWorkouts.map { 
            Calendar.current.startOfDay(for: $0.date) 
        })
        
        return uniqueDays.count
    }
    
    // Reset automático cada lunes a las 00:00
    func shouldResetStreak(lastReset: Date, currentDate: Date) -> Bool {
        let calendar = Calendar.current
        let lastMonday = calendar.dateInterval(of: .weekOfYear, for: lastReset)?.start ?? lastReset
        let currentMonday = calendar.dateInterval(of: .weekOfYear, for: currentDate)?.start ?? currentDate
        return currentMonday > lastMonday
    }
}
```

### 5.3 Manejo de Entrenamientos Cross-Midnight
```swift
// Regla: Un entrenamiento pertenece al día en que INICIÓ
// Ejemplo: Entreno iniciado 23:45 del lunes, terminado 00:15 del martes = cuenta para lunes
extension Workout {
    var assignedDay: Date {
        Calendar.current.startOfDay(for: self.date) // fecha de inicio
    }
}
```

## 6. Seguridad

### 6.1 Keychain Storage
```swift
// Items almacenados en Keychain
enum KeychainItems {
    static let appleUserID = "com.ritmia.apple.userid"
    static let userName = "com.ritmia.user.name"
    static let userEmail = "com.ritmia.user.email"
    static let sessionToken = "com.ritmia.session.token"
    static let biometricEnabled = "com.ritmia.biometric.enabled"
}

// Configuración de acceso
let keychainAccess = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
```

### 6.2 Local Data Protection
```swift
// FileProtection para Core Data
let storeURL = containerURL.appendingPathComponent("Ritmia.sqlite")
try FileManager.default.setAttributes([
    .protectionKey: FileProtectionType.completeUnlessOpen
], ofItemAtPath: storeURL.path)
```

### 6.3 SwiftShield Configuration
```yaml
# swiftshield.yml
project_path: "Ritmia.xcodeproj"
target_name: "Ritmia"
obfuscation_mode: "release_only"
excluded_patterns:
  - "*/Legal/*"
  - "*/Resources/*"
  - "*.md"
output_directory: "swiftshield-output"
```

### 6.4 App Transport Security
```xml
<!-- Info.plist -->
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
    <key>NSExceptionDomains</key>
    <dict>
        <!-- Solo dominios específicos si es necesario -->
    </dict>
</dict>
```

### 6.5 Privacy Manifest (iOS 17+)
```xml
<!-- PrivacyInfo.xcprivacy -->
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict>
    <key>NSPrivacyTracking</key>
    <false/>
    <key>NSPrivacyCollectedDataTypes</key>
    <array>
        <dict>
            <key>NSPrivacyCollectedDataType</key>
            <string>NSPrivacyCollectedDataTypeFitness</string>
            <key>NSPrivacyCollectedDataTypeLinked</key>
            <true/>
            <key>NSPrivacyCollectedDataTypeTracking</key>
            <false/>
            <key>NSPrivacyCollectedDataTypePurposes</key>
            <array>
                <string>NSPrivacyCollectedDataTypePurposeAppFunctionality</string>
            </array>
        </dict>
        <dict>
            <key>NSPrivacyCollectedDataType</key>
            <string>NSPrivacyCollectedDataTypeUserID</string>
            <key>NSPrivacyCollectedDataTypeLinked</key>
            <true/>
            <key>NSPrivacyCollectedDataTypeTracking</key>
            <false/>
            <key>NSPrivacyCollectedDataTypePurposes</key>
            <array>
                <string>NSPrivacyCollectedDataTypePurposeAppFunctionality</string>
            </array>
        </dict>
    </array>
    <key>NSPrivacyAccessedAPITypes</key>
    <array>
        <dict>
            <key>NSPrivacyAccessedAPIType</key>
            <string>NSPrivacyAccessedAPICategoryUserDefaults</string>
            <key>NSPrivacyAccessedAPITypeReasons</key>
            <array>
                <string>CA92.1</string>
            </array>
        </dict>
    </array>
</dict>
</plist>
```

## 7. Autenticación

### 7.1 Sign in with Apple Flow
```swift
protocol AuthenticationService {
    func signInWithApple() async throws -> AuthUser
    func signOut() async throws
    func revokeAccess() async throws
    func getCurrentUser() -> AuthUser?
    func isAuthenticated() -> Bool
}

// Implementación
class AppleAuthService: AuthenticationService {
    // 1. Request authorization
    // 2. Validate credentials
    // 3. Store in Keychain
    // 4. Create/update UserProfile
    // 5. Trigger onboarding if new user
}
```

### 7.2 Logout Seguro
```swift
func performSecureLogout() async throws {
    // 1. Clear Keychain items
    // 2. Reset UserDefaults
    // 3. Clear Core Data user data (mantener workouts?)
    // 4. Revoke CloudKit access
    // 5. Reset to login screen
    // 6. Clear memory caches
}
```

### 7.3 Revocación y Eliminación de Cuenta
```swift
func deleteAccount() async throws {
    // 1. Confirm with biometric/password
    // 2. Show final confirmation dialog
    // 3. Export data option
    // 4. Delete CloudKit records
    // 5. Delete local Core Data
    // 6. Clear all Keychain
    // 7. Revoke Apple Sign In
    // 8. Show goodbye screen
    // 9. Exit app
}
```

## 8. Flujos de UI

### 8.1 Auth Flow Completo
```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Splash    │ ──> │    Login     │ ──> │ Onboarding  │
│  (1-2 seg)  │     │ (Apple btn)  │     │  (1 vez)    │
└─────────────┘     └──────────────┘     └─────────────┘
                            │                     │
                            v                     v
                    ┌──────────────┐     ┌─────────────┐
                    │   Welcome    │ <── │   TabView   │
                    │ (con nombre) │     │  Principal  │
                    └──────────────┘     └─────────────┘
```

### 8.2 Pantalla de Inicio (Home)
```swift
struct HomeView {
    // Layout: ScrollView vertical
    
    // 1. Header con saludo personalizado
    "¡Hola, [Nombre]!" // Cambia según hora del día
    
    // 2. Tarjetas de métricas (3, horizontales)
    [🏃 Entrenamientos] [⏱️ Minutos] [🔥 Calorías]
    "3 esta semana"     "125 min"     "890 cal"
    
    // 3. Racha actual
    [🔥 Racha: 5 días consecutivos]
    [Progreso semanal: L✓ M✓ X✓ J✓ V✓ S○ D○]
    
    // 4. Meta semanal
    [Meta: 5/7 días] [71% completado]
    [Progress bar visual]
    
    // 5. CTA si no hay entrenamientos hoy
    if !hasWorkoutToday {
        [Registrar entrenamiento de hoy →]
    }
    
    // 6. Última actividad
    "Último entreno: Correr 30 min hace 2 horas"
}
```

### 8.3 Registrar Entrenamiento
```swift
struct RecordWorkoutView {
    // Flujo paso a paso
    
    // Paso 1: Selección de tipo
    ScrollView(.horizontal) {
        [🏃 Correr] [🚴 Bicicleta] [🏊 Nadar] [🏋️ Pesas]
        [🧘 Yoga] [⚽ Deporte] [🚶 Caminar] [➕ Otro]
    }
    
    // Paso 2: Duración
    TimePicker {
        // Ruleta de minutos: 5, 10, 15... 180
        // Opción manual: TextField numérico
    }
    
    // Paso 3: Calorías (opcional)
    Toggle("Calcular automáticamente") // Based on MET values
    if manual {
        TextField("Calorías quemadas")
    }
    
    // Paso 4: Notas (opcional)
    TextField("Añade una nota...")
    
    // Validación y guardado
    Button("Guardar entrenamiento") {
        // Haptic feedback: .light
        // Animación de éxito
        // Auto-return a Inicio
    }
}
```

### 8.4 Historial
```swift
struct HistoryView {
    // Header: Calendario semanal
    [L] [M] [X] [J] [V] [S] [D]
     ✓   ✓   ✓   ○   ✓   ○   ○
    
    // Lista por días (agrupada)
    ForEach(workoutsByDay) { day in
        Section(header: "Jueves 24 Oct") {
            WorkoutRow("🏃 Correr", "30 min", "250 cal")
            WorkoutRow("🏋️ Pesas", "45 min", "380 cal")
        }
    }
    
    // Filtros flotantes
    [Todos] [Esta semana] [Este mes] [Por tipo]
    
    // Empty state
    if workouts.isEmpty {
        "Aún no has registrado entrenamientos"
        "¡Empieza hoy! 💪"
    }
}
```

### 8.5 Perfil
```swift
struct ProfileView {
    // Avatar + Info
    [Avatar/Iniciales]
    "Juan Pérez"
    "Meta semanal: 5 días"
    
    // Secciones
    Section("Ajustes") {
        NavigationLink("Meta semanal") { WeeklyGoalView() }
        NavigationLink("Notificaciones") { NotificationSettingsView() }
        NavigationLink("Apariencia") { ThemeSettingsView() }
    }
    
    Section("Datos") {
        NavigationLink("Exportar datos") { ExportDataView() }
        NavigationLink("Sincronización") { SyncStatusView() }
    }
    
    Section("Legal") {
        NavigationLink("Términos de servicio") { TermsView() }
        NavigationLink("Política de privacidad") { PrivacyView() }
    }
    
    Section("Cuenta") {
        Button("Cerrar sesión") { }
        Button("Eliminar cuenta", role: .destructive) { }
    }
    
    // Footer con versión (solo Debug)
    #if DEBUG
    Text("v1.0.0 (123) - Debug")
    #endif
}
```

### 8.6 Onboarding (Post-login, una sola vez)
```swift
// Pantalla 1: Bienvenida
"Bienvenido a Ritmia"
"Tu compañero para mantener el ritmo"
[Imagen: Logo animado]

// Pantalla 2: Beneficios
"Registra tus entrenamientos"
"Mantén tu racha semanal"
"Comparte tus logros"
[Imagen: Screenshots de la app]

// Pantalla 3: Meta semanal
"¿Cuántos días quieres entrenar?"
[Selector: 1-7 días]
"Puedes cambiarlo después"

// Pantalla 4: Notificaciones (opcional)
"¿Quieres recordatorios?"
"Te motivaremos a mantener tu racha"
[Permitir] [Ahora no]

// Pantalla 5: Listo
"¡Todo listo, [Nombre]!"
"Comienza registrando tu primer entreno"
[Empezar →]
```

### 8.7 Compartir en Instagram Stories
```swift
struct ShareToInstagramView {
    // Preview del story
    StoryPreview {
        // Fondo gradiente personalizable
        // Logo Ritmia
        // Métricas destacadas
        "🔥 5 días de racha"
        "💪 7 entrenamientos"
        "⏱️ 245 minutos"
        // @usuario_ritmia
    }
    
    // Opciones de personalización
    ColorPicker("Color de fondo")
    Toggle("Incluir racha")
    Toggle("Incluir estadísticas")
    TextField("Añadir mensaje")
    
    // Botón compartir
    Button("Compartir en Instagram") {
        // 1. Generar imagen
        // 2. Guardar en Photos
        // 3. Abrir Instagram con imagen
        // 4. Copiar texto al clipboard
    }
}
```

## 9. Localización

### 9.1 Configuración i18n
```swift
// Localizable.strings (es-MX)
"welcome.greeting.morning" = "¡Buenos días, %@!";
"welcome.greeting.afternoon" = "¡Buenas tardes, %@!";
"welcome.greeting.evening" = "¡Buenas noches, %@!";
"home.workouts.count" = "%d entrenamientos esta semana";
"home.streak.days" = "%d días consecutivos";
"home.empty.title" = "¡Hora de moverse!";
"home.empty.message" = "Registra tu primer entrenamiento del día";

// Localizable.strings (en-US)
"welcome.greeting.morning" = "Good morning, %@!";
"welcome.greeting.afternoon" = "Good afternoon, %@!";
"welcome.greeting.evening" = "Good evening, %@!";
"home.workouts.count" = "%d workouts this week";
"home.streak.days" = "%d day streak";
"home.empty.title" = "Time to move!";
"home.empty.message" = "Record your first workout today";
```

### 9.2 Fallback Strategy
```swift
extension String {
    var localized: String {
        let value = NSLocalizedString(self, comment: "")
        // Si retorna la misma key, usar fallback
        if value == self {
            #if DEBUG
            print("⚠️ Missing localization: \(self)")
            #endif
            // Fallback inteligente basado en la key
            return self.humanReadableFallback()
        }
        return value
    }
}
```

## 10. Accesibilidad

### 10.1 VoiceOver
```swift
// Ejemplo de implementación
WorkoutCard()
    .accessibilityLabel("Entrenamiento de correr")
    .accessibilityValue("30 minutos, 250 calorías")
    .accessibilityHint("Doble tap para ver detalles")
    .accessibilityTraits(.button)
```

### 10.2 Dynamic Type
```swift
// Soporte para tamaños de texto
Text("Título")
    .font(.headline)
    .dynamicTypeSize(.small ... .extraExtraLarge)
    .minimumScaleFactor(0.8)
```

### 10.3 Contraste y Colores
```swift
// Colores con contraste WCAG AA
extension Color {
    static let primaryText = Color("PrimaryText") // #1C1C1E en light
    static let secondaryText = Color("SecondaryText") // #8E8E93 en light
    static let accentColor = Color("AccentColor") // #007AFF con 4.5:1 ratio
}
```

## 11. Notificaciones (v1.5 - Guardado para futuro)

### 11.1 Plantillas Motivacionales
```swift
let notificationTemplates = [
    "🏃 ¡Es hora de mantener tu racha de %d días!",
    "💪 Tu cuerpo te lo agradecerá. ¿Listo para entrenar?",
    "🔥 ¡No rompas tu racha! Llevas %d días consecutivos",
    "⏰ Momento perfecto para tu entrenamiento diario",
    "🎯 Estás a un entreno de alcanzar tu meta semanal",
    "🌟 ¡Vamos! Solo 20 minutos hacen la diferencia",
    "📈 Tu progreso es increíble. ¡Sigue así!",
    "🏆 Los campeones entrenan incluso cuando no tienen ganas"
]
```

## 12. Legal

### 12.1 Política de Privacidad (Resumen)
- Datos recolectados: entrenamientos, nombre, email (opcional)
- Almacenamiento: Local + iCloud privado
- No compartimos datos con terceros
- No hay tracking ni analytics
- Derecho a eliminar todos los datos
- Contacto: privacy@ritmia.app

### 12.2 Términos de Servicio (Resumen)
- Servicio as-is, sin garantías
- Usuario responsable de su salud
- Prohibido uso comercial
- Podemos terminar servicio con aviso
- Jurisdicción: México

## 13. Build Configuration

### 13.1 Debug vs Release
```swift
// Configuration.swift
struct BuildConfig {
    #if DEBUG
    static let isDebug = true
    static let apiEnvironment = "development"
    static let enableDebugMenu = true
    static let enableLogging = true
    #else
    static let isDebug = false
    static let apiEnvironment = "production"
    static let enableDebugMenu = false
    static let enableLogging = false
    #endif
}
```

### 13.2 SwiftShield Integration
```bash
# Build Phase Script (Release only)
if [ "${CONFIGURATION}" = "Release" ]; then
    ./swiftshield -p Ritmia.xcodeproj -t Ritmia -c swiftshield.yml
fi
```

### 13.3 Scripts de Build
- `security_scan.sh`: Análisis estático de seguridad
- `export_privacy_report.sh`: Genera reporte de privacidad
- `final_stress.sh`: Tests de estrés pre-release

## 14. Testing Strategy

### 14.1 Unit Tests
```swift
// Cobertura mínima: 80%
- WeekEngineTests
  - testWeekBoundsCalculation
  - testStreakCalculation
  - testCrossMidnightWorkout
  
- WorkoutRepositoryTests
  - testSaveWorkout
  - testFetchWeeklyWorkouts
  - testDeleteWorkout
  
- MetricsServiceTests
  - testCaloriesCalculation
  - testWeeklyTotals
```

### 14.2 UI Tests
```swift
// Flujos críticos
- OnboardingUITests
  - testCompleteOnboardingFlow
  - testSkipNotifications
  
- WorkoutRecordingUITests
  - testRecordSimpleWorkout
  - testValidationErrors
  
- AuthenticationUITests
  - testSignInWithApple
  - testLogout
```

### 14.3 Stress & Performance Tests
- 10,000 workouts performance
- Sincronización con conexión intermitente
- Uso de memoria en sesiones largas
- Battery usage profiling

## 15. Ciclo de QA

### 15.1 QA Checklist Pre-Release
- [ ] Todos los tests pasan (Unit + UI)
- [ ] No memory leaks (Instruments)
- [ ] Performance benchmarks cumplidos
- [ ] Accesibilidad audit passed
- [ ] Localización completa verificada
- [ ] Screenshots para App Store
- [ ] TestFlight interno (10 testers mínimo)
- [ ] Crash-free rate > 99.5%

### 15.2 Criterios para Release Candidate
1. Zero crashes en 48 horas de testing
2. Todas las features core funcionando
3. Sincronización CloudKit estable
4. UI responsive en todos los iPhone soportados
5. Documentación actualizada

## 16. App Store Submission

### 16.1 Metadata
- **Nombre**: Ritmia - Ritmo Fitness
- **Subtítulo**: Mantén tu ritmo de ejercicio
- **Categoría**: Salud y forma física
- **Edad**: 4+
- **Precio**: Gratis

### 16.2 Keywords ASO
```
fitness,ejercicio,entrenamiento,racha,gym,
deporte,salud,rutina,workout,correr
```

### 16.3 Screenshots (6.5" y 5.5")
1. Dashboard con métricas semanales
2. Registro de entrenamiento
3. Historial con calendario
4. Compartir en Instagram
5. Perfil y metas

### 16.4 App Review Notes
- Test account: Usar Sign in with Apple Sandbox
- Funcionalidades principales: registro y tracking
- No requiere hardware especial
- Sin compras in-app en v1.0

## 17. Roadmap v2.0

### 17.1 Viralización Social
- Instagram Stories templates
- Compartir achievements
- Challenges con amigos
- Leaderboards semanales

### 17.2 Apple Watch
- App companion
- Registro desde el Watch
- Complicaciones
- Sincronización automática

### 17.3 IA y Recomendaciones
- Sugerencias de entrenamiento
- Detección de patrones
- Coaching personalizado
- Predicción de abandono

### 17.4 Monetización
- Ritmia Pro (mensual/anual)
- Themes premium
- Estadísticas avanzadas
- Backup ilimitado

## Apéndices

### A. Decisiones Técnicas Clave
1. **Core Data vs Realm**: Core Data por integración nativa con CloudKit
2. **SwiftUI vs UIKit**: SwiftUI para desarrollo más rápido y moderno
3. **Arquitectura**: MVVM por balance entre simplicidad y testabilidad
4. **No Backend v1**: Reducir complejidad y costos iniciales

### B. Riesgos Identificados
1. **Rechazo App Store**: Mitigado con compliance estricto
2. **Sincronización CloudKit**: Testing exhaustivo de edge cases
3. **Adopción usuarios**: Focus en UX simple y viral
4. **Competencia**: Diferenciación por simplicidad y social

### C. Métricas de Éxito
- 10,000 descargas primer mes
- 30% retención a 30 días
- 4.5+ rating en App Store
- 20% usuarios comparten en social

---

**Documento generado para Claude Code**
Versión: 1.0
Fecha: Octubre 2024
Próxima revisión: Post-launch v1.0