import 'package:e_commerce_final/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:navy_wear/core/utils/extensions.dart';

import '../../core/function/components.dart';
import '../../core/utils/app_images.dart';
import '../../core/utils/app_routes.dart';
import '../../core/utils/app_styles.dart';
import '../../core/utils/constant.dart';
import '../../core/widgets/custom_text_form_field.dart';
import '../../generated/l10n.dart';
import '../home/presentation/cubits/home_page_cubit/home_page_cubit.dart';
import '../home/presentation/cubits/home_page_cubit/home_page_state.dart';
import '../shared/widgets/custom_product_item.dart';
import '../my_cart/presentation/cubit/my_card_cubit.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    return BlocProvider(
      create: (context) => HomePageCubit()..fetchAllProducts(),
      child: BlocBuilder<HomePageCubit, HomePageState>(
        builder: (context, state) {
          var cubit = BlocProvider.of<HomePageCubit>(context);
          return Padding(
            padding: 24.psh,
            child: Column(
              children: [
                8.sbh,
                SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          borderRadius: BorderRadius.circular(16),
                          filled: true,
                          hintText: l.search,
                          prefix: SvgPicture.asset(
                            AppImages.searchNormal,
                            width: 24,
                            height: 24,
                            fit: BoxFit.scaleDown,
                            colorFilter: ColorFilter.mode(
                                isAppDarkMode()
                                    ? kDarkSecondColor
                                    : kLightSecondColor,
                                BlendMode.srcIn),
                          ),
                        ),
                      ),
                      8.sbw,
                      Container(
                        width: 48,
                        height: 48,
                        decoration: ShapeDecoration(
                          color: isAppDarkMode() ? kBlackColor : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x14718096),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Color(0x0A718096),
                              blurRadius: 1,
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppImages.filter,
                            colorFilter: ColorFilter.mode(
                              isAppDarkMode()
                                  ? kDarkSecondColor
                                  : kLightSecondColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                24.sbh,
                Row(
                  children: [
                    Text(
                      l.showing,
                      style: AppStyles.styleMedium16(context).copyWith(
                          color: isAppDarkMode()
                              ? kDarkSecondColor
                              : kLightSecondColor),
                    ),
                    4.sbw,
                    Text(
                      '120 ${l.items}',
                      style: AppStyles.styleMedium16(context)
                          .copyWith(color: const Color(0xff0064E5)),
                    ),
                    const Spacer(),
                    Text(l.sort, style: AppStyles.styleMedium14(context)),
                    10.sbw,
                    Center(
                        child: SvgPicture.asset(
                      AppImages.sort,
                      colorFilter: ColorFilter.mode(
                          isAppDarkMode()
                              ? kDarkSecondColor
                              : kLightSecondColor,
                          BlendMode.srcIn),
                    )),
                  ],
                ),
                14.sbh,
                Expanded(
                  child: Builder(
                    builder: (_) {
                      if (cubit.isProductsLoading &&
                          cubit.products.products.isEmpty) {
                        return const Center(
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }

                      if (cubit.productsError != null &&
                          cubit.products.products.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  cubit.productsError!,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.styleMedium14(context)
                                      .copyWith(
                                    color: isAppDarkMode()
                                        ? kDarkThirdColor
                                        : kLightThirdColor,
                                  ),
                                ),
                                12.sbh,
                                IconButton(
                                  onPressed: cubit.fetchAllProducts,
                                  icon: const Icon(Icons.refresh),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (cubit.products.products.isEmpty) {
                        return Center(
                          child: Text(
                            l.notAvailable,
                            style: AppStyles.styleMedium18(context),
                          ),
                        );
                      }

                      final rawCrossAxisCount =
                          (context.screenWidth / 200).round();
                      final crossAxisCount = rawCrossAxisCount < 1
                          ? 1
                          : (rawCrossAxisCount > 4 ? 4 : rawCrossAxisCount);

                      return GridView.builder(
                        itemCount: cubit.products.products.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.6, // Portrait aspect ratio for vertical images
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          final product = cubit.products.products[index];
                          return GestureDetector(
                            onTap: () {
                              router.push(
                                AppRoutes.productDetails,
                                extra: product,
                              );
                            },
                            child: CustomProductItem(
                              item: product,
                              isFavorite: true,
                              onAddToCart: () {
                                MyCartCubit.get(context).addToCart(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 1),
                                    content: Text('${product.name} added to cart'),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
