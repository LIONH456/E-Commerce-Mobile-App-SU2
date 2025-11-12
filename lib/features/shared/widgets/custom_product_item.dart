import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/function/components.dart';
import '../../../core/function/get_responsive_font_size.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/utils/constant.dart';
import '../../home/data/models/product_model.dart';

class CustomProductItem extends StatelessWidget {
  final ProductModel item;
  final bool isFavorite;

  const CustomProductItem({
    required this.item,
    super.key,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildProductImage(context),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (item.discountPercentage != null &&
                            item.discountPercentage! > 0)
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isAppDarkMode()
                                    ? kDarkPrimaryColor
                                    : kLightPrimaryColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 5,
                                ),
                                child: Text(
                                  "${item.discountPercentage}% off",
                                  style: AppStyles.styleMedium12(context)
                                      .copyWith(
                                        color: kWhiteColor,
                                        fontSize: getResponsiveFontSize(
                                          context,
                                          fontSize: 8,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: ShapeDecoration(
                              color: isAppDarkMode()
                                  ? kBlackColor
                                  : Colors.white,
                              shape: const OvalBorder(),
                              shadows: [
                                BoxShadow(
                                  color: isAppDarkMode()
                                      ? kBlackColor.withOpacity(.08)
                                      : const Color(0x14000000),
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: isFavorite
                                ? Icon(
                                    Icons.favorite_border_outlined,
                                    size: 16,
                                    color: isAppDarkMode()
                                        ? kDarkSecondColor
                                        : kLightThirdColor,
                                  )
                                : Center(
                                    child: SvgPicture.asset(
                                      AppImages.bag,
                                      width: 18,
                                      colorFilter: ColorFilter.mode(
                                        isAppDarkMode()
                                            ? kDarkSecondColor
                                            : kLightThirdColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppStyles.styleMedium14(context).copyWith(
            color: isAppDarkMode() ? kDarkThirdColor : kLightThirdColor,
          ),
        ),
        Row(
          children: [
            Text(
              '\$${_formatPrice(item.price)}',
              style: AppStyles.styleSemiBold14(context),
            ),
            if (item.beforeDiscount != null &&
                item.beforeDiscount! > item.price) ...[
              const SizedBox(width: 8),
              Text(
                '\$${_formatPrice(item.beforeDiscount!)}',
                style: AppStyles.styleMedium10(context).copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: isAppDarkMode()
                      ? kDarkPrimaryColor
                      : kLightPrimaryColor,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildProductImage(BuildContext context) {
    if (item.image.isEmpty) {
      return _buildPlaceholder();
    }

    if (item.image.startsWith('http')) {
      return Image.network(
        item.image,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }

    return Image.asset(
      item.image,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: isAppDarkMode()
          ? kDarkColor.withOpacity(.4)
          : const Color(0xffF5F5F5),
      child: Icon(
        Icons.image_not_supported_outlined,
        color: isAppDarkMode()
            ? kDarkThirdColor
            : kLightThirdColor.withOpacity(.7),
      ),
    );
  }

  String _formatPrice(double value) {
    final isWhole = value.truncateToDouble() == value;
    return isWhole ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
  }
}
