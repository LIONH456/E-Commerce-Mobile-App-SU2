# Shopapay - E-Commerce Mobile Application

## Project Overview

Shopapay is an e-commerce mobile app built with Flutter. It supports product browsing, cart management, user authentication, localization, and theme preferences. The codebase follows a feature-based structure and uses BLoC/Cubit for state management.

Key points
- Platforms: Android, iOS, Web, Desktop
- Flutter SDK: 3.8.x
- State management: flutter_bloc (Cubit)
- Networking: Dio
- Localization: intl + intl_utils (ARB files under `lib/l10n`)
- Persistence: SharedPreferences (CachedHelper wrapper)

## Recent Enhancements (implemented)
- Prevented Locale null crash at startup (safe default language)
- Fixed malformed ARB file and regenerated localization
- Replaced hardcoded login/register strings with localized keys
- Added password visibility toggle (eye icon) in login/register
- Persist user profile after login so authenticated users skip onboarding
- Cached products and categories (JSON in SharedPreferences)
- Product details gallery shows all images (portrait aspect) with loading/error handling
- Settings: language-change confirmation dialog and app restart via Phoenix.rebirth()

## Project Structure (high level)
- `lib/core` — shared utilities, constants, widgets
- `lib/features` — feature folders (auth, home, profile, cart, onboarding, splash, etc.)
- `lib/features/*/data/models` — data models (ProductModel, CategoryModel)
- `lib/features/*/presentation/cubit` — Cubits for state
- `lib/generated` — generated localization code
- `lib/l10n` — ARB translation files

## Important Implementation Details

- Localization
  - ARB files: `intl_en.arb`, `intl_ar.arb`, `intl_km.arb`
  - Use `dart run intl_utils:generate` after ARB edits

- Caching
  - Cached keys: product and category cache keys in `HomePageCubit`
  - Models implement `toJson()`/`fromJson()` for persistence
  - On startup, cubit loads cache then fetches fresh data

- Auth
  - AuthCubit saves user profile to cache after successful login
  - Splash checks auth state to decide whether to skip onboarding

- Product Gallery
  - PageView-based carousel shows all images
  - Portrait aspect ratio and network loading/error placeholders

## API

- Base URL: `https://su12ecommerce.lionh456.uk/api/`
- Media base: `https://su12ecommerce.lionh456.uk/`
- HTTP client: Dio with timeout and error mapping

Note: If you see host lookup failures on mobile (e.g., "Failed host lookup"), that is typically environment/network-related (emulator DNS, VPN, or firewall). See troubleshooting below.

## Troubleshooting: Host lookup / network failures on mobile

Common causes and checks:
- Emulator DNS: Android emulator may not resolve certain hostnames. Test on a real device or ensure emulator DNS is correct.
- Use `adb shell` networking checks (or open the host URL in the device browser).
- If backend is on localhost, use `10.0.2.2` (Android emulator) or map correctly for iOS simulator.
- Check VPN/proxy or corporate firewall affecting DNS resolution.

If you want, I can guide you through collecting the device logs (flutter run on device) and interpreting the stack trace.

## Next recommended actions

1. Run `flutter analyze` and `flutter test` locally to catch remaining issues.
2. Verify flows on a physical device: login, caching, product gallery, language change.
3. Improve credential security: avoid storing plaintext passwords in SharedPreferences — use secure storage or store tokens only.
4. Add a UI action to force-refresh cache (optional).

## How to regenerate localization

1. Update ARB files under `lib/l10n`
2. Run: `dart run intl_utils:generate`
3. Rebuild the app

## Contact / Maintainers

Maintained by the development team in this repository. Open an issue or PR for changes.

---

Last updated: 2025-11-13
# Shopapay - E-Commerce Mobile Application

## 📱 Project Overview

**Shopapay** is a comprehensive, feature-rich e-commerce mobile application built with Flutter. The application provides a complete shopping experience with product browsing, cart management, user authentication, payment processing, and much more. The app is designed to support multiple languages (English, Arabic, French) and offers both light and dark themes for enhanced user experience.

