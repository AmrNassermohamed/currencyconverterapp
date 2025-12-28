Currency Converter App (Flutter)

A Flutter application that demonstrates a complete Currency Converter solution
using Clean Architecture and BLoC pattern.

==================================================

FEATURES

1. Supported Currencies
- Fetches supported currencies from Currency Converter API
- Displays currencies with country flags
- Caches currencies locally after first load
- Loads cached data on next app launches (offline support)

2. Currency Converter
- Select source currency and target currency
- Enter amount to convert
- Fetches conversion rate and calculates result

3. Historical Rates
- Displays historical rates for the last 7 days
- Supports selecting any currency pair

==================================================

TECH STACK

- Flutter / Dart
- State Management: BLoC & Cubit
- Architecture: Clean Architecture
- Dependency Injection: GetIt
- Networking: Dio
- Local Database: Hive
- Testing: flutter_test, bloc_test, mocktail
- Country Flags: FlagCDN

==================================================

API INFORMATION

Currency Converter API (CurrConv v8)

Base URL:
https://free.currconv.com

Endpoints:
- /api/v8/currencies
- /api/v8/convert
- /api/v8/countries

NOTE:
CurrConv requires an API key to access live data.

==================================================

HOW TO RUN THE PROJECT

1. Install dependencies
flutter pub get

2. Run with API key
flutter run --dart-define=API_KEY=YOUR_API_KEY

3. Run in mock mode (no API required)
flutter run --dart-define=MOCK=true

Mock mode allows running the app without hitting the real API
and is useful for testing and UI evaluation.

==================================================

PROJECT STRUCTURE (CLEAN ARCHITECTURE)

lib/
 ├── core/
 │   ├── di/
 │   ├── network/
 │   └── utils/
 │
 └── features/
     └── currency/
         ├── data/
         │   ├── datasources/
         │   ├── models/
         │   └── repositories/
         │
         ├── domain/
         │   ├── entities/
         │   ├── repositories/
         │   └── usecases/
         │
         └── presentation/
             ├── bloc/
             ├── pages/
             └── widgets/

==================================================

ARCHITECTURE OVERVIEW

The project follows Clean Architecture principles:

- Presentation Layer
  UI widgets and BLoC/Cubit for state management

- Domain Layer
  Business logic, entities, and use cases

- Data Layer
  Repository implementations and data sources
  (remote API and local Hive cache)

This separation improves maintainability, scalability, and testability.

==================================================

STATE MANAGEMENT

BLoC pattern is used because:
- Clear separation between UI and business logic
- Predictable state transitions
- Easy unit testing
- Scales well for medium and large applications

==================================================

DEPENDENCY INJECTION

GetIt is used for dependency injection to:
- Decouple object creation from business logic
- Keep constructors clean
- Simplify testing and mocking

==================================================

LOCAL DATABASE

Hive is used for:
- Fast local caching
- Offline support
- Caching supported currencies and history data

==================================================

FLAGS

Country flags are loaded using:
https://flagcdn.com/

==================================================

TESTING

Test Coverage:
- Domain use cases
- Repository behavior
- BLoC and Cubit state transitions

Test Structure:
test/
 ├── helpers/
 └── features/
     └── currency/
         ├── data/
         ├── domain/
         └── presentation/

Run tests:
flutter test

==================================================

NOTES & ASSUMPTIONS

- API key is required for live API requests
- Mock mode is provided for evaluation without API key
- Currency-country mapping is simplified using country codes

==================================================

FUTURE IMPROVEMENTS

- Improve country-to-currency mapping
- Cache historical data with expiration
- Add pagination for large currency lists
- Improve error handling and retry logic

==================================================

AUTHOR

Flutter Currency Converter App
Developed as a technical assessment using best practices
in Flutter, Clean Architecture, BLoC, and Testing.
