// import 'package:device_preview/device_preview.dart';
import 'package:e_commerce_final/core/utils/app_routes.dart';
import 'package:e_commerce_final/core/utils/app_theme.dart';
import 'package:e_commerce_final/core/utils/bloc_observer.dart';
import 'package:e_commerce_final/core/utils/constant.dart';
import 'package:e_commerce_final/core/utils/local_network.dart';
import 'package:e_commerce_final/core/utils/localizations.dart';
import 'package:e_commerce_final/generated/l10n.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/my_cart/presentation/cubit/my_card_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CachedHelper.init();
  Bloc.observer = MyBlocObserver();

  final appTheme = CachedHelper.getData(kAppTheme);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: appTheme == kDark
          ? Brightness.light
          : Brightness.dark,
    ),
  );

  // Lock device orientation to portrait mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(create: (_) => AuthCubit()..loadUser()),
          BlocProvider<MyCartCubit>(create: (_) => MyCartCubit()..loadCart()),
        ],
        child: MaterialApp.router(
          // builder: DevicePreview.appBuilder,
          debugShowCheckedModeBanner: false,
          title: 'Shopapay',
          theme: CachedHelper.getData(kAppTheme) == kDark
              ? darkTheme
              : lightTheme,
          // Ensure we always provide a valid locale language code (default to 'en')
          locale: Locale(
            (CachedHelper.getData(kAppLanguage) as String?) ?? 'en',
          ),
          localeResolutionCallback: localResolutionCallback,
          localizationsDelegates: localizationsDelegates(),
          supportedLocales: S.delegate.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
  }
}
