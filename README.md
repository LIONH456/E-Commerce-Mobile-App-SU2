# Shopapay - E-Commerce Mobile Application

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.8.1+-0175C2?logo=dart&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

A comprehensive, feature-rich e-commerce mobile application built with Flutter.

[Features](#-features) • [Installation](#-installation) • [Documentation](#-documentation) • [API Integration](#-api-integration)

</div>

---

## 📱 About

**Shopapay** is a modern e-commerce mobile application that provides a complete shopping experience. The app features product browsing, shopping cart management, user authentication, payment processing, and much more. Built with Flutter for cross-platform compatibility (Android, iOS, Web, Desktop).

### Key Highlights
- 🌍 **Multi-language Support:** English and Khmer
- 🎨 **Theme Support:** Light and Dark modes
- 🛒 **Full Shopping Experience:** Browse, cart, checkout, and payments
- 🔐 **Secure Authentication:** Email/password and social login
- 📍 **Location Services:** Google Maps integration for delivery
- ⭐ **Reviews & Ratings:** Community-driven product reviews

---

## ✨ Features

### Core Features
- ✅ User Authentication (Email, Google, Facebook, Apple)
- ✅ Product Browsing & Search
- ✅ Shopping Cart & Checkout
- ✅ User Profile Management
- ✅ Payment Methods Integration
- ✅ Product Reviews & Ratings
- ✅ Favorites/Wishlist
- ✅ Notifications & Messaging
- ✅ Help Center & Support
- ✅ Location & Delivery Address Management
- ✅ Dark/Light Theme
- ✅ Multi-language Support (i18n)

### Technical Features
- 🏗️ **BLoC Architecture:** Clean, testable, and maintainable code
- 🔌 **REST API Integration:** Products and Categories from backend
- 🗺️ **Google Maps:** Location selection and geocoding
- 💾 **Local Storage:** SharedPreferences for user data
- 🎯 **State Management:** Flutter BLoC with Cubit
- 🧭 **Navigation:** go_router for type-safe routing

---

## 🚀 Installation

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK (included with Flutter)
- Android Studio / VS Code / IntelliJ IDEA
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd e_commerce_final
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Platform-Specific

- **Android:** `flutter run` (ensure Android emulator/device is connected)
- **iOS:** `flutter run` (requires macOS and Xcode)
- **Web:** `flutter run -d chrome`

---

## 🔌 API Integration

The application integrates with a REST API for products and categories:

### API Endpoints

- **Products API:** `https://su12ecommerce.lionh456.uk/api/products/`
- **Categories API:** `https://su12ecommerce.lionh456.uk/api/categories/`

### API Features
- ✅ Pagination support
- ✅ Automatic data fetching
- ✅ Error handling
- ✅ Loading states
- ✅ Image URL resolution

The API integration is fully implemented in `lib/features/home/presentation/cubits/home_page_cubit/`.

---

## 📚 Documentation

For detailed documentation, please refer to:

- **[Complete Project Documentation](docs/PROJECT_DOCUMENTATION.md)** - Comprehensive guide covering:
  - Detailed feature descriptions
  - Architecture and design patterns
  - API integration details
  - Dependencies and technologies
  - Setup instructions
  - Development guidelines

- **[Project Overview](docs/project_overview.md)** - Quick overview of the project

---

## 🛠️ Technologies & Dependencies

### Core Technologies
- **Flutter** - Cross-platform framework
- **Dart** - Programming language
- **BLoC** - State management pattern

### Key Dependencies
- `flutter_bloc` - State management
- `dio` - HTTP client
- `go_router` - Navigation
- `shared_preferences` - Local storage
- `google_maps_flutter` - Maps integration
- `geolocator` - Location services
- `intl` - Internationalization
- And 20+ more packages...

See `pubspec.yaml` for the complete list of dependencies.

---

## 📁 Project Structure

```
lib/
├── core/                    # Core utilities
│   └── utils/              # Constants, themes, helpers
├── features/               # Feature modules
│   ├── auth/              # Authentication
│   ├── home/               # Products & categories
│   ├── my_cart/            # Shopping cart
│   ├── profile/            # User profile
│   └── ...                 # Other features
├── generated/              # Generated code
└── l10n/                   # Localization files
```

---

## 🎨 Screenshots

[Add screenshots of your app here]

---

## 🔧 Configuration

### API Configuration
The API base URL is configured in `lib/core/utils/constant.dart`:
```dart
const String kApiBaseUrl = 'https://su12ecommerce.lionh456.uk/api/';
```

### Theme Configuration
Theme colors and styles are defined in `lib/core/utils/app_theme.dart`.

### Localization
Localization files are in `lib/l10n/` directory. Supported languages:
- English (`en`)
- Arabic (`ar`)
- French (`fr`)

---

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

---

## 📝 Development

### Code Style
- Follow Flutter/Dart style guide
- Use `flutter_lints` for code quality
- Maintain consistent naming conventions

### Git Workflow
- Create feature branches for new features
- Write meaningful commit messages
- Code review before merging

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


---

## 👥 Authors

- Mean Chanbora
- Ho Jun Hong

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- All package maintainers
- API provider: `https://su12ecommerce.lionh456.uk`

---

## 📞 Support

For support, email junhongho25@gmail.com or use the Help Center in the app.

---

<div align="center">

**Made with ❤️ using Flutter**

</div>
