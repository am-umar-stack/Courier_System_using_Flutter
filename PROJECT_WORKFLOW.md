# A.M.U Couriers — Project Workflow & Study Guide

> **Purpose:** This document explains the entire A.M.U Couriers codebase in simple terms. It bridges the gap between a C#/Java/TypeScript developer's mental model and the Dart/Flutter implementation used in this project. Use it as a reference when preparing for technical interviews.

---

## 1. The Big Picture

### What We Built

A.M.U Couriers is a two-sided marketplace for on-demand package delivery — think Uber Connect or DoorDash, but for parcels.

- **Customers** open the app, type where they want a package picked up and dropped off, see an estimated price, and submit a delivery request.
- **Riders** open the app, see a list of pending requests with price and distance, accept one, pick up the package, and deliver it — updating the status at each step.
- **Firebase** sits in the middle as the backend — handling authentication, storing data in Firestore (a real-time NoSQL database), and sending push notifications.

### How the Frontend Talks to the Backend

There is no REST API. There are no HTTP calls from the app to a server. Instead:

```
┌─────────────────┐         ┌─────────────────┐
│   Flutter App   │◄───────►│    Firebase      │
│   (Dart code)   │  SDK    │                  │
│                 │         │  - Auth          │
│  Riverpod       │         │  - Firestore     │
│  GoRouter       │         │  - FCM           │
│  Google Maps    │         │                  │
└─────────────────┘         └─────────────────┘
```

The Flutter app uses the **Firebase SDK** directly. When the app reads from Firestore, it gets a real-time stream — like a WebSocket that pushes updates to the app whenever data changes. When the app writes to Firestore, the change propagates to all other connected clients instantly.

**C#/Java analogy:** Think of Firestore like SignalR or gRPC streams, but with built-in persistence and offline support. There's no controller layer — the app talks directly to the database through typed SDK calls.

---

## 2. Data Flow: From Tap to Database

Here's exactly what happens when a customer taps "Book Delivery":

### Step-by-Step Flow

```
User taps button
    │
    ▼
┌──────────────────────────────────────────────────┐
│  1. UI Layer (booking_screen.dart)               │
│     - Calls ref.read(bookingFormProvider         │
│       .notifier).submitBooking()                 │
└──────────────────┬───────────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────────┐
│  2. State Layer (delivery_providers.dart)        │
│     - BookingFormController.submitBooking()      │
│     - Sets state to "isSubmitting: true"         │
│     - Calls repository.createDelivery(...)       │
│     - Returns Result<DeliveryEntity>             │
└──────────────────┬───────────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────────┐
│  3. Repository Layer                              │
│     (delivery_repository_impl.dart)              │
│     - Creates a DeliveryModel from inputs        │
│     - Calls datasource.createDelivery(model)     │
│     - Wraps result in Right() or Left(Failure)   │
└──────────────────┬───────────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────────┐
│  4. Datasource Layer                              │
│     (delivery_datasource.dart)                   │
│     - Calls _firestore.collection('deliveries')  │
│       .add(model.toFirestore())                  │
│     - Returns the new document ID                │
└──────────────────┬───────────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────────┐
│  5. Firebase Firestore                           │
│     - Document created in cloud                  │
│     - All subscribed streams get notified        │
│     - Rider dashboard updates in real-time       │
└──────────────────────────────────────────────────┘
```

### C#/Java Translation

