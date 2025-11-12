import 'package:e_commerce_final/core/utils/constant.dart';

String resolveMediaUrl(String? path) {
  if (path == null) {
    return '';
  }

  final normalized = path.trim();
  if (normalized.isEmpty) {
    return '';
  }

  if (normalized.startsWith('http')) {
    return normalized;
  }

  if (normalized.startsWith('/')) {
    return '$kMediaBaseUrl${normalized.substring(1)}';
  }

  return '$kMediaBaseUrl$normalized';
}
