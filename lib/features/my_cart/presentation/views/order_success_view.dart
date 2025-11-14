import 'package:e_commerce_final/core/utils/extensions.dart';
import 'package:e_commerce_final/core/function/components.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/constant.dart';
import '../../../../core/widgets/custom_buttons.dart';
import '../../../../generated/l10n.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: 24.psh,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isAppDarkMode()
                      ? kDarkPrimaryColor
                      : kLightPrimaryColor,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 60),
              ),
              24.sbh,
              Text(
                l.orderSuccess,
                style: AppStyles.styleSemiBold24(context),
                textAlign: TextAlign.center,
              ),
              12.sbh,
              Text(
                l.thankyouForOrder,
                style: AppStyles.styleMedium16(context).copyWith(
                  color: isAppDarkMode()
                      ? kDarkThirdColor
                      : const Color(0xff909193),
                ),
                textAlign: TextAlign.center,
              ),
              16.sbh,
              Text(
                l.orderConfirmation,
                style: AppStyles.styleRegular14(context).copyWith(
                  color: isAppDarkMode()
                      ? const Color(0xffD0D0D0)
                      : kLightThirdColor,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              CustomButton(
                onPressed: () => router.pushReplacement(AppRoutes.homeLayout),
                child: Center(
                  child: Text(
                    l.continueShopping,
                    style: AppStyles.styleSemiBold16(
                      context,
                    ).copyWith(color: Colors.white),
                  ),
                ),
              ),
              16.sbh,
            ],
          ),
        ),
      ),
    );
  }
}
