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
  // Selected item ids for checkout (checkboxes in cart).
  final Set<String> selectedItemIds = {};

  // Temporary buy-now item (when user uses Buy Now on product detail)
  MyCardModel? buyNowItem;

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
      // default: select all items when loading cart
      selectedItemIds.clear();
      selectedItemIds.addAll(myCardItems.map((e) => e.id));
    }
    emit(GetItems());
  }

  Future<void> _persistCart() async {
    final encoded = jsonEncode(
      myCardItems.map((item) => item.toMap()).toList(),
    );
    await CachedHelper.saveData(kCartItemsStorageKey, encoded);
  }

  /// Toggle selection checkbox of a cart item
  void toggleSelection(String productId) {
    if (selectedItemIds.contains(productId)) {
      selectedItemIds.remove(productId);
    } else {
      selectedItemIds.add(productId);
    }
    emit(ItemUpdated());
  }

  /// Select all items in cart
  void selectAllItems() {
    selectedItemIds.clear();
    selectedItemIds.addAll(myCardItems.map((e) => e.id));
    emit(ItemUpdated());
  }

  /// Deselect all items
  void clearSelection() {
    selectedItemIds.clear();
    emit(ItemUpdated());
  }

  /// Items that are currently selected for checkout
  List<MyCardModel> get selectedItems =>
      myCardItems.where((i) => selectedItemIds.contains(i.id)).toList();

  double get selectedSubtotal => selectedItems.fold(
    0,
    (previousValue, element) =>
        previousValue + (element.price * element.numOfPieces),
  );

  double get selectedDeliveryFee => selectedItems.isEmpty ? 0 : 5;

  double get selectedTotal => selectedSubtotal + selectedDeliveryFee;

  /// Set buy-now item and quantity, and clear selection to prefer buy-now
  void setBuyNow(MyCardModel item) {
    buyNowItem = item;
    // when buyNowItem is set, clear selectedItemIds so checkout uses buyNowItem
    selectedItemIds.clear();
    emit(ItemUpdated());
  }

  void clearBuyNow() {
    buyNowItem = null;
    emit(ItemUpdated());
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
      // select newly added item by default
      selectedItemIds.add(productId);
      emit(ItemAdded());
    }
    unawaited(_persistCart());
  }

  Future<void> removeItem(int index) async {
    if (index < 0 || index >= myCardItems.length) return;
    final removed = myCardItems.removeAt(index);
    selectedItemIds.remove(removed.id);
    await _persistCart();
    emit(ItemRemoved());
  }

  void incrementQuantity(String productId) {
    final index = myCardItems.indexWhere((item) => item.id == productId);
    if (index != -1) {
      final item = myCardItems[index];
      myCardItems[index] = item.copyWith(numOfPieces: item.numOfPieces + 1);
      // keep buyNowItem in sync if it refers to an item in the cart
      if (buyNowItem?.id == productId) {
        buyNowItem = buyNowItem!.copyWith(
          numOfPieces: buyNowItem!.numOfPieces + 1,
        );
      }
      emit(ItemUpdated());
      unawaited(_persistCart());
      return;
    }

    // If item not in persisted cart but it's the current buy-now item, update it directly
    if (buyNowItem?.id == productId) {
      buyNowItem = buyNowItem!.copyWith(
        numOfPieces: buyNowItem!.numOfPieces + 1,
      );
      emit(ItemUpdated());
    }
  }

  void decrementQuantity(String productId) {
    final index = myCardItems.indexWhere((item) => item.id == productId);
    if (index != -1) {
      final item = myCardItems[index];
      if (item.numOfPieces <= 1) {
        myCardItems.removeAt(index);
        selectedItemIds.remove(item.id);
        emit(ItemRemoved());
      } else {
        myCardItems[index] = item.copyWith(numOfPieces: item.numOfPieces - 1);
        // keep buyNowItem in sync if it refers to an item in the cart
        if (buyNowItem?.id == productId) {
          buyNowItem = buyNowItem!.copyWith(
            numOfPieces: buyNowItem!.numOfPieces - 1,
          );
        }
        emit(ItemUpdated());
      }
      unawaited(_persistCart());
      return;
    }

    // If item isn't in persisted cart but is the buy-now item, update it directly
    if (buyNowItem?.id == productId) {
      if (buyNowItem!.numOfPieces <= 1) {
        // removing buyNow item
        buyNowItem = null;
        emit(ItemRemoved());
      } else {
        buyNowItem = buyNowItem!.copyWith(
          numOfPieces: buyNowItem!.numOfPieces - 1,
        );
        emit(ItemUpdated());
      }
    }
  }

  Future<void> removeCheckedOutItems() async {
    if (buyNowItem != null) {
      myCardItems.removeWhere((i) => i.id == buyNowItem!.id);
      buyNowItem = null;
    } else {
      myCardItems.removeWhere((i) => selectedItemIds.contains(i.id));
      selectedItemIds.clear();
    }
    await _persistCart();
    emit(ItemRemoved());
  }

  double get subtotal => myCardItems.fold(
    0,
    (previousValue, element) =>
        previousValue + (element.price * element.numOfPieces),
  );

  double get deliveryFee => myCardItems.isEmpty ? 0 : 5;

  double get total => subtotal + deliveryFee;
}
