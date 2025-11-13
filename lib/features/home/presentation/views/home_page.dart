import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_final/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:navy_wear/core/utils/extensions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/function/components.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/constant.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../shared/widgets/custom_product_item.dart';
import '../../../my_cart/presentation/cubit/my_card_cubit.dart';
import '../cubits/home_page_cubit/home_page_cubit.dart';
import '../cubits/home_page_cubit/home_page_state.dart';
import 'widgets/custom_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomePageCubit()..loadInitialData(),
      child: BlocBuilder<HomePageCubit, HomePageState>(
        builder: (BuildContext context, state) {
          var cubit = BlocProvider.of<HomePageCubit>(context);
          final l = S.of(context);
          final authState = context.watch<AuthCubit>().state;
          final userName = authState.user?.username ?? 'Guest';

          return Scaffold(
            key: cubit.scaffoldKey,
            appBar: _buildHomeAppBar(l, context, cubit, userName),
            drawer: const CustomDrawer(),
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverToBoxAdapter(child: _searchSection(context)),
                      SliverToBoxAdapter(
                        child: _sliderSection(l, context, cubit: cubit),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: SliverAppBarDelegate(
                          _categorySection(l, context, cubit: cubit),
                        ),
                      ),
                    ];
                  },
              body: _gridViewSection(cubit, context, l),
            ),
          );
        },
      ),
    );
  }

  Widget _categorySection(
    S l,
    BuildContext context, {
    required HomePageCubit cubit,
  }) {
    return Container(
      color: isAppDarkMode() ? kDarkColor : kWhiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          16.sbh,
          Padding(
            padding: 24.psh,
            child: Row(
              children: [
                Text(l.newFashion, style: AppStyles.styleSemiBold18(context)),
                const Spacer(),
                TextButton(
                  onPressed: () => router.push(AppRoutes.newFashion),
                  child: Text(
                    l.seeAll,
                    style: AppStyles.styleRegular14(context).copyWith(
                      color: isAppDarkMode()
                          ? kDarkPrimaryColor
                          : kLightPrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          8.sbh,
          CategoryItems(cubit: cubit),
          10.sbh,
        ],
      ),
    );
  }

  Widget _gridViewSection(HomePageCubit cubit, BuildContext context, S l) {
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
        child: Text(l.notAvailable, style: AppStyles.styleMedium18(context)),
      );
    }

    final rawCrossAxisCount = (context.screenWidth / 200).round();
    final crossAxisCount = rawCrossAxisCount < 1
        ? 1
        : (rawCrossAxisCount > 4 ? 4 : rawCrossAxisCount);

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      itemCount: cubit.products.products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.6, // Portrait aspect ratio for vertical images
      ),
      itemBuilder: (BuildContext context, int index) {
        final product = cubit.products.products[index];
        return GestureDetector(
          onTap: () {
            router.push(AppRoutes.productDetails, extra: product);
          },
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

  Widget _sliderSection(
    S l,
    BuildContext context, {
    required HomePageCubit cubit,
  }) {
    return Column(
      children: [
        Padding(
          padding: 24.psh,
          child: Row(
            children: [
              Text(l.newOffers, style: AppStyles.styleSemiBold18(context)),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  l.seeAll,
                  style: AppStyles.styleRegular14(context).copyWith(
                    color: isAppDarkMode()
                        ? kDarkPrimaryColor
                        : kLightPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        8.sbh,
        CarouselSliderWidget(cubit: cubit),
      ],
    );
  }

  Padding _searchSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 20),
      child: CustomTextFormField(
        filled: true,
        hintText: S.of(context).search,
        prefix: SvgPicture.asset(
          AppImages.searchNormal,
          width: 24,
          height: 24,
          fit: BoxFit.scaleDown,
          colorFilter: ColorFilter.mode(
            isAppDarkMode() ? kDarkSecondColor : kLightSecondColor,
            BlendMode.srcIn,
          ),
        ),
        suffix: SvgPicture.asset(
          AppImages.filter,
          width: 24,
          height: 24,
          fit: BoxFit.scaleDown,
          colorFilter: ColorFilter.mode(
            isAppDarkMode() ? kDarkThirdColor : kLightThirdColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  AppBar _buildHomeAppBar(
    S l,
    BuildContext context,
    HomePageCubit cubit,
    String userName,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, $userName',
            style: AppStyles.styleSemiBold14(context),
          ),
          Text(
            l.letsExplore,
            style: AppStyles.styleRegular14(context).copyWith(
              color: isAppDarkMode()
                  ? kDarkThirdColor
                  : const Color(0xFF475467),
            ),
          ),
        ],
      ),
      leadingWidth: 61,
      leading: Padding(
        padding: 16.ps,
        child: InkWell(
          onTap: () => cubit.scaffoldKey.currentState?.openDrawer(),
          child: Image.asset(
            AppImages.avatar,
            fit: BoxFit.scaleDown,
            width: 45,
            height: 45,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: 16.pe,
          child: InkWell(
            onTap: () => router.push(AppRoutes.notifications),
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xffE8E7F1)),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppImages.notificationIcon,
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    isAppDarkMode() ? kDarkSecondColor : kLightSecondColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this.widget);

  final Widget widget;

  @override
  double get minExtent => 120;

  @override
  double get maxExtent => 120;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return widget;
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return true;
  }
}

class CarouselSliderWidget extends StatefulWidget {
  const CarouselSliderWidget({super.key, required this.cubit});

  final HomePageCubit cubit;

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CarouselSlider.builder(
            carouselController: widget.cubit.carouselController,
            itemCount: widget.cubit.imageCover.length,
            options: CarouselOptions(
              aspectRatio: 300 / 100,
              autoPlay: true,
              viewportFraction: .7,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  currentPageIndex = index;
                });
              },
            ),
            itemBuilder: (context, index, realIndex) {
              return Padding(
                padding: 14.pe,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.cubit.imageCover[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSmoothIndicator(
              onDotClicked: (index) {
                widget.cubit.carouselController?.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 350),
                );
                setState(() {
                  currentPageIndex = index;
                });
              },
              duration: const Duration(milliseconds: 350),
              activeIndex: currentPageIndex,
              count: widget.cubit.imageCover.length,
              effect: ExpandingDotsEffect(
                spacing: 4,
                dotHeight: 8,
                dotWidth: 8,
                dotColor: const Color(0xffE0E0E0),
                activeDotColor: isAppDarkMode()
                    ? kDarkPrimaryColor
                    : kLightPrimaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CategoryItems extends StatelessWidget {
  const CategoryItems({super.key, required this.cubit});

  final HomePageCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    if (cubit.isCategoriesLoading && cubit.categories.isEmpty) {
      return SizedBox(
        height: 35,
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: isAppDarkMode() ? kDarkPrimaryColor : kLightPrimaryColor,
            ),
          ),
        ),
      );
    }

    if (cubit.categoriesError != null && cubit.categories.isEmpty) {
      return Padding(
        padding: 24.psh,
        child: Row(
          children: [
            Expanded(
              child: Text(
                cubit.categoriesError!,
                style: AppStyles.styleMedium14(context).copyWith(
                  color: isAppDarkMode() ? kDarkThirdColor : kLightThirdColor,
                ),
              ),
            ),
            IconButton(
              onPressed: cubit.fetchCategories,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
      );
    }

    final List<String> labels = [
      l.all,
      ...cubit.parentCategories.map((category) => category.name),
    ];

    return SizedBox(
      height: 35,
      child: ListView.builder(
        padding: 24.ps,
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        itemBuilder: (context, index) {
          final isSelected = cubit.i == index;
          return Padding(
            padding: 10.pe,
            child: InkWell(
              onTap: () => cubit.selectCategory(index),
              borderRadius: BorderRadius.circular(40),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 35,
                decoration: BoxDecoration(
                  color: isSelected
                      ? isAppDarkMode()
                            ? kDarkPrimaryColor
                            : kLightPrimaryColor
                      : isAppDarkMode()
                      ? kDarkColor
                      : kWhiteColor,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: isAppDarkMode()
                        ? kDarkPrimaryColor
                        : kLightPrimaryColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    labels[index],
                    style: AppStyles.styleMedium14(context).copyWith(
                      color: isSelected
                          ? kWhiteColor
                          : (isAppDarkMode()
                                ? const Color(0xffDAE8FF)
                                : kLightPrimaryColor),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
