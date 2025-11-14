import 'package:e_commerce_final/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/function/components.dart';
import '../../../../core/function/custom_app_bar.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/constant.dart';
import '../../../../generated/l10n.dart';
import '../../data/models/my_location_model.dart';
import '../cubit/my_card_cubit.dart';
import '../cubit/my_card_state.dart';
import 'widgets/checkout_details.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  LatLng? selectedLocation;
  GoogleMapController? mapController;
  String? address;
  int selectedPaymentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    return BlocConsumer<MyCartCubit, MyCartState>(
      buildWhen: (previous, current) => true,
      listenWhen: (previous, current) => true,
      builder: (BuildContext context, state) {
        var cubit = MyCartCubit.get(context);
        return Scaffold(
          appBar: customAppBar(context, l.checkout),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.sbh,
                  Text(
                    l.deliveryAddress,
                    style: AppStyles.styleSemiBold16(context),
                  ),
                  const SizedBox(height: 24),
                  _buildAddressSection(cubit, l),
                  const SizedBox(height: 24),
                  _buildPaymentMethod(l),
                  24.sbh,
                  Text(
                    l.orderSummary,
                    style: AppStyles.styleSemiBold16(context),
                  ),
                  const SizedBox(height: 16),
                  _buildOrderItems(cubit, l),
                  const Divider(
                    height: 24,
                    thickness: 1,
                    color: Color(0xffBDBDBD),
                  ),
                  const CheckoutDetails(hideButton: true),
                  24.sbh,
                  _buildContinueButton(cubit, l, context),
                  24.sbh,
                ],
              ),
            ),
          ),
        );
      },
      listener: (BuildContext context, state) {},
    );
  }

  Future<LatLng?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) return null;

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      return LatLng(position.latitude, position.longitude);
    } catch (_) {
      return null;
    }
  }

  Future<String> _getAddressFromLatLng(LatLng latLng, S l) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      Placemark place = placemarks[0];
      return place.street ?? l.unknownLocation;
    } catch (_) {
      return 'Error getting address';
    }
  }

  void _loadCurrentLocation() async {
    if (!mounted) return;
    final l = S.of(context);
    LatLng? location = await _getCurrentLocation();
    if (location != null) {
      String fetchedAddress = await _getAddressFromLatLng(location, l);
      if (!mounted) return;
      setState(() {
        selectedLocation = location;
        address = fetchedAddress;
      });
    } else {
      if (!mounted) return;
      setState(() {
        address = l.unableToGetCurrentLocation;
      });
    }
  }

  Widget _buildAddressSection(MyCartCubit cubit, S l) {
    if (cubit.myLocationsList.isEmpty) {
      return Center(
        child: GestureDetector(
          child: Text(
            l.addAddress,
            style: const TextStyle(color: Colors.blue, fontSize: 16),
          ),
        ),
      );
    } else {
      final location = cubit.myLocationsList.first;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  location.address ?? l.loading,
                  style: AppStyles.styleMedium14(
                    context,
                  ).copyWith(color: isAppDarkMode() ? kDarkThirdColor : null),
                ),
              ),
              16.sbw,
              InkWell(
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xffBDD8FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit,
                    color: isAppDarkMode()
                        ? kDarkPrimaryColor
                        : kLightPrimaryColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildGoogleMap(location),
          const SizedBox(height: 16),
          GestureDetector(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add,
                  color: isAppDarkMode()
                      ? kDarkPrimaryColor
                      : kLightPrimaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  l.addNewAddress,
                  style: TextStyle(
                    color: isAppDarkMode()
                        ? kDarkPrimaryColor
                        : kLightPrimaryColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildPaymentMethod(S l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.paymentMethod,
          style: AppStyles.styleSemiBold16(context).copyWith(
            color: isAppDarkMode() ? kDarkSecondColor : const Color(0xff071731),
          ),
        ),
        8.sbh,
        Text(
          l.listOfAllCreditCardsYouSaved,
          style: AppStyles.styleMedium14(context).copyWith(
            color: isAppDarkMode() ? const Color(0xffD0D0D0) : kLightThirdColor,
          ),
        ),
        24.sbh,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List<Widget>.generate(4, (i) {
              if (i == 0) {
                return Row(
                  children: [
                    SizedBox(
                      width: 46,
                      height: 67,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 46,
                              height: 67,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color(0xFFE9E8EB),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 5,
                            top: 7,
                            child: Container(
                              width: 36,
                              height: 53,
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(41.50),
                                ),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.add,
                            color: isAppDarkMode()
                                ? kDarkPrimaryColor
                                : kLightPrimaryColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                  ],
                );
              }

              final idx = i - 1;
              final isSelected = selectedPaymentIndex == idx;
              final Widget child;
              if (idx == 0) {
                child = Container(
                  padding: 12.pt,
                  width: 80,
                  height: 67,
                  decoration: BoxDecoration(
                    color: isSelected && isAppDarkMode() ? kWhiteColor : null,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? (isAppDarkMode()
                                ? kDarkPrimaryColor
                                : kLightPrimaryColor)
                          : const Color(0xffE9E8EB),
                      width: 1,
                    ),
                  ),
                  child: SvgPicture.asset(
                    AppImages.paymentIcon1,
                    fit: BoxFit.cover,
                  ),
                );
              } else if (idx == 1) {
                child = Container(
                  width: 80,
                  height: 67,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? kLightPrimaryColor
                          : const Color(0xffE9E8EB),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(AppImages.paymentIcon2),
                  ),
                );
              } else {
                child = Container(
                  width: 80,
                  height: 67,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? kLightPrimaryColor
                          : const Color(0xffE9E8EB),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppImages.paymentIcon3,
                      colorFilter: isAppDarkMode()
                          ? ColorFilter.mode(
                              isAppDarkMode()
                                  ? kDarkSecondColor
                                  : kLightSecondColor,
                              BlendMode.srcIn,
                            )
                          : null,
                    ),
                  ),
                );
              }

              return Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => selectedPaymentIndex = idx),
                    child: child,
                  ),
                  const SizedBox(width: 14),
                ],
              );
            }),
          ),
        ),
        24.sbh,
        Row(
          children: [
            Expanded(
              child: Text(
                l.addDeliveryInstruction,
                style: AppStyles.styleSemiBold16(context),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Color(0xffBDD8FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit,
                  color: isAppDarkMode()
                      ? kDarkPrimaryColor
                      : kLightPrimaryColor,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
        24.sbh,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xffBDBDBD), width: 1),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppImages.deliveryIcon1,
                    fit: BoxFit.cover,
                    width: 20,
                  ),
                ),
              ),
              12.sbw,
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffBDBDBD), width: 1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppImages.deliveryIcon2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              12.sbw,
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffBDBDBD), width: 1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppImages.deliveryIcon3,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              12.sbw,
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isAppDarkMode()
                      ? kDarkPrimaryColor
                      : kLightPrimaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: kWhiteColor, size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleMap(LocationData location) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          AppImages.map,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }

  Widget _buildOrderItems(MyCartCubit cubit, S l) {
    final items = cubit.buyNowItem != null
        ? [cubit.buyNowItem!]
        : cubit.selectedItems;

    if (items.isEmpty) {
      return Center(child: Text(l.noItemsSelected));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (ctx, idx) {
        final item = items[idx];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isAppDarkMode()
                  ? kLightSecondColor
                  : const Color(0xffF5F5F5),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isAppDarkMode()
                        ? kDarkColor.withOpacity(.3)
                        : const Color(0xffF5F5F5),
                  ),
                  child: item.image.isNotEmpty
                      ? (item.image.startsWith('http')
                            ? Image.network(item.image, fit: BoxFit.cover)
                            : Image.asset(item.image, fit: BoxFit.cover))
                      : Icon(
                          Icons.image_not_supported_outlined,
                          color: isAppDarkMode()
                              ? kDarkThirdColor
                              : kLightThirdColor,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: AppStyles.styleMedium14(ctx),
                      ),
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: AppStyles.styleMedium12(ctx).copyWith(
                          color: isAppDarkMode()
                              ? kDarkPrimaryColor
                              : kLightPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _QuantityButtonSmall(
                  icon: Icons.remove,
                  onPressed: () => cubit.decrementQuantity(item.id),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    item.numOfPieces.toString(),
                    style: AppStyles.styleSemiBold12(ctx),
                  ),
                ),
                _QuantityButtonSmall(
                  icon: Icons.add,
                  onPressed: () => cubit.incrementQuantity(item.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueButton(MyCartCubit cubit, S l, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await cubit.removeCheckedOutItems();
        if (!context.mounted) return;
        router.pushReplacement(AppRoutes.orderSuccess);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isAppDarkMode() ? kDarkPrimaryColor : kLightPrimaryColor,
        ),
        child: Center(
          child: Text(
            l.continuee,
            style: AppStyles.styleSemiBold16(
              context,
            ).copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _QuantityButtonSmall extends StatelessWidget {
  const _QuantityButtonSmall({required this.icon, required this.onPressed});
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: isAppDarkMode()
              ? kDarkColor.withOpacity(.3)
              : const Color(0xffE9E8EB),
        ),
        child: Icon(
          icon,
          size: 14,
          color: isAppDarkMode() ? kDarkSecondColor : kLightSecondColor,
        ),
      ),
    );
  }
}