| Dart / Flutter | C# / Java Equivalent |
|---|---|
| `StateNotifier` | `ObservableObject` (MVVM) or `ViewModel` |
| `Provider` | Dependency Injection container (e.g., `IServiceProvider`) |
| `Repository` (interface) | `IRepository` interface |
| `RepositoryImpl` | Concrete service class implementing the interface |
| `Datasource` | Data Access Layer / `DbContext` wrapper |
| `Either<Failure, T>` | `Result<T>` pattern (common in C#) |
| `StreamProvider` | `IObservable<T>` or reactive stream |
| `GoRouter` | ASP.NET routing or React Router |

### Why This Layering Matters

Each layer has exactly one job:

1. **UI** — Renders pixels, captures user input. Knows nothing about databases.
2. **State (Controller)** — Manages loading/error states, coordinates between UI and data.
3. **Repository** — Business rules. Decides *what* to save, not *how* to save it.
4. **Datasource** — Raw database calls. If we swap Firestore for Supabase, only this layer changes.

This is the **Dependency Inversion Principle** — high-level modules (UI) don't depend on low-level modules (Firestore). Both depend on abstractions (repository interfaces).

---

## 3. Why We Chose What We Chose

### Riverpod (over Provider or Bloc)

| Concern | Provider | Bloc | Riverpod |
|---|---|---|---|
| Compile-time safety | ❌ Runtime errors | ✅ | ✅ |
| Needs BuildContext | ✅ Yes (painful) | ❌ No | ❌ No |
| Testability | Medium | Good | Excellent |
| Learning curve | Low | High | Medium |
| Boilerplate | Low | High | Low |

**Why Riverpod won:**
- No `BuildContext` dependency — providers are plain Dart objects, easy to test
- Compile-time safety — missing providers are caught at build time, not runtime
- `StateNotifier` pattern is identical to MVVM's `ObservableObject` in C# — familiar mental model
- `ref.watch()` is like subscribing to an `INotifyPropertyChanged` event

### GoRouter (over Navigator 2.0 or auto_route)

**Why GoRouter won:**
- Declarative route definitions (like React Router or ASP.NET routing)
- Built-in `redirect` function for auth guards — one place to protect all routes
- `ShellRoute` for wrapping authenticated pages in a navigation scaffold
- Deep linking support out of the box
- No code generation required (unlike auto_route)

### fpdart Either (over try/catch)

**Why Result types won:**
- Forces the caller to handle both success and failure — no forgotten catch blocks
- Failure is a typed object with `message`, `code`, and optional `exception`
- UI can pattern-match on failure type to show appropriate error messages
- Same pattern as `Result<T>` in C# or `Either` in TypeScript's `fp-ts`

### Feature-first (over layer-first)

**Layer-first** puts all repositories in one folder, all screens in another. As the app grows, you're jumping between 5 folders to change one feature.

**Feature-first** puts everything related to "auth" in one folder. Adding a new feature = adding a new folder. Deleting a feature = deleting a folder. No orphaned files.

---

## 4. Code Execution Flow: App Boot to Home Screen

### What Happens When the App Starts

```
main.dart
    │
    ├── WidgetsFlutterBinding.ensureInitialized()
    │   (Required before any async work in Flutter)
    │
    ├── Firebase.initializeApp()
    │   (Connects to Firebase using platform-specific config)
    │
    ├── Platform-specific setup
    │   ├── Mobile: Lock portrait orientation, style status bar
    │   └── Desktop: Configure window size (window_manager)
    │
    └── runApp(ProviderScope(child: CourierApp()))
        │
        ├── ProviderScope
        │   (Riverpod's dependency injection container —
        │    like a C# ServiceCollection)
        │
        └── CourierApp (ConsumerWidget)
            │
            ├── ref.watch(routerProvider)
            │   Creates GoRouter instance with:
            │   - All route definitions
            │   - Auth redirect logic
            │   - refreshListenable tied to auth state
            │
            └── MaterialApp.router(
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  routerConfig: router,
                )
```

### First Route: Splash Screen

```
GoRouter initialLocation: '/'
    │
    └── SplashScreen
        │
        ├── Animated logo + app name (flutter_animate)
        │
        ├── Waits 2 seconds (branding)
        │
        ├── Checks auth state:
        │   ├── User logged in?
        │   │   ├── Rider → go('/rider/dashboard')
        │   │   └── Customer → go('/booking')
        │   └── Not logged in → go('/login')
        │
        └── GoRouter redirect logic also runs:
            (double-checks auth state on every navigation)
```

### Auth State Resolution

```
authStateProvider (StreamProvider)
    │
    ├── Listens to Firebase Auth's authStateChanges() stream
    │
    ├── For each auth event:
    │   ├── User is null → emit null (unauthenticated)
    │   └── User exists →
    │       └── Fetch Firestore user document
    │           ├── Document found → emit UserEntity
    │           └── Document missing → emit null
    │
    └── routerProvider watches this stream
        └── On every change, GoRouter re-evaluates redirects
```

### Landing on the Home Screen

```
GoRouter redirects to '/booking' (customer) or '/rider/dashboard' (rider)
    │
    └── ShellRoute builder runs first:
        │
        └── HomeShellScreen
            │
            ├── Reads currentUserProvider to determine role
            │
            ├── Builds navigation destinations:
            │   ├── Customer: [Send, History, Profile]
            │   └── Rider: [Dashboard, Active, Earnings, Profile]
            │
            └── ResponsiveScaffold renders:
                ├── Mobile (< 600px): Bottom navigation bar
                ├── Tablet (600-1024px): Side nav rail (icons)
                └── Desktop (> 1024px): Side nav rail (labels)
                    + content constrained to 1200px max width
```

---

## 5. Key Patterns Explained

### Pattern: StateNotifier (like C# ViewModel)

```dart
class BookingFormController extends StateNotifier<BookingFormState> {
  // Like a C# ViewModel with INotifyPropertyChanged
  
  void setPickupLocation(LocationValue location) {
    state = state.copyWith(pickupLocation: location);
    // Setting 'state' triggers UI rebuild — like OnPropertyChanged()
  }
  
  Future<bool> submitBooking() async {
    state = state.copyWith(isSubmitting: true);
    // UI shows loading spinner
    
    final result = await _repository.createDelivery(...);
    // Async call to Firestore
    
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (delivery) => state = const BookingFormState(), // Reset form
    );
  }
}
```

### Pattern: Repository (like C# Service + Interface)

```dart
// Interface (like IRepository<T>)
abstract class DeliveryRepository {
  FutureResult<DeliveryEntity> createDelivery({...});
}

// Implementation (like DeliveryService : IDeliveryRepository)
class DeliveryRepositoryImpl implements DeliveryRepository {
  final DeliveryDatasource _datasource;
  
  FutureResult<DeliveryEntity> createDelivery({...}) async {
    try {
      String id = await _datasource.createDelivery(model);
      return Right(entity);  // Success
    } catch (e) {
      return Left(Failure.server('Failed'));  // Failure
    }
  }
}
```

### Pattern: Riverpod Provider (like DI registration)

```dart
// Like services.AddSingleton<IDeliveryRepository, DeliveryRepositoryImpl>()
final deliveryRepositoryProvider = Provider<DeliveryRepository>((ref) {
  DeliveryDatasource datasource = ref.watch(deliveryDatasourceProvider);
  return DeliveryRepositoryImpl(datasource: datasource);
});

// Like services.AddSingleton<BookingFormController>()
final bookingFormProvider = StateNotifierProvider<BookingFormController, BookingFormState>((ref) {
  DeliveryRepository repository = ref.watch(deliveryRepositoryProvider);
  return BookingFormController(repository: repository, ref: ref);
});
```

### Pattern: Responsive Scaffold (like CSS media queries)

```dart
class ResponsiveScaffold extends StatelessWidget {
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    
    if (width >= 1024) {
      return _buildDesktopLayout();  // Side rail + constrained content
    } else if (width >= 600) {
      return _buildTabletLayout();   // Side rail (icons only)
    } else {
      return _buildMobileLayout();   // Bottom navigation bar
    }
  }
}
```

---

## 6. Firestore Data Model

### Collections

```
users/
  └── {userId}/
      ├── email: "user@example.com"
      ├── name: "John Doe"
      ├── phone: "+923001234567"
      ├── role: "customer" | "rider"
      └── createdAt: Timestamp

deliveries/
  └── {deliveryId}/
      ├── customerId: "user_uid"
      ├── customerName: "John Doe"
      ├── riderId: "rider_uid" | null
      ├── riderName: "Ahmed Khan" | null
      ├── pickupLocation: { address, latitude, longitude }
      ├── dropoffLocation: { address, latitude, longitude }
      ├── packageDescription: "Documents"
      ├── status: "pending" | "accepted" | "picked_up" | "in_transit" | "delivered" | "cancelled"
      ├── distanceKm: 3.2
      ├── price: 95.0
      ├── riderLocation: { latitude, longitude, timestamp } | null
      ├── createdAt: Timestamp
      └── updatedAt: Timestamp | null
```

### Real-Time Streams

When a rider accepts a delivery:
1. Rider app writes `status: "accepted"` + `riderId` to Firestore
2. Customer's `customerDeliveriesProvider` stream fires automatically
3. Customer's UI updates to show "Accepted" status
4. No polling, no WebSockets, no manual refresh — Firestore handles it

---

## 7. Interview Talking Points

### When asked "Why Flutter?"
> Single codebase for 5 platforms. The responsive scaffold means the same widget tree renders as a mobile app with bottom nav, a tablet with side rail, and a desktop app with labeled navigation — no platform-specific code.

### When asked "Why Riverpod?"
> Compile-time safety and testability. Unlike Provider, Riverpod doesn't depend on BuildContext, so providers are plain Dart objects that can be unit tested without widget tests. The StateNotifier pattern is identical to MVVM's ObservableObject in C#.

### When asked "Why Clean Architecture?"
> Each feature is self-contained. The domain layer has zero framework dependencies — pure Dart. If we swap Firestore for Supabase, only the datasource layer changes. The repository interface acts as a contract between business logic and infrastructure.

### When asked "How do you handle errors?"
> Every async operation returns `Either<Failure, T>` instead of throwing exceptions. The UI is forced to handle both success and failure cases explicitly. Failure objects carry typed error codes that map to user-friendly messages.

### When asked "How does real-time tracking work?"
> The rider's LocationService streams GPS updates every 50 meters and writes them to Firestore. The customer's tracking screen subscribes to the same document and gets push updates. Google Maps re-renders the rider marker on each update.

---

## 8. File Navigation Cheat Sheet

| I want to change... | Go to... |
|---|---|
| App colors | `app/theme/app_colors.dart` |
| Spacing/radii | `app/theme/app_dimensions.dart` |
| Route definitions | `app/router/app_router.dart` |
| Auth redirect logic | `app/router/app_router.dart` → `redirect` function |
| Login screen UI | `features/auth/presentation/screens/login_screen.dart` |
| Login business logic | `features/auth/presentation/providers/auth_providers.dart` |
| Firebase Auth calls | `features/auth/data/datasources/auth_datasource.dart` |
| Booking form logic | `features/delivery/presentation/providers/delivery_providers.dart` |
| Price calculation | `features/delivery/presentation/providers/price_calculator.dart` |
| Address search UI | `features/delivery/presentation/widgets/address_search_field.dart` |
| Rider accept/reject | `features/rider/presentation/providers/rider_providers.dart` |
| Map widget | `core/widgets/delivery_map_widget.dart` |
| GPS tracking | `core/services/location_service.dart` |
| Responsive breakpoints | `core/layout/app_breakpoints.dart` |
| Navigation shell | `features/home/presentation/screens/home_shell_screen.dart` |
| Pricing constants | `core/constants/app_constants.dart` |

---

*This document is your single reference for understanding every architectural decision in A.M.U Couriers. Read it before any interview where you'll discuss this project.*