### Project Information
- **Project Name:** Shopapay (e_commerce_final)
- **Platform:** Flutter (Cross-platform: Android, iOS, Web, Desktop)
- **Flutter SDK Version:** ^3.8.1
- **Primary Language:** Dart
- **Architecture Pattern:** BLoC (Business Logic Component) with Cubit

---

## 🎯 Core Features

### 1. **User Authentication & Onboarding**
- **Onboarding Flow:** Interactive carousel introducing app features
  - "Stay Ahead of the Latest Trends"
  - "Effortless Shopping Experience"
  - "Discover Endless Shopping Possibilities"
- **Authentication Methods:**
  - Email/Password sign-in and sign-up
  - Social media authentication:
    - Google Sign-In
    - Facebook Sign-In
    - Apple Sign-In
  - Password reset functionality
  - OTP (One-Time Password) verification
  - Forgot password flow with email verification

### 2. **Product Browsing & Discovery**
- **Product Catalog:**
  - Browse products from API integration
  - Paginated product listing
  - Product categories with filtering
  - Product search functionality
  - Sort and filter options
- **Product Details:**
  - High-resolution product images with gallery
  - Detailed product descriptions
  - Price comparison (original vs. discounted price)
  - Product availability status
  - SKU and quantity information
  - Product tags
- **Categories:**
  - Women's products
  - Men's products
  - Kids' products
  - Dynamic category loading from API

### 3. **Shopping Cart & Checkout**
- **Cart Management:**
  - Add/remove products
  - Quantity adjustment
  - Promo code application
  - Subtotal, delivery, and total calculations
- **Checkout Process:**
  - Delivery address selection
  - Address management (add/edit/delete)
  - Delivery instructions
  - Payment method selection
  - Order summary review

### 4. **User Profile & Settings**
- **Profile Management:**
  - Edit profile information
  - Profile picture management
  - Account settings
- **Preferences:**
  - Language selection (English, Arabic, French)
  - Dark/Light theme toggle
  - Notification preferences
- **Account Features:**
  - My Favorites/Wishlist
  - Order history
  - Payment methods management
  - Help Center
  - Contact Us
  - Terms and Conditions
  - About App

### 5. **Payment Integration**
- **Payment Methods:**
  - Credit/Debit card support
  - Card number, holder name, expiry date, CVV input
  - Add/remove payment cards
  - PayPal integration (UI ready)
  - MasterCard support
- **Payment Security:**
  - Secure card input forms
  - Card validation

### 6. **Location & Delivery Services**
- **Location Features:**
  - Current location detection
  - Google Maps integration
  - Address geocoding
  - Delivery address selection on map
  - Manual address entry
  - Delivery instructions

### 7. **Reviews & Ratings**
- **Product Reviews:**
  - Write product reviews
  - Star rating system (1-5 stars)
  - Review comments and feedback
  - View all reviews
  - Community-driven product ratings

### 8. **Notifications & Messaging**
- **Notification System:**
  - In-app notifications
  - Notification preferences
  - Notification history
- **Messaging:**
  - Chat interface
  - Customer support messaging
  - Message history

### 9. **Social Media Integration**
- Follow us on social media:
  - Facebook
  - Instagram
  - Twitter/X
  - WhatsApp
  - Website link

### 10. **Internationalization (i18n)**
- **Supported Languages:**
  - English (en)
  - Khmer (km)
- **RTL Support:** Full right-to-left layout support for Arabic
- **Localized Content:** All UI strings are localized

### 11. **Theme Support**
- **Light Mode:** Bright, clean interface
- **Dark Mode:** Eye-friendly dark theme
- **Theme Persistence:** User preference saved and restored

---

## 🏗️ Architecture & Design Patterns

### Architecture Pattern
The application follows the **BLoC (Business Logic Component)** architecture pattern using **Cubit** for state management. This ensures:
- Separation of concerns
- Testability
- Predictable state management
- Reactive UI updates

