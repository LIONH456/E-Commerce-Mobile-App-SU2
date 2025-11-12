# Shopapay Project Overview

## Mission & Scope
Shopapay is a Flutter-based e-commerce experience focused on fast product discovery, streamlined checkout, and personalized engagement. The current build targets mobile platforms with responsive UI elements and multilingual support (English, Arabic, French) to increase accessibility across regions.

## Core User Journeys
- **Onboarding:** Branded carousel introduces value propositions and drives first-time engagement.
- **Authentication:** Email/password and social sign-in options (Google, Facebook, Apple) support account creation, recovery, and re-entry.
- **Product Discovery:** Category chips, promo banners, search, and sorting controls help customers find catalog items quickly.
- **Product Evaluation:** Rich detail pages combine photo galleries, descriptions, price comparisons, and community reviews.
- **Cart & Checkout:** Users manage carts, apply promo codes, select delivery options, and choose preferred payment methods.
- **Profile & Support:** Dedicated views cover profile management, address book, payment methods, help center, and notification preferences.

## Architecture Snapshot
- **Presentation:** Declarative UI built with Flutter; navigation orchestrated via `go_router`.
- **State Management:** `flutter_bloc` cubits drive view state, theme toggles, and domain-specific flows.
- **Networking:** `dio` powers HTTP requests, error handling, and pagination for REST integrations.
- **Persistence & Preferences:** `shared_preferences` caches tokens, language, and theme mode. Language metadata is modeled via custom `LanguageModel`.
- **Maps & Location:** `geolocator`, `geocoding`, and `google_maps_flutter` support delivery address selection and real-time positioning.
- **Design System:** Centralized constants (`constant.dart`), theming helpers (`app_theme.dart`), reusable widgets, and typography utilities (`AppStyles`) maintain brand consistency.
- **Dependency Injection (optional):** `get_it` is included for scalable service registration; adoption can expand alongside new domains.

## API Integrations
| Endpoint | Purpose | Notes |
| --- | --- | --- |
| `GET https://su12ecommerce.lionh456.uk/api/products/` | Fetches paginated product catalog including pricing, availability, and media assets. | Response exposes `count`, `next`, `results[]` with `main_image`, `compare_price`, `tags`, etc. [[1]] |
| `GET https://su12ecommerce.lionh456.uk/api/categories/` | Returns product taxonomies used for the category chips and navigation hierarchy. | Supports pagination via `next` cursor; category IDs map to product `category_id`. [[2]] |

**Integration Details**
- Cubits request the first page and iteratively follow the `next` cursor to assemble full lists.
- Media paths are normalized so both absolute and relative URLs render seamlessly inside the UI.
- Discount ribbons are calculated on the client by comparing `price` vs `compare_price` when the backend does not provide a percentage.

## Feature Deep Dive
- **Localization:** Generated ARB and `l10n.dart` files expose English, Arabic, and French strings. Runtime locale changes persist through `CachedHelper`.
- **Theme Switching:** Light/dark palettes, typography scaling, and adaptive colors ensure readability across contexts.
- **Reviews & Ratings:** Dedicated cubits and screens capture feedback, show average ratings, and support community moderation workflows.
- **Notifications & Messaging:** UI shells exist for alert hubs and conversational support, ready for backend wiring.
- **Payment UX:** Card input forms (with validation helpers), PayPal, and MasterCard assets are prepared for real gateway integration.
- **Maps & Delivery:** Checkout flows surface live location data, address editing, and delivery instructions.

## Tooling & Dependencies
| Category | Packages |
| --- | --- |
| UI & Motion | `flutter_svg`, `carousel_slider`, `smooth_page_indicator`, `animations` |
| State & Navigation | `flutter_bloc`, `go_router`, `page_transition` |
| Networking & Data | `dio`, `shared_preferences`, `get_it`, `intl` |
| Auth & Social | `google_sign_in`, `flutter_phoenix` (reset flows) |
| Mapping & Geo | `geolocator`, `google_maps_flutter`, `geocoding` |
| Input & Feedback | `pinput`, `otp_timer_button`, `flutter_rating_bar` |
| Theming & Assets | `flutter_native_splash`, `icons_launcher`, custom fonts |

For the complete dependency list, refer to `pubspec.yaml`.

## Development Workflow
1. Install Flutter 3.8.1 (or newer) and clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Execute `flutter run` (device/emulator) to launch the app.
4. For localization changes, update the ARB files under `l10n/` and regenerate via `flutter pub run intl_utils:generate`.

## Testing & Quality
- Static analysis enforced via `flutter_lints`.
- Widget and bloc tests can be layered with `flutter_test` and `bloc_test` (consider adding for mission-critical features).
- Manual QA should validate onboarding, auth, product browsing, cart, checkout, and settings flows across locales and theme modes.

## Future Enhancements
- Integrate secure payment gateways (Stripe, PayPal SDKs).
- Enable offline caching for catalog data and persistent carts.
- Add analytics instrumentation for funnel tracking.
- Expand accessibility (voice-over hints, larger text presets).
- Implement push notification handling and in-app messaging backends.

---

[1]: https://su12ecommerce.lionh456.uk/api/products/
[2]: https://su12ecommerce.lionh456.uk/api/categories/

