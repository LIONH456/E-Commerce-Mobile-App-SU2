import 'package:e_commerce_final/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/function/components.dart';
import '../../core/utils/app_routes.dart';
import '../../core/utils/app_styles.dart';
import '../../core/utils/constant.dart';
import '../../generated/l10n.dart';
import '../home/data/models/product_model.dart';
import '../home/presentation/cubits/home_page_cubit/home_page_cubit.dart';
import '../home/presentation/cubits/home_page_cubit/home_page_state.dart';
import '../my_cart/presentation/cubit/my_card_cubit.dart';
import '../shared/widgets/custom_product_item.dart';

class TrendingView extends StatelessWidget {
  const TrendingView({super.key});

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    return BlocProvider(
      create: (_) => HomePageCubit()..loadInitialData(),
      child: BlocBuilder<HomePageCubit, HomePageState>(
        builder: (context, state) {
          final cubit = HomePageCubit.get(context);
          final isLoading = cubit.isProductsLoading && cubit.products.products.isEmpty;

          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 16,
                elevation: 0,
                backgroundColor:
                    isAppDarkMode() ? kLightSecondColor : Colors.transparent,
                bottom: TabBar(
                  indicatorColor:
                      isAppDarkMode() ? kDarkPrimaryColor : kLightPrimaryColor,
                  indicatorWeight: 3,
                  labelColor: isAppDarkMode()
                      ? kDarkSecondColor
                      : const Color(0xff222222),
                  unselectedLabelColor: isAppDarkMode()
                      ? kDarkSecondColor
                      : const Color(0xff222222),
                  labelStyle:
                      const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                  tabs: [
                    Tab(text: l.women),
                    Tab(text: l.men),
                    Tab(text: l.kids),
                  ],
                ),
              ),
              body: isLoading
                  ? const Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : TabBarView(
                      children: [
                        _TrendingGrid(slugs: const ['woman']),
                        _TrendingGrid(slugs: const ['men']),
                        _TrendingGrid(slugs: const ['girl', 'boy']),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _TrendingGrid extends StatelessWidget {
  const _TrendingGrid({required this.slugs});

  final List<String> slugs;

  @override
  Widget build(BuildContext context) {
    final cubit = HomePageCubit.get(context);
    final l = S.of(context);

    final List<ProductModel> products =
        cubit.getProductsForParentSlugs(slugs);

    if (cubit.productsError != null && products.isEmpty) {
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
              IconButton(
                onPressed: cubit.fetchAllProducts,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
      );
    }

    if (products.isEmpty) {
      return Center(
        child: Text(
          l.notAvailable,
          style: AppStyles.styleMedium18(context),
        ),
      );
    }

    final crossAxisCount = (context.screenWidth / 200).round();
    final safeCrossAxisCount =
        crossAxisCount < 1 ? 1 : (crossAxisCount > 4 ? 4 : crossAxisCount);

    return GridView.builder(
      padding: 24.psh,
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: safeCrossAxisCount,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (BuildContext context, int index) {
        final product = products[index];
        return GestureDetector(
          onTap: () =>
              router.push(AppRoutes.productDetails, extra: product),
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