### Project Structure
```
lib/
├── core/                    # Core utilities and shared code
│   ├── utils/              # Constants, themes, helpers
│   └── ...
├── features/               # Feature-based modules
│   ├── auth/              # Authentication feature
│   ├── home/               # Home & products feature
│   ├── my_cart/            # Shopping cart feature
│   ├── profile/            # User profile feature
│   ├── favorites/          # Favorites feature
│   ├── notifications&messages/  # Notifications feature
│   ├── onboarding/         # Onboarding feature
│   ├── trending/           # Trending products
│   └── shared/             # Shared components
├── generated/              # Generated code (localization)
└── l10n/                   # Localization ARB files
```

### State Management
- **flutter_bloc:** Primary state management solution
- **Cubit:** Used for simpler state management (no events needed)
- **BlocObserver:** Custom observer for debugging and logging

### Navigation
- **go_router:** Modern, declarative routing solution
- Type-safe navigation
- Deep linking support
- Route guards for authentication

---

## 🔌 API Integration

### Base Configuration
- **API Base URL:** `https://su12ecommerce.lionh456.uk/api/`
- **Media Base URL:** `https://su12ecommerce.lionh456.uk/`
- **HTTP Client:** Dio (with timeout configuration)

### API Endpoints

#### 1. Products API
- **Endpoint:** `GET /api/products/`
- **Response Format:**
```json
{
  "count": 42,
  "next": "?page=2",
  "previous": null,
  "results": [
    {
      "id": "6910dc63aa194b51fb68f614",
      "name": "Regular Shirts",
      "slug": "regular-shirts",
      "description": "Regular shirts featuring long sleeves...",
      "price": 0.01,
      "compare_price": 12.99,
      "sku": "1322507351",
      "quantity": 100,
      "is_available": true,
      "category_id": "6910b13a0d02a5873809dd18",
      "tags": ["boy", "shirt"],
      "images": [
        "https://zandokh.com/image/catalog/products/..."
      ],
      "main_image": "https://zandokh.com/image/catalog/products/...",
      "created_at": "2025-11-09T18:24:35.999000",
      "updated_at": "2025-11-09T18:24:35.999000"
    }
  ]
}
```

**Features:**
- Pagination support (follows `next` cursor)
- Automatic pagination aggregation
- Media URL resolution (handles absolute and relative URLs)
- Discount calculation from `price` and `compare_price`

#### 2. Categories API
- **Endpoint:** `GET /api/categories/`
- **Response Format:**
```json
{
  "count": 10,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": "6910b13a0d02a5873809dd18",
      "name": "Shirts",
      "slug": "shirts",
      "description": "Category description",
      "image": "https://...",
      "created_at": "2025-11-09T18:24:35.999000",
      "updated_at": "2025-11-09T18:24:35.999000"
    }
  ]
}
```

**Features:**
- Pagination support
- Category filtering for products
- Image URL resolution

### API Implementation Details

#### Data Models
- **ProductModel:** Represents product data with all fields
- **CategoryModel:** Represents category data
- **ProductsModels:** Wrapper for paginated product responses

#### API Service Layer
- **HomePageCubit:** Handles product and category fetching
- **Pagination Logic:** Automatically fetches all pages
- **Error Handling:** Comprehensive error mapping and user-friendly messages
- **Loading States:** Separate loading states for products and categories

#### Media URL Resolution
The app includes a utility function (`resolveMediaUrl`) that:
- Handles absolute URLs (starts with `http`)
- Converts relative URLs to absolute URLs
- Handles missing/null image paths gracefully

---

## 📦 Dependencies & Technologies

### Core Dependencies

#### State Management & Architecture
- **flutter_bloc (^9.1.1):** BLoC pattern implementation for state management
- **get_it (^8.2.0):** Dependency injection container

#### Networking & API
- **dio (^5.9.0):** Powerful HTTP client for API calls
  - Request/response interceptors
  - Timeout configuration
  - Error handling

#### Navigation
- **go_router (^16.2.5):** Declarative routing solution
- **page_transition (^2.2.1):** Custom page transitions

#### Localization & Internationalization
- **intl (^0.20.2):** Internationalization and localization support
- **flutter_localization (^0.3.3):** Flutter localization package

