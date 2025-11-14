import 'package:e_commerce_final/core/utils/extensions.dart';
import 'package:e_commerce_final/features/my_cart/presentation/views/widgets/checkout_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/function/components.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/constant.dart';
import '../../../../generated/l10n.dart';
import '../cubit/my_card_cubit.dart';
import '../cubit/my_card_state.dart';

class MyCart extends StatelessWidget {
  const MyCart({super.key});

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    return SafeArea(
      child: BlocBuilder<MyCartCubit, MyCartState>(
        builder: (context, state) {
          final cubit = MyCartCubit.get(context);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${cubit.myCardItems.length} ${l.itemAtCart}',
                        style: AppStyles.styleMedium18(context),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          l.seeAll,
                          textAlign: TextAlign.right,
                          style: AppStyles.styleMedium16(context).copyWith(
                            color: isAppDarkMode()
                                ? kDarkPrimaryColor
                                : kLightPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (cubit.myCardItems.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(l.yourCartIsEmpty),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: 16.psh,
                    itemCount: cubit.myCardItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = cubit.myCardItems[index];
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: Dismissible(
                          key: Key(item.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            decoration: ShapeDecoration(
                              color: isAppDarkMode()
                                  ? kDarkPrimaryColor
                                  : kLightPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            alignment: Alignment.centerRight,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Image(image: AssetImage(AppImages.trash)),
                            ),
                          ),
                          onDismissed: (_) => cubit.removeItem(index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0x115A6CEA,
                                  ).withOpacity(.07),
                                  blurRadius: 50,
                                  offset: const Offset(12, 26),
                                  spreadRadius: 0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(12),
                              color: isAppDarkMode()
                                  ? kLightSecondColor
                                  : kWhiteColor,
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: cubit.selectedItemIds.contains(
                                    item.id,
                                  ),
                                  onChanged: (_) =>
                                      cubit.toggleSelection(item.id),
                                ),
                                _CartItemImage(imageUrl: item.image),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: AppStyles.styleMedium16(context)
                                            .copyWith(
                                              color: isAppDarkMode()
                                                  ? kDarkThirdColor
                                                  : kLightThirdColor,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            '\$ ${(item.price * item.numOfPieces).toStringAsFixed(2)}',
                                            style:
                                                AppStyles.styleMedium16(
                                                  context,
                                                ).copyWith(
                                                  color: isAppDarkMode()
                                                      ? kDarkPrimaryColor
                                                      : kLightPrimaryColor,
                                                ),
                                          ),
                                          const Spacer(),
                                          _QuantityButton(
                                            icon: Icons.remove,
                                            onPressed: () => cubit
                                                .decrementQuantity(item.id),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                            ),
                                            child: Text(
                                              item.numOfPieces.toString(),
                                              style: AppStyles.styleSemiBold14(
                                                context,
                                              ),
                                            ),
                                          ),
                                          _QuantityButton(
                                            icon: Icons.add,
                                            onPressed: () => cubit
                                                .incrementQuantity(item.id),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 16),
                Padding(padding: 24.psh, child: const CheckoutDetails()),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CartItemImage extends StatelessWidget {
  const _CartItemImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _placeholder(context);
    }

    if (imageUrl.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          width: 55,
          height: 55,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(context),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        imageUrl,
        width: 55,
        height: 55,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(context),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isAppDarkMode()
            ? kDarkColor.withOpacity(.3)
            : const Color(0xffF5F5F5),
      ),
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 18,
        color: isAppDarkMode()
            ? kDarkThirdColor
            : kLightThirdColor.withOpacity(.7),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: isAppDarkMode() ? kDarkSecondColor : kLightSecondColor,
        size: 18,
      ),
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }
}
