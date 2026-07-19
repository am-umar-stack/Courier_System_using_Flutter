# A.M.U Couriers

### A production-ready, cross-platform courier delivery system built with Flutter

Book on-demand deliveries. Track riders in real time. Earn money on your own schedule. One codebase ships to **Android, iOS, Web, Windows, and macOS** — each with layouts designed for its form factor, not a stretched phone screen.

<p align="center">
  <img src="https://placehold.co/1200x400/1A73E8/FFFFFF?text=A.M.U+Couriers+%E2%80%94+Deliver+Anything%2C+Anywhere&font=raleway" alt="A.M.U Couriers Banner" width="100%"/>
</p>

---

## 📱 Screenshots

### Mobile

<p align="center">
  <img src="https://placehold.co/280x560/1A73E8/FFFFFF?text=Login+Screen&font=raleway" alt="Login" width="22%"/>
  &nbsp;
  <img src="https://placehold.co/280x560/00BFA5/FFFFFF?text=Book+Delivery&font=raleway" alt="Booking" width="22%"/>
  &nbsp;
  <img src="https://placehold.co/280x560/0D47A1/FFFFFF?text=Live+Tracking&font=raleway" alt="Tracking" width="22%"/>
  &nbsp;
  <img src="https://placehold.co/280x560/FF6D00/FFFFFF?text=Rider+Dashboard&font=raleway" alt="Rider" width="22%"/>
</p>

### Tablet & Desktop

<p align="center">
  <img src="https://placehold.co/900x560/202124/FFFFFF?text=Desktop+%E2%80%94+Rider+Dashboard+with+Side+Navigation&font=raleway" alt="Desktop Dashboard" width="100%"/>
</p>

### Web

<p align="center">
  <img src="https://placehold.co/900x500/F8F9FA/202124?text=Web+%E2%80%94+Customer+Booking+Flow&font=raleway" alt="Web Booking" width="100%"/>
</p>

---

## ✨ Features

### Customer App

| Feature | Description |
|---|---|
| **Email Authentication** | Sign up and sign in with email/password via Firebase Auth |
| **Address Search** | Real-time geocoding — type an address, get coordinates and formatted suggestions |
| **Price Estimation** | Dynamic pricing using the Haversine formula for accurate distance calculation |
| **Book Delivery** | Create a delivery request stored in Firestore with pickup, drop-off, and package info |
| **Delivery History** | Real-time stream of past and active deliveries with status color coding |
| **Live Tracking** | Google Maps view showing pickup, drop-off, and rider markers with a status progress bar |
| **Status Updates** | Real-time progress: Accepted → Picked Up → In Transit → Delivered |
| **Profile Management** | View account info, role badge, and sign out |
| **Responsive Layout** | Bottom nav on mobile, side rail on tablet, labeled rail on desktop |

### Rider App

| Feature | Description |
|---|---|
| **Online/Offline Toggle** | Control availability for new delivery requests with a gradient status banner |
| **Pending Requests** | Real-time stream of unassigned delivery requests with price and distance |
| **Accept / Reject** | Claim a delivery (assigns rider ID) or pass it to other riders |
| **Status Progression** | Tap-through flow: Accept → Pick Up → Start → Deliver with dynamic action buttons |
| **Active Deliveries** | Dedicated screen for in-progress jobs filtered by rider ID |
| **Earnings Dashboard** | Total earnings, delivery count, average per delivery, and recent completed list |
| **GPS Tracking** | Background location updates written to Firestore every 50 meters |
| **Push Notifications** | Firebase Cloud Messaging integration for status change alerts |
| **Responsive Layout** | 4-tab navigation: Dashboard, Active, Earnings, Profile |

### Cross-Cutting

