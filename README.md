# 🚀 Digidentity - iOS App

Welcome to the **Digidentity** iOS application repository. This project implements a modern architecture using the **Coordinator Pattern** for navigation and **MVVM (Model-View-ViewModel)** for business logic, coupled with **SwiftData** for local data persistence.

---

## 🎯 Key Architecture and Patterns

The project is designed to be modular, loosely coupled, and thread-safe:

- **Coordinator Pattern:** Manages all application navigation and flow.
- **MVVM (Model-View-ViewModel):** Separates presentation logic (ViewModels with `@MainActor`) from the views (UIKit `UIViewController`).
- **Swift Concurrency (`actor`):** The persistence repository is implemented as an **`actor`** to guarantee thread isolation during SwiftData operations.
- **Triple-Model Mapping:** Ensures clear separation between data layers: `ItemDTO` (Network), **`Item`** (Domain), and `ItemEntity` (Persistence).

---

## 📁 Project Structure

The project structure is organized around features and core infrastructure:

```
Digidentity/
├── Digidentity/
│ ├── AppDelegate.swift
│ ├── SceneDelegate.swift
│ │
│ ├── Coordinator/
│ │ ├── AppCoordinator.swift
│ │ └── CatalogCoordinator.swift
│ │
│ ├── Data/
│ │ ├── APIs/ # Characteristic of the API
│ │ ├── DTOs/ # ItemDTO (Networking)
│ │ ├── Local/ # Keychain (Storage) / DB Entities
│ │ ├── Remote/ # Networking
│ │ └── Repositories/ # Implementations
│ │
│ ├── Domain/
│ │ ├── Entities/ # Item
│ │ ├── Repositories/ # Protocols
│ │ └── UseCases/ # Business interfaces
│ │
│ └── Presentation/
│   └── Catalog/ # (Feature)
│   │ ├── CatalogBuilder.swift
│   │ ├── CatalogViewController.swift
│   │ └── CatalogViewModel.swift/ # (with @MainActor)
│   │ └── Views / # Child Views
│   ├── ItemDetail/
│   │ ├── ItemDetailBuilder.swift
│   │ ├── ItemDetailViewController.swift
│   │ └── ItemDetailViewModel.swift/ # (with @MainActor)
│   └── Shared/ # ImageLoader
│
└── DigidentityTests/ # Unit Tests
```

---

## ⚙️ Local Environment Setup

The API token is crucial for the application to function and is handled securely via **Build Configurations** (`.xcconfig`). To run the project locally, you must configure the token variable.

### 1. Requirements

- The **`Secrets.xcconfig`** file must be present in your project but **must be ignored by Git** (via `.gitignore`).

### 2. Configure `Secrets.xcconfig`

This file defines the local value for the secret. **Crucially, the value must be defined without surrounding quotes** to prevent double-quoting issues at runtime.

**`Secrets.xcconfig` Content:**

```xcconfig
// 🚨 IMPORTANT: This file must be added to your .gitignore.

// Define the variable for local use. No quotes are needed around the token value.
CI_API_TOKEN_SECRET = [YOUR_LOCAL_API_TOKEN_HERE]

// Assign this variable to the Build Setting that Info.plist reads.
API_TOKEN = $(CI_API_TOKEN_SECRET)
```

### 3. Link Secrets.xcconfig to Target

Ensure the project knows to read this configuration file during the build process:

1.  Navigate to Project > Info tab.
2.  In the Configurations section, select Secrets.xcconfig for your main Target (Digidentity) under both Debug and Release.

### 4. Configure `Info.plist` (The Bridge)

The `Info.plist` file acts as the bridge that injects the variable into the app bundle at runtime. You must explicitly tell the `Info.plist` to read the build variable.

Add the following entry to your `Info.plist` file:

| Key         | Type   | Value              |
| :---------- | :----- | :----------------- |
| `API_TOKEN` | String | **`$(API_TOKEN)`** |

### 5. Final Verification Step

Verify that the `Secrets.xcconfig` file is correctly **linked** to the **Debug** and **Release** configurations of your main Target.

1.  Navigate to **Project** > **Info** tab.
2.  In the **Configurations** section, verify that **`Secrets.xcconfig`** is selected for your `Digidentity` Target under both `Debug` and `Release`.
