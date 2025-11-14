import 'package:e_commerce_final/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/function/components.dart';
import '../../../../../core/utils/app_routes.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../core/utils/constant.dart';
import '../../../../../core/widgets/custom_buttons.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../generated/l10n.dart';
import '../../cubit/my_card_cubit.dart';
import '../../cubit/my_card_state.dart';

class CheckoutDetails extends StatelessWidget {
  const CheckoutDetails({super.key, this.hideButton = false});

  final bool hideButton;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    return BlocBuilder<MyCartCubit, MyCartState>(
      builder: (context, state) {
        final cartCubit = MyCartCubit.get(context);
        double subtotal;
        double delivery;
        double total;

        if (cartCubit.buyNowItem != null) {
          final b = cartCubit.buyNowItem!;
          subtotal = b.price * b.numOfPieces;
          delivery = subtotal == 0 ? 0 : 5;
          total = subtotal + delivery;
        } else if (cartCubit.selectedItems.isNotEmpty) {
          subtotal = cartCubit.selectedSubtotal;
          delivery = cartCubit.selectedDeliveryFee;
          total = cartCubit.selectedTotal;
        } else {
          subtotal = cartCubit.subtotal;
          delivery = cartCubit.deliveryFee;
          total = cartCubit.total;
        }

        return Column(
          children: [
            GestureDetector(
              onTap: () => router.push(AppRoutes.homeLayout),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0, left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l.addMoreItems,
                      style: AppStyles.styleMedium16(context).copyWith(
                        color: isAppDarkMode()
                            ? kDarkPrimaryColor
                            : kLightPrimaryColor,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 20,
                      color: isAppDarkMode()
                          ? kDarkSecondColor
                          : kLightSecondColor,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(thickness: 1, color: Color(0xffBDBDBD), height: 16),
            Row(
              children: [
                Text(
                  l.promoCode,
                  textAlign: TextAlign.start,
                  style: AppStyles.styleSemiBold14(context),
                ),
              ],
            ),
            8.sbh,
            CustomTextFormField(
              hintText: l.enterCodeVoucher,
              filled: isAppDarkMode(),
              fillColor: isAppDarkMode()
                  ? kLightSecondColor
                  : const Color(0xffF4F6F9),
              suffix: Padding(
                padding: 8.pe,
                child: TextButton(
                  child: Text(
                    l.apply,
                    style: AppStyles.styleMedium14(context).copyWith(
                      color: isAppDarkMode()
                          ? kDarkPrimaryColor
                          : kLightPrimaryColor,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
            8.sbh,
            _summaryRow(context, l.subtotal, subtotal),
            _summaryRow(context, l.delivery, delivery),
            _summaryRow(context, l.promoCode, 0),
            const Divider(thickness: 1, color: Color(0xffBDBDBD), height: 16),
            _summaryRow(
              context,
              '${l.total} (incl. VAT)',
              total,
              isTotal: true,
            ),
            const SizedBox(height: 16),
            if (!hideButton)
              CustomButton(
                onPressed: () {
                  // Require at least one selected item or a buy-now item before proceeding
                  if (cartCubit.buyNowItem != null ||
                      cartCubit.selectedItems.isNotEmpty) {
                    router.push(AppRoutes.checkout);
                  } else {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(l.noItemsSelected)));
                  }
                },
                child: Center(
                  child: Text(
                    l.continuee,
                    style: AppStyles.styleMedium16(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _summaryRow(
    BuildContext context,
    String label,
    double value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            textAlign: TextAlign.start,
            style: isTotal
                ? AppStyles.styleSemiBold16(context)
                : AppStyles.styleSemiBold14(context),
          ),
          const Spacer(),
          Text(
            '\$ ${value.toStringAsFixed(2)}',
            style:
                (isTotal
                        ? AppStyles.styleMedium18(context)
                        : AppStyles.styleMedium18(context))
                    .copyWith(
                      color: isAppDarkMode()
                          ? kDarkPrimaryColor
                          : kLightPrimaryColor,
                    ),
          ),
        ],
      ),
    );
  }
}
