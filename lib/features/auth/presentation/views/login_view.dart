import 'package:e_commerce_final/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/function/components.dart';
import '../../../../core/function/custom_app_bar.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/constant.dart';
import '../../../../core/widgets/custom_buttons.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../generated/l10n.dart';
import '../../presentation/cubit/auth_cubit.dart';
import 'widgets/social_media_widgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthCubit>().login(
      identifier: _identifierController.text.trim(),
      password: _passwordController.text.trim(),
      remember: _rememberMe,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    return Scaffold(
      appBar: customAppBar(
        context,
        '',
        action: TextButton(
          onPressed: () {},
          child: Text(
            l.needHelp,
            style: AppStyles.styleRegular14(context).copyWith(
              color: isAppDarkMode()
                  ? const Color(0xff5A9BFF)
                  : kLightPrimaryColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.error && state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          }
          if (state.status == AuthStatus.authenticated) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l.welcomeBack)));
            router.go(AppRoutes.homeLayout);
          }
        },
        builder: (context, state) {
          final isLoading = state.status == AuthStatus.loading;
          return SingleChildScrollView(
            padding: 24.psh,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (context.screenHeight * .1).sbh,
                  Center(
                    child: Text(
                      l.welcomeBack,
                      style: AppStyles.styleSemiBold24(
                        context,
                      ).copyWith(color: isAppDarkMode() ? null : kDarkColor),
                    ),
                  ),
                  16.sbh,
                  Center(
                    child: Text(
                      l.logInToAccessYourPersonalized,
                      textAlign: TextAlign.center,
                      style: AppStyles.styleRegular16(context).copyWith(
                        color: isAppDarkMode()
                            ? const Color(0xffE8E8E8)
                            : const Color(0xff555555),
                      ),
                    ),
                  ),
                  24.sbh,
                  Text(
                    l.email,
                    style: AppStyles.styleMedium14(context).copyWith(
                      color: isAppDarkMode() ? null : kLightThirdColor,
                    ),
                  ),
                  8.sbh,
                  CustomTextFormField(
                    controller: _identifierController,
                    filled: true,
                    hintText: l.enterYourUsernameOrGmail,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l.identifierRequired;
                      }
                      return null;
                    },
                  ),
                  16.sbh,
                  Text(
                    l.password,
                    style: AppStyles.styleMedium14(context).copyWith(
                      color: isAppDarkMode() ? null : kLightThirdColor,
                    ),
                  ),
                  8.sbh,
                  CustomTextFormField(
                    controller: _passwordController,
                    filled: true,
                    obscureText: _obscurePassword,
                    hintText: l.password,
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: isAppDarkMode()
                            ? kDarkSecondColor
                            : kLightSecondColor,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l.passwordRequired;
                      }
                      if (value.trim().length < 8) {
                        return l.passwordAtLeast8Characters;
                      }
                      return null;
                    },
                  ),
                  8.sbh,
                  Row(
                    children: [
                      Checkbox(
                        shape: const CircleBorder(),
                        value: _rememberMe,
                        onChanged: (v) =>
                            setState(() => _rememberMe = v ?? false),
                      ),
                      Text(
                        l.rememberMe,
                        style: AppStyles.styleRegular14(context),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => router.push(AppRoutes.resetPassword),
                        child: Text(
                          l.forgetPassword,
                          style: AppStyles.styleRegular12(context).copyWith(
                            color: isAppDarkMode()
                                ? kDarkPrimaryColor
                                : kLightPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  16.sbh,
                  CustomButton(
                    onPressed: isLoading ? null : () => _submit(context),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            l.continuee,
                            style: AppStyles.styleMedium16(
                              context,
                            ).copyWith(color: Colors.white),
                          ),
                  ),
                  24.sbh,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          margin: 16.pe,
                          height: 1,
                          color: const Color(0xFFBDBDBD),
                        ),
                      ),
                      Text(
                        l.or,
                        style: AppStyles.styleMedium18(
                          context,
                        ).copyWith(color: const Color(0xff616161)),
                      ),
                      Expanded(
                        child: Container(
                          margin: 16.ps,
                          height: 1,
                          color: const Color(0xFFBDBDBD),
                        ),
                      ),
                    ],
                  ),
                  24.sbh,
                  buildSocialLoginButtons(context),
                  62.sbh,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l.dontHaveAccount,
                        style: AppStyles.styleRegular16(context),
                      ),
                      TextButton(
                        onPressed: () => router.push(AppRoutes.register),
                        child: Text(
                          l.register,
                          style: AppStyles.styleRegular14(context).copyWith(
                            color: isAppDarkMode()
                                ? kDarkPrimaryColor
                                : kLightPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  16.sbh,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
