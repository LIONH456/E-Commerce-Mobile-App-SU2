# API Integration Guide

## Overview

The Shopapay application integrates with a REST API to fetch products and categories. The integration is fully implemented and working.

## API Base Configuration

**Base URL:** `https://su12ecommerce.lionh456.uk/api/`  
**Media Base URL:** `https://su12ecommerce.lionh456.uk/`

Configuration location: `lib/core/utils/constant.dart`

```dart
const String kApiBaseUrl = 'https://su12ecommerce.lionh456.uk/api/';
const String kMediaBaseUrl = 'https://su12ecommerce.lionh456.uk/';
```

## API Endpoints

### 1. Products API

**Endpoint:** `GET /api/products/`

**Full URL:** `https://su12ecommerce.lionh456.uk/api/products/`

**Response Format:**
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

**Implementation:**
- **Model:** `lib/features/home/data/models/product_model.dart`
- **Service:** `lib/features/home/presentation/cubits/home_page_cubit/home_page_cubit.dart`
- **Method:** `fetchAllProducts()` and `_fetchProductsPaginated()`

**Features:**
- ✅ Automatic pagination (follows `next` cursor)
- ✅ Aggregates all pages into a single list
- ✅ Handles both absolute and relative image URLs
- ✅ Calculates discount percentage from `price` and `compare_price`
- ✅ Error handling and loading states

### 2. Categories API

**Endpoint:** `GET /api/categories/`

**Full URL:** `https://su12ecommerce.lionh456.uk/api/categories/`

**Response Format:**
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

**Implementation:**
- **Model:** `lib/features/home/data/models/category_model.dart`
- **Service:** `lib/features/home/presentation/cubits/home_page_cubit/home_page_cubit.dart`
- **Method:** `fetchCategories()` and `_fetchCategoriesPaginated()`

**Features:**
- ✅ Automatic pagination
- ✅ Image URL resolution
- ✅ Category filtering for products
- ✅ Error handling and loading states

## Data Models

### ProductModel

**Location:** `lib/features/home/data/models/product_model.dart`

**Fields Mapping:**
| API Field | Model Field | Type |
|-----------|-------------|------|
| `id` | `id` | String |
| `name` | `name` | String |
| `description` | `desc` | String |
| `price` | `price` | double |
| `compare_price` | `beforeDiscount` | double? |
| `category_id` | `categoryId` | String? |
| `images` | `gallery` | List<String> |
| `main_image` | `image` | String |
| `is_available` | `isAvailable` | bool |
| `sku` | `sku` | String? |
| `quantity` | `quantity` | int? |
| `created_at` | `createdAt` | DateTime? |
| `updated_at` | `updatedAt` | DateTime? |

**Computed Fields:**
- `discountPercentage`: Calculated from `price` and `compare_price`

### CategoryModel

**Location:** `lib/features/home/data/models/category_model.dart`

**Fields Mapping:**
| API Field | Model Field | Type |
|-----------|-------------|------|
| `id` | `id` | String |
| `name` | `name` | String |
| `slug` | `slug` | String |
| `description` | `description` | String? |
| `image` | `image` | String? |
| `created_at` | `createdAt` | DateTime? |
| `updated_at` | `updatedAt` | DateTime? |

## Implementation Details

### HTTP Client

**Package:** `dio` (^5.9.0)

**Configuration:**
```dart
Dio(
  BaseOptions(
    baseUrl: kApiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
)
```

### Pagination Logic

The app automatically fetches all pages by:
1. Making initial request to the endpoint
2. Checking for `next` field in response
3. Following the `next` URL until `null`
4. Aggregating all results into a single list

**Code Location:** `home_page_cubit.dart` - `_fetchProductsPaginated()` and `_fetchCategoriesPaginated()`

### Media URL Resolution

**Utility Function:** `lib/core/utils/media_utils.dart` - `resolveMediaUrl()`

**Behavior:**
- Absolute URLs (starting with `http`) are used as-is
- Relative URLs are prefixed with `kMediaBaseUrl`
- Handles null/empty strings gracefully

### Error Handling

**Error Mapping:**
- DioException errors are caught and mapped to user-friendly messages
- Response errors extract `detail` or `message` from API response
- Fallback to generic error message

**States:**
- `HomePageProductsLoading` - Products are being fetched
- `HomePageProductsSuccess` - Products fetched successfully
- `HomePageProductsError` - Error occurred (with error message)
- Same pattern for categories

## Usage in UI

### Fetching Data

```dart
// In HomePageCubit
await loadInitialData(); // Fetches both products and categories

// Or individually
await fetchAllProducts();
await fetchCategories();
```

### Accessing Data

```dart
// Products
final products = HomePageCubit.get(context).products.products;

// Categories
final categories = HomePageCubit.get(context).categories;

// Loading states
final isLoading = HomePageCubit.get(context).isProductsLoading;
final error = HomePageCubit.get(context).productsError;
```

### Filtering by Category

```dart
// Select category (index 0 = All, index 1+ = specific category)
HomePageCubit.get(context).selectCategory(1);
```

## Testing the API

### Manual Testing

1. **Check API Response:**
   ```bash
   curl https://su12ecommerce.lionh456.uk/api/products/
   curl https://su12ecommerce.lionh456.uk/api/categories/
   ```

2. **In App:**
   - Launch the app
   - Navigate to Home screen
   - Products and categories should load automatically
   - Check for loading indicators
   - Verify products are displayed

### Debugging

- Check console logs for API errors
- Verify network connectivity
- Check API base URL in `constant.dart`
- Verify Dio timeout settings

## Future Enhancements

Potential improvements:
- [ ] Caching API responses
- [ ] Retry logic for failed requests
- [ ] Request/response interceptors for logging
- [ ] Token-based authentication
- [ ] Rate limiting handling
- [ ] Offline mode with cached data

## Troubleshooting

### Common Issues

1. **No products loading:**
   - Check internet connection
   - Verify API URL is correct
   - Check console for errors
   - Verify API is accessible

2. **Images not loading:**
   - Check `resolveMediaUrl()` function
   - Verify `kMediaBaseUrl` is correct
   - Check image URLs in API response

3. **Pagination not working:**
   - Verify `next` field in API response
   - Check pagination logic in `_fetchProductsPaginated()`

## API Documentation Links

- Products API: https://su12ecommerce.lionh456.uk/api/products/
- Categories API: https://su12ecommerce.lionh456.uk/api/categories/

---

**Last Updated:** November 2025  
**Status:** ✅ Fully Implemented and Working

