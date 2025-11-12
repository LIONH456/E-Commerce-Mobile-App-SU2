import 'package:carousel_slider/carousel_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_images.dart';
import '../../../../../core/utils/constant.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit()
    : _dio = Dio(
        BaseOptions(
          baseUrl: kApiBaseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      ),
      super(HomePageInitial());

  final Dio _dio;

  static HomePageCubit get(context) => BlocProvider.of(context);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController searchController = TextEditingController();

  final CarouselSliderController? carouselController =
      CarouselSliderController();

  int i = 0;
  int reviewIndex = 0;
  int currentIndex = 0;
  bool isDark = true;

  final List<String> imageCover = [
    AppImages.banner1,
    AppImages.banner2,
    AppImages.banner3,
  ];

  final List<ProductModel> _allProducts = [];
  ProductsModels products = ProductsModels(products: []);
  List<CategoryModel> categories = [];
  List<CategoryModel> parentCategories = [];

  bool isProductsLoading = false;
  bool isCategoriesLoading = false;
  String? productsError;
  String? categoriesError;

  Future<void> loadInitialData() async {
    await Future.wait([fetchCategories(), fetchAllProducts()]);
  }

  void changeReviewIndex(int index) {
    reviewIndex = index;
    emit(ChangeReviewIndexState());
  }

  void homeToggleButton(int index) {
    currentIndex = index;
    emit(HomeToggleButton());
  }

  void isDarkMode() {
    isDark = !isDark;
    emit(HomeIsDarkMode());
  }

  void selectCategory(int index) {
    if (i == index && products.products.isNotEmpty) {
      applyCategoryFilter(index);
      return;
    }
    i = index;
    emit(ChangeIndexState());
    applyCategoryFilter(index);
  }

  void applyCategoryFilter(int index, {bool emitState = true}) {
    if (_allProducts.isEmpty) {
      if (emitState) {
        emit(HomePageGetProducts());
      }
      return;
    }

    List<ProductModel> filtered;
    if (index == 0) {
      filtered = List<ProductModel>.from(_allProducts);
    } else {
      final categoryIndex = index - 1;
      if (categoryIndex < 0 || categoryIndex >= parentCategories.length) {
        filtered = [];
      } else {
        final selectedCategory = parentCategories[categoryIndex];
        final categoryIds = _getCategoryIdsIncludingChildren(selectedCategory.id);
        filtered = _allProducts
            .where((product) => 
                product.categoryId != null && 
                categoryIds.contains(product.categoryId))
            .toList();
      }
    }

    products = ProductsModels(products: filtered);
    if (emitState) {
      emit(HomePageGetProducts());
    }
  }

  /// Get all category IDs including the parent and all its children
  List<String> _getCategoryIdsIncludingChildren(String parentId) {
    final categoryIds = <String>[parentId];
    
    // Find all child categories
    for (final category in categories) {
      if (category.parentId == parentId) {
        categoryIds.add(category.id);
      }
    }
    
    return categoryIds;
  }

  Future<void> fetchAllProducts() async {
    try {
      isProductsLoading = true;
      emit(HomePageProductsLoading());
      final fetchedProducts = await _fetchProductsPaginated();
      _allProducts
        ..clear()
        ..addAll(fetchedProducts);
      productsError = null;
      isProductsLoading = false;
      applyCategoryFilter(i, emitState: false);
      emit(HomePageProductsSuccess());
      emit(HomePageGetProducts());
    } catch (error) {
      isProductsLoading = false;
      productsError = _mapError(error);
      emit(HomePageProductsError(productsError!));
    }
  }

  Future<void> fetchCategories() async {
    try {
      isCategoriesLoading = true;
      emit(HomePageCategoriesLoading());
      final fetchedCategories = await _fetchCategoriesPaginated();
      categories = fetchedCategories;
      // Filter to show only parent categories (categories with no parent_id)
      parentCategories = categories
          .where((category) => category.isParent && category.isActive)
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      categoriesError = null;
      isCategoriesLoading = false;
      emit(HomePageCategoriesSuccess());
      applyCategoryFilter(i);
    } catch (error) {
      isCategoriesLoading = false;
      categoriesError = _mapError(error);
      emit(HomePageCategoriesError(categoriesError!));
    }
  }

  Future<List<ProductModel>> _fetchProductsPaginated() async {
    final List<ProductModel> aggregated = [];
    String? path = 'products/';

    while (path != null) {
      final response = await _get(path);
      final data = response.data;
      if (data is List) {
        aggregated.addAll(
          data
              .map<ProductModel>(
                (product) =>
                    ProductModel.fromJson(product as Map<String, dynamic>),
              )
              .toList(),
        );
        break;
      } else if (data is Map<String, dynamic>) {
        final page = ProductsModels.fromJson(data);
        aggregated.addAll(page.products);
        final next = page.next;
        if (next == null || next.isEmpty) {
          path = null;
        } else if (next.startsWith('http')) {
          path = next;
        } else if (next.startsWith('?')) {
          path = 'products/$next';
        } else {
          path = next;
        }
      } else {
        break;
      }
    }

    return aggregated;
  }

  Future<List<CategoryModel>> _fetchCategoriesPaginated() async {
    final List<CategoryModel> aggregated = [];
    String? path = 'categories/';

    while (path != null) {
      final response = await _get(path);
      final data = response.data;
      if (data is List) {
        aggregated.addAll(
          data
              .map<CategoryModel>(
                (category) =>
                    CategoryModel.fromJson(category as Map<String, dynamic>),
              )
              .toList(),
        );
        break;
      } else if (data is Map<String, dynamic>) {
        final results = (data['results'] as List<dynamic>? ?? []);
        aggregated.addAll(
          results
              .map<CategoryModel>(
                (category) =>
                    CategoryModel.fromJson(category as Map<String, dynamic>),
              )
              .toList(),
        );
        final next = data['next']?.toString();
        if (next == null || next.isEmpty) {
          path = null;
        } else if (next.startsWith('http')) {
          path = next;
        } else if (next.startsWith('?')) {
          path = 'categories/$next';
        } else {
          path = next;
        }
      } else {
        break;
      }
    }

    return aggregated;
  }

  Future<Response<dynamic>> _get(String path) {
    if (path.startsWith('http')) {
      return _dio.getUri(Uri.parse(path));
    }
    return _dio.get(path);
  }

  String _mapError(Object error) {
    if (error is DioException) {
      final responseMessage = error.response?.data is Map<String, dynamic>
          ? (error.response?.data['detail']?.toString() ??
                error.response?.data['message']?.toString())
          : null;
      return responseMessage ?? error.message ?? 'Something went wrong';
    }
    return error.toString();
  }
}