- **Material 3 Theming** — Full light/dark mode with custom design tokens
- **3-Tier Responsive System** — Mobile (< 600px), Tablet (600–1024px), Desktop (> 1024px)
- **Result Types** — `Either<Failure, T>` for explicit error handling (no thrown exceptions)
- **Shimmer Loading** — Skeleton placeholders for all loading states
- **Animated Transitions** — Entry animations via `flutter_animate`
- **Form Validation** — Real-time validation on all input fields
- **Auth Guards** — GoRouter redirect logic protects all authenticated routes

---

## 🛠 Tech Stack & Architecture

### Frontend

| Layer | Technology | Purpose |
|---|---|---|
| **Framework** | Flutter 3.22+ | Cross-platform UI toolkit |
| **Language** | Dart 3.4+ | Type-safe, AOT-compiled |
| **State Management** | Riverpod | Compile-time safe providers with `StateNotifier` |
| **Routing** | GoRouter | Declarative routing with auth guards and deep linking |
| **Maps** | google_maps_flutter | Live tracking and route visualization |
| **Geocoding** | geocoding + geolocator | Address search and GPS tracking |
| **Animations** | flutter_animate + shimmer | Entry animations and loading skeletons |
| **Typography** | google_fonts (Inter) | Clean, professional type system |
| **Error Handling** | fpdart (`Either`) | Functional Result types instead of exceptions |

### Backend (Firebase)

| Service | Purpose |
|---|---|
| **Firebase Auth** | Email/password authentication with user session management |
| **Cloud Firestore** | Real-time NoSQL database with stream subscriptions |
| **Firebase Cloud Messaging** | Push notifications for delivery status updates |
| **Cloud Functions** | Server-side logic for notification dispatch (deployment-ready) |

### Architecture: Feature-First Clean Architecture

```
feature/
├── data/              → Firestore calls, DTOs, repository implementations
│   ├── datasources/   → Direct database access (Firebase SDK calls)
│   ├── models/        → Serialization (Firestore ↔ Dart objects)
│   └── repositories/  → Implements domain interfaces
├── domain/            → Pure business logic, zero framework dependencies
│   ├── entities/      → Immutable domain objects
│   └── repositories/  → Abstract interfaces (dependency inversion)
└── presentation/      → UI and state management
    ├── providers/     → Riverpod StateNotifiers and StreamProviders
    ├── screens/       → Full-page widgets
    └── widgets/       → Reusable UI components
```

**Data flow:** `UI → Provider (StateNotifier) → Repository → Datasource → Firestore`

---

## 📂 Project Structure

```
lib/
├── main.dart                        # Entry point, Firebase init, platform config
│
├── app/
│   ├── app.dart                     # MaterialApp.router wrapper
│   ├── router/
│   │   └── app_router.dart          # GoRouter with auth guards & ShellRoute
│   └── theme/
│       ├── app_colors.dart          # Semantic color palette (light/dark)
│       ├── app_dimensions.dart      # Spacing, radii, elevations (4-pt grid)
│       ├── app_text_styles.dart     # Inter font typography scale
│       └── app_theme.dart           # Full Material 3 theme configuration
│
├── core/
│   ├── constants/
│   │   └── app_constants.dart       # Collection names, pricing, app metadata
│   ├── extensions/
│   │   └── context_extensions.dart  # BuildContext & String helpers
│   ├── layout/
│   │   ├── app_breakpoints.dart     # Responsive breakpoint constants
│   │   ├── responsive_layout.dart   # Builder widget for adaptive content
│   │   └── responsive_scaffold.dart # Adaptive nav (bottom bar / rail / drawer)
│   ├── services/
│   │   ├── location_service.dart    # GPS tracking with Firestore writes
│   │   └── notification_service.dart # FCM integration
│   ├── utils/
│   │   └── result.dart              # Either<Failure, T> type aliases
│   └── widgets/
│       ├── async_button.dart        # Button with loading state
│       ├── delivery_map_widget.dart # Google Maps with markers & legend
│       ├── error_view.dart          # Error & empty state screens
│       └── shimmer_loading.dart     # Skeleton loading placeholders
│
└── features/
    ├── auth/                        # Authentication (11 files)
    │   ├── data/                    # Firebase Auth datasource, UserModel, RepoImpl
    │   ├── domain/                  # UserEntity, AuthRepository interface
    │   └── presentation/            # Providers, login/signup/role screens
    │
    ├── delivery/                    # Customer booking flow (13 files)
    │   ├── data/                    # Firestore datasource, DeliveryModel, RepoImpl
    │   ├── domain/                  # DeliveryEntity, LocationValue, DeliveryStatus
    │   └── presentation/            # Providers, PriceCalculator, booking screens
    │
    ├── home/                        # Responsive navigation shell (1 file)
    │   └── presentation/            # HomeShellScreen (role-aware nav)
    │
    ├── profile/                     # User profile (1 file)
    │   └── presentation/            # ProfileScreen with sign out
    │
    ├── rider/                       # Rider fulfillment flow (5 files)
    │   └── presentation/            # RiderController, dashboard, active, earnings
    │
    ├── splash/                      # Launch screen (1 file)
    │   └── presentation/            # Animated SplashScreen with auth check
    │
    └── tracking/                    # Live delivery tracking (1 file)
        └── presentation/            # TrackingScreen with Google Maps
```

