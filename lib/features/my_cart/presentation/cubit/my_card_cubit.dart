import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/utils/constant.dart';
import '../../../../core/utils/local_network.dart';
import '../../../home/data/models/product_model.dart';
import '../../data/models/my_card_model.dart';
import '../../data/models/my_location_model.dart';
import 'my_card_state.dart';

class MyCartCubit extends Cubit<MyCartState> {
  MyCartCubit() : super(MyCardInitial());

  static MyCartCubit get(context) => BlocProvider.of(context);

  final List<MyCardModel> myCardItems = [];

  final List<LocationData> myLocationsList = [
    LocationData(
      address: '120 Lane San Fransisco , East Falmouth MA',
      latitude: 37.7749,
      longitude: -122.4194,
      latLng: const LatLng(37.7749, -122.4194),
    ),
    LocationData(
      address: '456 Market St',
      latitude: 37.7849,
      longitude: -122.4094,
      latLng: const LatLng(37.7849, -122.4094),
    ),
  ];

  Future<void> loadCart() async {
    final stored = CachedHelper.getData(kCartItemsStorageKey) as String?;
    myCardItems.clear();
    if (stored != null && stored.isNotEmpty) {
      try {
        final decoded = jsonDecode(stored) as List<dynamic>;
        myCardItems.addAll(
          decoded
              .whereType<Map<String, dynamic>>()
              .map(MyCardModel.fromMap)
              .toList(),
        );
      } catch (_) {
        // ignore corrupted cache
      }
    }
    emit(GetItems());
  }

  Future<void> _persistCart() async {
    final encoded =
        jsonEncode(myCardItems.map((item) => item.toMap()).toList());
    await CachedHelper.saveData(kCartItemsStorageKey, encoded);
  }

  void addToCart(ProductModel product, {int quantity = 1}) {
    if (product.id.isEmpty && product.name.isEmpty) return;
    final productId = product.id.isNotEmpty ? product.id : product.name;
    final index = myCardItems.indexWhere((item) => item.id == productId);
    if (index >= 0) {
      final existing = myCardItems[index];
      myCardItems[index] = existing.copyWith(
        numOfPieces: existing.numOfPieces + quantity,
        price: product.price,
        image: product.image.isNotEmpty ? product.image : existing.image,
        name: product.name,
      );
      emit(ItemUpdated());
    } else {
      myCardItems.add(
        MyCardModel(
          id: productId,
          name: product.name,
          image: product.image,
          price: product.price,
          numOfPieces: quantity,
        ),
      );
      emit(ItemAdded());
    }
    unawaited(_persistCart());
  }

  Future<void> removeItem(int index) async {
    if (index < 0 || index >= myCardItems.length) return;
    myCardItems.removeAt(index);
    await _persistCart();
    emit(ItemRemoved());
  }

  void incrementQuantity(String productId) {
    final index = myCardItems.indexWhere((item) => item.id == productId);
    if (index == -1) return;
    final item = myCardItems[index];
    myCardItems[index] =
        item.copyWith(numOfPieces: item.numOfPieces + 1);
    emit(ItemUpdated());
    unawaited(_persistCart());
  }

  void decrementQuantity(String productId) {
    final index = myCardItems.indexWhere((item) => item.id == productId);
    if (index == -1) return;
    final item = myCardItems[index];
    if (item.numOfPieces <= 1) {
      myCardItems.removeAt(index);
      emit(ItemRemoved());
    } else {
      myCardItems[index] =
          item.copyWith(numOfPieces: item.numOfPieces - 1);
      emit(ItemUpdated());
    }
    unawaited(_persistCart());
  }

  double get subtotal => myCardItems.fold(
        0,
        (previousValue, element) =>
            previousValue + (element.price * element.numOfPieces),
      );

  double get deliveryFee => myCardItems.isEmpty ? 0 : 5;

  double get total => subtotal + deliveryFee;
}
