import 'package:e_commerce_final/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/function/components.dart';
import '../../../../core/function/custom_app_bar.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/constant.dart';
import '../../../../generated/l10n.dart';
import '../../../shared/widgets/custom_product_item.dart';
import '../cubits/home_page_cubit/home_page_cubit.dart';
import '../cubits/home_page_cubit/home_page_state.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../my_cart/presentation/cubit/my_card_cubit.dart';

class NewFashionView extends StatelessWidget {
  const NewFashionView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    return BlocProvider(
      create: (_) => HomePageCubit()..loadInitialData(),
      child: BlocBuilder<HomePageCubit, HomePageState>(
        builder: (context, state) {
          final cubit = HomePageCubit.get(context);
          return Scaffold(
            appBar: customAppBar(context, l.newFashion),
            body: Column(
              children: [
                16.sbh,
                _buildCategorySelector(context, cubit, l),
                16.sbh,
                Expanded(child: _buildGrid(context, cubit, l)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context, HomePageCubit cubit, S l) {
    final labels = [l.all, ...cubit.parentCategories.map((e) => e.name)];
    return SizedBox(
      height: 32,
      child: Align(
        alignment: isLanguageRTL() ? Alignment.centerRight : Alignment.centerLeft,
        child: ListView.separated(
          padding: 24.ps,
          scrollDirection: Axis.horizontal,
          itemCount: labels.length,
          separatorBuilder: (_, __) => 10.sbw,
          itemBuilder: (context, index) {
            final isSelected = cubit.i == index;
            return InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: () => cubit.selectCategory(index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? isAppDarkMode() ? kDarkPrimaryColor : kLightPrimaryColor
                      : Colors.transparent,
                  border: isSelected
                      ? null
                      : Border.all(
                          color: isAppDarkMode() ? kDarkPrimaryColor : kLightPrimaryColor),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  labels[index],
                  style: AppStyles.styleMedium14(context).copyWith(
                    color: isSelected
                        ? kWhiteColor
                        : isAppDarkMode() ? const Color(0xffDAE8FF) : kLightPrimaryColor,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, HomePageCubit cubit, S l) {
    if (cubit.isProductsLoading && cubit.products.products.isEmpty) {
      return const Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (cubit.productsError != null && cubit.products.products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                cubit.productsError!,
                textAlign: TextAlign.center,
                style: AppStyles.styleMedium14(context).copyWith(
                  color: isAppDarkMode() ? kDarkThirdColor : kLightThirdColor,
                ),
              ),
              12.sbh,
              IconButton(onPressed: cubit.fetchAllProducts, icon: const Icon(Icons.refresh)),
            ],
          ),
        ),
      );
    }

    if (cubit.products.products.isEmpty) {
      return Center(child: Text(l.notAvailable, style: AppStyles.styleMedium18(context)));
    }

    final rawCrossAxisCount = (context.screenWidth / 200).round();
    final crossAxisCount = rawCrossAxisCount < 1 ? 1 : (rawCrossAxisCount > 4 ? 4 : rawCrossAxisCount);

    return GridView.builder(
      padding: 24.psh,
      itemCount: cubit.products.products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        final product = cubit.products.products[index];
        return GestureDetector(
          onTap: () => router.push(AppRoutes.productDetails, extra: product),
          child: CustomProductItem(
            item: product,
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
  }
}
