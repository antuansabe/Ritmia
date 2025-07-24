# Plan de Commits - Ritmia

## Convención de Commits

Seguimos el estándar Conventional Commits:
- `feat`: Nueva funcionalidad
- `fix`: Corrección de bug
- `docs`: Cambios en documentación
- `style`: Cambios de formato (no afectan funcionalidad)
- `refactor`: Refactorización de código
- `test`: Añadir o modificar tests
- `chore`: Tareas de mantenimiento
- `perf`: Mejoras de performance
- `ci`: Cambios en CI/CD
- `release`: Preparación de release

Formato: `type(scope): summary`

---

## Commits por Fase

### FASE 0: Bootstrap
```bash
# Commit 1
git commit -m "chore(project): bootstrap clean iOS project with SwiftUI & Core Data

- Created Xcode project with proper configuration
- Bundle ID: com.ritmia.app
- Minimum iOS 16.0
- SwiftUI interface
- Core Data enabled
- Test targets included"

# Commit 2
git commit -m "chore(structure): set up clean architecture folder structure

- App layer: entry point and configuration
- Core layer: data, domain, extensions
- Features layer: auth, home, record, history, profile
- Shared layer: UI components, utilities, services
- Resources: assets, localization, info.plist"

# Commit 3
git commit -m "chore(tools): add SwiftLint and Git configuration

- Added .swiftlint.yml with strict rules
- Configured .gitignore for iOS development
- Added README.md with project overview
- Set up pre-commit hooks for linting"
```

### FASE 1: Core Data + WeekEngine
```bash
# Commit 4
git commit -m "feat(coredata): implement Core Data stack with CloudKit

- Created NSPersistentCloudKitContainer
- Configured for iCloud.com.ritmia.app
- Added preview container for SwiftUI
- Automatic merge from parent context
- Error handling and logging"

# Commit 5
git commit -m "feat(coredata): add data model entities

- WorkoutEntity: all fields with proper types
- UserProfileEntity: Apple ID and user info
- AppSettingsEntity: app preferences
- Added indexes for performance
- Configured CloudKit compatibility"

# Commit 6
git commit -m "feat(domain): implement WeekEngine for week calculations

- Monday to Sunday week bounds calculation
- Streak calculation for current week
- Cross-midnight workout handling
- Time zone aware calculations
- Comprehensive unit tests"

# Commit 7
git commit -m "feat(data): add repositories with async/await

- WorkoutRepository with CRUD operations
- UserRepository for profile management
- SettingsRepository for preferences
- All methods use async/await pattern
- Error handling implemented"

# Commit 8
git commit -m "test(core): add comprehensive unit tests

- WeekEngine: 15 test cases covering edge cases
- Repositories: CRUD operation tests
- Core Data: migration and sync tests
- 92% code coverage achieved
- All tests passing"
```

### FASE 2: Seguridad & Legal
```bash
# Commit 9
git commit -m "feat(security): implement Keychain manager

- KeychainManager with full CRUD operations
- Proper error handling and types
- SecureStorage property wrapper
- Unit tests for all operations
- Documentation added"

# Commit 10
git commit -m "feat(security): add file protection

- FileProtection.completeUnlessOpen for Core Data
- Protection applied to all sensitive files
- Verified protection attributes
- Added security utilities"

# Commit 11
git commit -m "feat(privacy): add Privacy Manifest for iOS 17+

- Created PrivacyInfo.xcprivacy
- Declared UserDefaults usage
- Declared fitness data collection
- No tracking, no third parties
- Compliant with latest requirements"

# Commit 12
git commit -m "feat(legal): embed legal documents

- Added PrivacyPolicy.md to bundle
- Added TermsOfService.md to bundle
- Created LegalView for display
- Markdown rendering implemented
- Accessible offline"

# Commit 13
git commit -m "chore(scripts): add security and privacy scripts

- security_scan.sh: finds security issues
- export_privacy_report.sh: privacy audit
- final_stress.sh: stress testing
- All scripts tested and documented
- Added to Scripts directory"
```

### FASE 3: UI MVP
```bash
# Commit 14
git commit -m "feat(ui): create design system and components

- Color palette with semantic naming
- Typography system with Dynamic Type
- Spacing constants
- Reusable card components
- Accessibility support"

# Commit 15
git commit -m "feat(home): implement home screen with metrics

- Dynamic greeting based on time
- Three metric cards (workouts, minutes, calories)
- Current streak visualization
- Weekly goal progress
- Empty state handling"

# Commit 16
git commit -m "feat(record): implement workout recording flow

- Workout type selection (8 types)
- Duration picker with validation
- Automatic calorie calculation
- Notes input field
- Haptic feedback on save"

# Commit 17
git commit -m "feat(history): implement workout history view

- Weekly calendar header
- Grouped list by days
- Filtering capabilities
- Empty state message
- Pull to refresh"

# Commit 18
git commit -m "feat(profile): implement profile and settings

- User info display
- Settings sections
- Legal document links
- Account management
- Theme selection"

# Commit 19
git commit -m "feat(navigation): add TabView navigation

- Four main tabs configured
- Icons and labels
- Selection state handling
- Smooth transitions
- Accessibility labels"

# Commit 20
git commit -m "feat(viewmodels): connect ViewModels to repositories

- HomeViewModel with metrics calculation
- RecordViewModel with validation
- HistoryViewModel with filtering
- ProfileViewModel with settings
- All using Combine"
```