#### UI Components & Design
- **flutter_svg (^2.2.1):** SVG image support
- **carousel_slider (^5.1.1):** Carousel/slider widgets
- **smooth_page_indicator (^1.2.1):** Page indicators for carousels
- **animations (^2.1.0):** Material motion animations
- **flutter_rating_bar (^4.0.1):** Star rating widget
- **flutter_conditional_rendering (^2.1.0):** Conditional widget rendering

#### Authentication & Social
- **google_sign_in (^7.2.0):** Google Sign-In integration
- **flutter_phoenix (^1.1.1):** App restart functionality (for theme/language changes)

#### Location & Maps
- **geolocator (^14.0.2):** Location services
- **google_maps_flutter (^2.13.1):** Google Maps integration
- **geocoding (^4.0.0):** Address geocoding (address ↔ coordinates)

#### Input & Forms
- **pinput (^5.0.2):** PIN/OTP input widget
- **otp_timer_button (^1.1.1):** OTP timer button

#### Persistence & Storage
- **shared_preferences (^2.5.3):** Key-value storage for user preferences
  - Theme preference
  - Language preference
  - Authentication tokens

#### Icons & Fonts
- **font_awesome_flutter (^10.9.1):** Font Awesome icons
- **cupertino_icons (^1.0.8):** iOS-style icons
- **Custom Fonts:** Poppins family, Hanimation Arabic

#### Development & Build Tools
- **flutter_native_splash (^2.4.6):** Native splash screen generation
- **icons_launcher (^3.0.3):** App icon generation
- **device_preview (^1.3.1):** Device preview for development

#### Testing
- **flutter_test:** Flutter testing framework (SDK)
- **flutter_lints (^5.0.0):** Linting rules

### Technology Stack Summary

| Category | Technologies |
|----------|-------------|
| **Framework** | Flutter 3.8.1+ |
| **Language** | Dart |
| **State Management** | BLoC (flutter_bloc) |
| **Networking** | Dio |
| **Navigation** | go_router |
| **Localization** | intl, flutter_localization |
| **Storage** | shared_preferences |
| **Maps** | Google Maps Flutter |
| **Location** | Geolocator, Geocoding |
| **UI Components** | Material Design, Custom Widgets |
| **Architecture** | Feature-based, BLoC pattern |

---

## 🛠️ Setup & Installation

### Prerequisites
1. **Flutter SDK:** Version 3.8.1 or higher
2. **Dart SDK:** Included with Flutter
3. **IDE:** VS Code, Android Studio, or IntelliJ IDEA
4. **Platform-specific:**
   - **Android:** Android Studio, Android SDK
   - **iOS:** Xcode (macOS only)
   - **Web:** Chrome/Edge browser

### Installation Steps

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd e_commerce_final
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Localization Files** (if needed)
   ```bash
   flutter pub run intl_utils:generate
   ```

4. **Run the Application**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- Minimum SDK: 21 (Android 5.0)
- Target SDK: Latest
- Configure `android/app/build.gradle` if needed

#### iOS
- Minimum iOS: 12.0
- Configure `ios/Runner.xcodeproj` if needed
- Run `pod install` in `ios/` directory

#### Web
- No additional setup required
- Run: `flutter run -d chrome`

---

## 📱 Key Screens & Features

### Main Screens
1. **Splash Screen:** App initialization
2. **Onboarding:** Feature introduction
3. **Welcome/Login:** Authentication entry
4. **Home:** Product catalog, categories, banners
5. **Product Details:** Product information, reviews, add to cart
6. **Shopping Cart:** Cart management, checkout
7. **Checkout:** Address, payment, order confirmation
8. **Profile:** User settings, preferences
9. **Favorites:** Saved products
10. **Notifications:** User notifications
11. **Help Center:** Support and FAQs
12. **Settings:** App configuration

### User Flows
- **New User:** Onboarding → Sign Up → Browse → Add to Cart → Checkout
- **Returning User:** Login → Browse → Add to Cart → Checkout
- **Profile Management:** Profile → Edit → Save
- **Address Management:** Profile → Addresses → Add/Edit → Save

