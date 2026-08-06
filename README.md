# E-Commerce Flutter App

A Flutter e-commerce browsing app built with Clean Architecture, Riverpod, and go_router.

## Features
- [x] Clean Architecture (data/domain/presentation layers)
- [x] Centralized error handling (Result pattern)
- [x] Dio network client with pagination support
- [ ] Product listing with infinite scroll pagination
- [ ] Product search and category filtering
- [ ] Shopping cart with persistent local storage
- [ ] Dark mode support

## Architecture

This project follows Clean Architecture with a feature-first folder structure:
lib/
   core/
        network/ - Dio client configuration
        errors/ - Failure and Result sealed classes
        router/ - go_router configuration
        theme/ - App theming
  features/
        products/
                data/ - Models, repository implementations
                domain/ - Entities, repository interfaces
                presentation/ - Screens, Riverpod providers
        cart/
                data/
                domain/
                presentation/
## Tech Stack
- **State Management:** Riverpod (AsyncNotifierProvider, NotifierProvider)
- **Networking:** Dio
- **Routing:** go_router (StatefulShellRoute for persistent bottom navigation)
- **Local Storage:** SharedPreferences
- **API:** [DummyJSON](https://dummyjson.com)

## Getting Started

```bash
flutter pub get
flutter run
```