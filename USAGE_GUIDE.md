# FormKit - Guía de Uso Completo

## 🔄 Flujo de Inicialización Correcto

### Paso 1: Inicializar Core en main() o al inicio de la app
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar FormKit Core
  FormKitCore.initializeCore();
  
  // Inicializar capa Flutter
  FormKitFacade.initializeFlutter();
  
  runApp(const MyApp());
}
```

### Paso 2: Crear el formulario ANTES de acceder a controladores
```dart
// En tu BLoC, Screen o Bloc constructor:
final schema = AuthFormSchema(); // Tu esquema de formulario
final formController = FormKitCore.createForm<AuthEntity>(schema: schema);

// AHORA puedes acceder a los controladores
final emailController = FormKitFacade.getController<String>(fieldId: 'email');
final passwordController = FormKitFacade.getController<String>(fieldId: 'password');
```

### Paso 3: Usar los controladores (son nullable)
```dart
if (emailController != null) {
  emailController.setValue('user@example.com');
  final currentValue = emailController.value;
}
```

## ❌ Errores Comunes

### Error 1: Acceder a controladores antes de createForm()
```dart
// ❌ MAL - Lanzará null
class AuthBloc {
  AuthBloc() {
    // Esto falla porque createForm aún no fue llamado
    final emailController = FormKitFacade.getController<String>(fieldId: 'email');
  }
}

// ✅ CORRECTO
class AuthBloc {
  late ITextFieldController<String, String>? emailController;
  
  void initializeForm() {
    final schema = AuthFormSchema();
    FormKitCore.createForm<AuthEntity>(schema: schema);
    
    // Ahora es seguro acceder
    emailController = FormKitFacade.getController<String>(fieldId: 'email');
  }
}
```

### Error 2: Variables non-nullable con controller nullable
```dart
// ❌ MAL
final ITextFieldController<String, String> emailController = 
    FormKitFacade.getController<String>(fieldId: 'email');

// ✅ CORRECTO
final ITextFieldController<String, String>? emailController = 
    FormKitFacade.getController<String>(fieldId: 'email');

// O usar null-coalescing si deseas valor default
final ITextFieldController<String, String> emailController = 
    FormKitFacade.getController<String>(fieldId: 'email') 
    ?? throw Exception('Controller not found. Call FormKitCore.createForm first');
```

## 📋 Ciclo de Vida Completo

```
App Start
  ↓
FormKitCore.initializeCore() 
  ├─ Registra NodeWalker
  ├─ Registra AsyncValidatorService
  └─ Registra NoopReactiveEngine (placeholder)
  ↓
FormKitFacade.initializeFlutter()
  └─ Crea ControllerFactory global con Noop engine
  ↓
User Action / BLoC Creation
  ↓
FormKitCore.createForm<Entity>(schema: schema)
  ├─ Crea FormKitCoreEngine<Entity>
  ├─ Crea ReactiveEngine<Entity> (real, specific para este formulario)
  ├─ Actualiza ControllerFactory con real ReactiveEngine
  ├─ Crea todos los FieldControllers del esquema
  └─ Retorna IFormController<Entity>
  ↓
FormKitFacade.getController<T>(fieldId: 'fieldName')
  └─ Retorna ITextFieldController<String, T>? (puede ser null)
  ↓
Usuario interactúa con UI
  └─ StateBuilder escucha cambios via controller.stateStream
```

## 🎯 Mejor Práctica: ControllerProvider

En lugar de acceder directamente en el constructor, usa un Provider o getter lazy:

```dart
class AuthFormKit {
  static final _controllers = <String, ITextFieldController<String, String>?>{};
  
  static ITextFieldController<String, String>? getOrCreateController(String fieldId) {
    if (_controllers.containsKey(fieldId)) {
      return _controllers[fieldId];
    }
    
    final controller = FormKitFacade.getController<String>(fieldId: fieldId);
    _controllers[fieldId] = controller;
    return controller;
  }
  
  static void clearAll() {
    _controllers.clear();
    FormKitFacade.clearForm();
  }
}
```

## 🔧 Troubleshooting

### "Controller 'email' not found"
→ Solución: Llamar a `FormKitCore.createForm()` ANTES de acceder a controladores

### "Field '_activeControllerFactory' has not been initialized"
→ Solución: Asegurar que `FormKitCore.initializeCore()` y `FormKitFacade.initializeFlutter()` se llamen en main()

### Tipo mismatch: `ITextFieldController<String, String>?` vs `ITextFieldController<String, String>`
→ Solución: Cambiar variable a nullable (`?`) o usar null-coalescing (`??`)

---

**Nota**: El cambio a `getController` que retorna `nullable` es intencional para permitir lazy initialization y evitar excepciones inesperadas. Siempre verifica que el controller exista antes de usarlo.