---

## 🎨 Design System

### Color Scheme

#### Light Theme
- **Primary Color:** `#1D55F3` (Blue)
- **Secondary Color:** `#212121` (Dark Gray)
- **Tertiary Color:** `#616161` (Medium Gray)
- **Background:** White
- **Text:** Dark colors

#### Dark Theme
- **Primary Color:** `#246BFD` (Light Blue)
- **Secondary Color:** `#F7F7F7` (Light Gray)
- **Tertiary Color:** `#E8E8E8` (Very Light Gray)
- **Background:** `#2B2B2B` (Dark)
- **Text:** Light colors

### Typography
- **Primary Font:** Poppins (Latin scripts)
- **Arabic Font:** Hanimation Arabic Regular
- **Font Weights:** Regular, Medium, SemiBold, Bold, etc.

### UI Components
- Material Design 3 components
- Custom widgets for consistent styling
- Responsive layouts
- RTL support for Arabic

---

## 🔒 Security Features

1. **Authentication:**
   - Secure token storage (SharedPreferences)
   - OTP verification
   - Password reset flow

2. **Data Protection:**
   - Secure API communication (HTTPS)
   - Input validation
   - Error handling without exposing sensitive data

3. **Payment Security:**
   - Card input validation
   - Secure payment method storage (UI ready for backend integration)

---

## 🚀 Performance Optimizations

1. **Image Loading:**
   - Efficient image caching
   - Lazy loading for product lists
   - Optimized image URLs

2. **API Calls:**
   - Pagination to reduce initial load
   - Request timeouts
   - Error handling and retry logic

3. **State Management:**
   - Efficient state updates
   - Minimal rebuilds
   - BLoC pattern for predictable state

4. **Localization:**
   - Lazy loading of locale data
   - Efficient string lookups

---

## 📊 Project Statistics

- **Total Features:** 11 major feature modules
- **Supported Languages:** 3 (English, Arabic, French)
- **Theme Modes:** 2 (Light, Dark)
- **API Endpoints:** 2+ (Products, Categories)
- **Dependencies:** 30+ packages
- **Platform Support:** Android, iOS, Web, Desktop (Linux, macOS, Windows)

---

## 🔮 Future Enhancements

### Planned Features
1. **Payment Gateway Integration:**
   - Stripe integration
   - PayPal SDK integration
   - Secure payment processing

2. **Offline Support:**
   - Offline product caching
   - Persistent cart storage
   - Sync when online

3. **Analytics:**
   - User behavior tracking
   - Funnel analysis
   - Performance metrics

4. **Push Notifications:**
   - Order updates
   - Promotional notifications
   - Abandoned cart reminders

5. **Advanced Features:**
   - Product recommendations
   - Recently viewed products
   - Order tracking
   - Live chat support
   - Product comparison
   - Wishlist sharing

6. **Accessibility:**
   - Voice-over support
   - Larger text options
   - High contrast mode
   - Screen reader optimization

---

## 🐛 Known Issues & Limitations

1. **Payment Integration:** UI is ready but requires backend payment gateway integration
2. **Push Notifications:** Infrastructure ready, needs backend configuration
3. **Offline Mode:** Currently requires internet connection for product data
4. **Order History:** UI exists, needs backend API integration

---

## 📝 Development Guidelines

### Code Style
- Follow Flutter/Dart style guide
- Use `flutter_lints` for code quality
- Maintain consistent naming conventions

### Git Workflow
- Feature branches for new features
- Meaningful commit messages
- Code review before merging

### Testing
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for user flows

---

## 📞 Support & Contact

For issues, questions, or contributions:
- Check the Help Center in the app
- Contact support through the app
- Review documentation in `docs/` folder

---

## 📄 License

[Specify your license here]

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- All package maintainers
- Design inspiration and UI components
- API provider: `https://su12ecommerce.lionh456.uk`

---

**Last Updated:** November 2025  
**Version:** 1.0.0+1  
**Maintained by:** [Your Team/Organization]