### FASE 4: Auth + Onboarding
```bash
# Commit 21
git commit -m "feat(auth): implement Sign in with Apple

- ASAuthorizationController setup
- Credential validation
- Keychain storage for tokens
- Error handling
- UI integration"

# Commit 22
git commit -m "feat(auth): add auth state management

- AuthViewModel with published state
- Session persistence
- Auto-login on launch
- Logout functionality
- Secure credential handling"

# Commit 23
git commit -m "feat(onboarding): create 5-screen onboarding flow

- Welcome screen with animations
- Features showcase
- Weekly goal setting
- Notifications opt-in
- Completion tracking"

# Commit 24
git commit -m "feat(welcome): add personalized welcome screen

- Display user's name from Apple ID
- Celebration animation
- Smooth transition to app
- Only shown after onboarding
- Accessibility compliant"

# Commit 25
git commit -m "feat(navigation): implement root navigation logic

- Auth state based navigation
- Onboarding check
- Smooth transitions
- Deep link ready
- State restoration support"

# Commit 26
git commit -m "test(auth): add auth flow UI tests

- Sign in with Apple flow test
- Onboarding completion test
- Welcome screen test
- Logout flow test
- Error handling tests"
```

### FASE 5: QA Final
```bash
# Commit 27
git commit -m "test(suite): run complete test suite

- 98% test coverage achieved
- All unit tests passing
- All UI tests passing
- No SwiftLint violations
- Documentation updated"

# Commit 28
git commit -m "perf(optimization): optimize performance issues

- Fixed memory leak in HistoryView
- Optimized Core Data fetches
- Reduced launch time to 1.3s
- Improved scroll performance
- Reduced memory footprint"

# Commit 29
git commit -m "fix(accessibility): fix accessibility issues

- Added missing labels
- Fixed color contrast issues
- Dynamic Type support verified
- VoiceOver navigation fixed
- Accessibility audit passed"

# Commit 30
git commit -m "chore(qa): complete stress testing

- 30-minute stress test passed
- No crashes detected
- Memory stable
- Performance benchmarks met
- Ready for release"
```

### FASE 6: RC & TestFlight
```bash
# Commit 31
git commit -m "chore(version): bump version to 1.0.0

- Marketing version: 1.0.0
- Build number: 1
- Updated Info.plist
- Updated release notes
- Configuration verified"

# Commit 32
git commit -m "release(v1.0.0-rc1): create release candidate

- Archive created successfully
- SwiftShield obfuscation applied
- Symbols uploaded
- TestFlight build ready
- Beta test plan included"

# Commit 33 (si hay fixes del beta)
git commit -m "fix(beta): address beta feedback

- Fixed keyboard dismissal issue
- Improved loading states
- Enhanced error messages
- Updated help text
- Polish based on feedback"

# Tag final
git tag -a v1.0.0-rc1 -m "Release Candidate 1"
```

### FASE 7: App Store
```bash
# Commit 34
git commit -m "chore(assets): add App Store assets

- App icon 1024x1024
- Screenshots for 6.5 inch
- Screenshots for 5.5 inch
- Metadata prepared
- Keywords optimized"

# Commit 35
git commit -m "docs(release): update release documentation

- Updated README
- Added CHANGELOG
- Release notes finalized
- Support documentation
- Contribution guidelines"

# Commit 36
git commit -m "release(v1.0.0): App Store release

- Final production build
- All tests passing
- Documentation complete
- Assets uploaded
- Ready for submission"

# Tag final
git tag -a v1.0.0 -m "Version 1.0.0 - App Store Release"
```

---

## Commits Post-Release

### Hotfix (si es necesario)
```bash
git commit -m "fix(critical): fix crash on iOS 16.0

- Fixed nil unwrapping in WeekEngine
- Added defensive checks
- Updated unit tests
- Verified on all iOS versions"

git tag -a v1.0.1 -m "Hotfix Release"
```

### Feature Updates
```bash
git commit -m "feat(social): add Instagram Stories sharing

- Story template generation
- Customizable backgrounds
- Metrics overlay
- Share flow implementation
- Preview before sharing"
```

---

## Buenas Prácticas

1. **Commits Atómicos**: Un commit = un cambio lógico
2. **Mensajes Claros**: El título resume QUÉ, el cuerpo explica POR QUÉ
3. **Sin Código Roto**: Cada commit debe compilar
4. **Tests Incluidos**: Si añades código, añade tests
5. **Documentación**: Actualizar docs en el mismo commit

---

**Total estimado: ~36 commits principales + tags de release**