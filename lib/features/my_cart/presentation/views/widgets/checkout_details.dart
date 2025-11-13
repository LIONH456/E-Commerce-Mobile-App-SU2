import 'package:e_commerce_final/core/utils/extensions.dart';
import 'package:flutter/material.dart';

import '../../../../../core/function/components.dart';
import '../../../../../core/utils/app_routes.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../../../core/utils/constant.dart';
import '../../../../../core/widgets/custom_buttons.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../generated/l10n.dart';
import '../../cubit/my_card_cubit.dart';

class CheckoutDetails extends StatelessWidget {
  const CheckoutDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final cartCubit = MyCartCubit.get(context);
    final subtotal = cartCubit.subtotal;
    final delivery = cartCubit.deliveryFee;
    final total = cartCubit.total;

    return Column(
      children: [
        GestureDetector(
          onTap: () {},
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
                  color: isAppDarkMode() ? kDarkSecondColor : kLightSecondColor,
                ),
              ],
            ),
          ),
        ),
        const Divider(
          thickness: 1,
          color: Color(0xffBDBDBD),
          height: 16,
        ),
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
          fillColor:
              isAppDarkMode() ? kLightSecondColor : const Color(0xffF4F6F9),
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
        const Divider(
          thickness: 1,
          color: Color(0xffBDBDBD),
          height: 16,
        ),
        _summaryRow(context, '${l.total} (incl. VAT)', total,
            isTotal: true),
        const SizedBox(height: 16),
        CustomButton(
          onPressed: () => router.push(AppRoutes.checkout),
          child: Center(
            child: Text(
              l.continuee,
              style: AppStyles.styleMedium16(context)
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
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
            style: (isTotal
                    ? AppStyles.styleMedium18(context)
                    : AppStyles.styleMedium18(context))
                .copyWith(
              color: isAppDarkMode() ? kDarkPrimaryColor : kLightPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
