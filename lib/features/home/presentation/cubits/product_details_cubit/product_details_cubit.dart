import 'package:e_commerce_final/features/home/presentation/cubits/product_details_cubit/product_details_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
// import 'package:navy_wear/features/home/presentation/cubits/product_details_cubit/product_details_state.dart';

import '../../../../../core/function/components.dart';
import '../../../../../core/utils/app_images.dart';
import '../../../../../core/utils/constant.dart';
import '../../../data/models/product_model.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  static ProductDetailsCubit get(context) => BlocProvider.of(context);

  // A small sample fallback list used when API cannot be reached
  ProductsModels relatedProduct = ProductsModels(
    products: [
      ProductModel(
        id: '1',
        name: 'Running ',
        desc: 'Lightweight and durable running shoes for active lifestyles.',
        price: 18.0,
        image: AppImages.product8,
        beforeDiscount: 20.0,
        discountPercentage: 10,
      ),
      ProductModel(
        id: '1',
        name: 'Classic Black Blazer',
        desc: 'Elegant black blazer for formal and semi-formal events.',
        price: 50.0,
        image: AppImages.product7,
        beforeDiscount: 100.0,
        discountPercentage: 50,
      ),
      ProductModel(
        id: '3',
        name: 'Minimalist Black T-Shirt',
        desc: 'Simple and sleek black T-shirt for everyday use.',
        price: 100.0,
        image: AppImages.product3,
        beforeDiscount: 150.0,
        discountPercentage: 33,
      ),
      ProductModel(
        id: '4',
        name: 'Striped White T-Shirt',
        desc: 'White T-shirt with a classic striped design.',
        price: 18.0,
        image: AppImages.product4,
        beforeDiscount: 20.0,
        discountPercentage: 10,
      ),
      ProductModel(
        id: '5',
        name: 'Graphic T-Shirt',
        desc: 'Comfortable T-shirt featuring unique graphic artwork.',
        price: 180.0,
        image: AppImages.product5,
        beforeDiscount: 200.0,
        discountPercentage: 10,
      ),
      ProductModel(
        id: '6',
        name: 'Vintage Yellow T-Shirt',
        desc: 'Soft vintage-style T-shirt with a relaxed fit.',
        price: 50.0,
        image: AppImages.product6,
        beforeDiscount: 100.0,
        discountPercentage: 50,
      ),
    ],
  );

  List<ProductModel> filteredRelatedProduct = [];

  /// Fetch related products from API (paginated) and pick up to [limit]
  /// products that are not the [currentProductId]. On any error the
  /// local `relatedProduct.products` fallback is used.
  Future<void> getRelatedProducts(
    String currentProductId, {
    int limit = 8,
  }) async {
    try {
      final Dio dio = Dio(
        BaseOptions(
          baseUrl: kApiBaseUrl,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
        ),
      );

      final List<ProductModel> aggregated = [];
      String? path = 'products/';

      while (path != null) {
        final response = path.startsWith('http')
            ? await dio.getUri(Uri.parse(path))
            : await dio.get(path);
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

      // Remove current product and any duplicates
      final candidates = aggregated
          .where((p) => p.id != currentProductId)
          .toList(growable: false);

      // If not enough results from API, fallback to bundled list
      List<ProductModel> finalList = candidates;
      if (finalList.isEmpty) {
        finalList = relatedProduct.products
            .where((p) => p.id != currentProductId)
            .toList();
      }

      // Shuffle and limit to `limit`
      finalList.shuffle();
      if (finalList.length > limit) {
        filteredRelatedProduct = finalList.take(limit).toList();
      } else {
        filteredRelatedProduct = finalList;
      }
    } catch (e) {
      // On any error use fallback sample list (excluding current)
      filteredRelatedProduct = relatedProduct.products
          .where((product) => product.id != currentProductId)
          .take(8)
          .toList();
    }

    emit(RelatedProductsReady());
  }

  List<Color> availableColors = [
    isAppDarkMode() ? kDarkPrimaryColor : kLightPrimaryColor,
    const Color(0xffF76834),
    const Color(0xffBDBDBD),
    // LightColor.red,
    // LightColor.skyBlue,
  ];

  List<String> availableSizes = ['S', 'M', 'L'];

  int currentIndex = 0;

  bool isFav = true;

  final List<String> imgList = [
    'https://via.placeholder.com/800x400.png?text=Slide+1',
    'https://via.placeholder.com/800x400.png?text=Slide+2',
    'https://via.placeholder.com/800x400.png?text=Slide+3',
  ];

  int currentIndicatorIndex = 0;

  final PageController pageController = PageController();

  void addNumber() {
    currentIndex = currentIndex + 1;
    emit(AddNumberState());
  }

  void minusNumber() {
    if (currentIndex > 0) {
      currentIndex = currentIndex - 1;
      emit(MinusNumberState());
    }
  }

  void addFav() {
    isFav = !isFav;
    emit(AddFavState());
  }

  void changeIndicator(index) async {
    pageController.jumpTo(index.toDouble()); // Update the active page

    emit(AddFavState());
  }
}