**Total: 52 Dart files** across 7 features.

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.22 or later
- [Firebase CLI](https://firebase.google.com/docs/cli)
- A Firebase project with **Authentication** (Email/Password) and **Firestore** enabled
- A [Google Maps API key](https://developers.google.com/maps/documentation/javascript/get-api-key)

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/a.m.u-couriers.git
cd a.m.u-couriers
```

### 2. Configure Environment

Create a `.env` file in the project root:

```env
GOOGLE_MAPS_API_KEY=your_google_maps_api_key_here
FIREBASE_PROJECT_ID=your_firebase_project_id
```

### 3. Configure Firebase

```bash
# Install FlutterFire CLI (one-time)
dart pub global activate flutterfire_cli

# Connect to your Firebase project
flutterfire configure
```

This generates `lib/firebase_options.dart` and platform-specific config files (`google-services.json`, `GoogleService-Info.plist`).

### 4. Install Dependencies & Generate Code

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 5. Run the App

```bash
# Mobile (Android / iOS)
flutter run

# Web
flutter run -d chrome

# Desktop
flutter run -d windows   # Windows
flutter run -d macos     # macOS
flutter run -d linux     # Linux
```

### 6. Firestore Security Rules

Deploy these rules to your Firestore database:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /deliveries/{deliveryId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update: if request.auth != null;
    }
  }
}
```

---

## 📐 Responsive Layout System

The app uses a custom responsive scaffold that automatically adapts navigation patterns based on screen width:

| Breakpoint | Width | Navigation Pattern |
|---|---|---|
| **Mobile** | < 600px | Bottom navigation bar |
| **Tablet** | 600–1024px | Navigation rail (icons only) |
| **Desktop** | > 1024px | Navigation rail with labels, content constrained to 1200px |

No platform-specific code required. The same widget tree renders correctly on every form factor.

---

## 🧪 Testing Accounts

After setting up Firebase, create two test accounts:

| Role | Email | Purpose |
|---|---|---|
| Customer | `customer@test.com` | Book deliveries, track riders |
| Rider | `rider@test.com` | Accept requests, update status |

Sign up both accounts through the app, then select the appropriate role on the role selection screen.

---

## 🗂 Key Design Decisions

| Decision | Rationale |
|---|---|
| **Riverpod over Provider** | Compile-time safety, no `BuildContext` dependency, better testability |
| **GoRouter over Navigator 2.0** | Declarative routes, built-in auth guards, deep linking support |
| **Result types over exceptions** | Forces explicit error handling, no uncaught exceptions in business logic |
| **Feature-first over layer-first** | Each feature is self-contained; adding or removing a feature = one folder |
| **Haversine formula** | Accurate straight-line distance without external API dependency |
| **ShellRoute for navigation** | Single responsive scaffold wraps all authenticated routes |

---

## 📄 License

MIT
