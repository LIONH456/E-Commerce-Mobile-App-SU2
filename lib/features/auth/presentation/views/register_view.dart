import 'package:e_commerce_final/core/utils/extensions.dart';
import 'package:flutter/gestures.dart';
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

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _acceptTerms = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context, S l) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.pleaseAcceptTermsAndConditions)));
      return;
    }
    context.read<AuthCubit>().register(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
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
              color: isAppDarkMode() ? kDarkPrimaryColor : kLightPrimaryColor,
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l.accountCreatedSuccessfully)),
            );
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
                      l.registerYourNewAccount,
                      textAlign: TextAlign.center,
                      style: AppStyles.styleSemiBold24(context).copyWith(
                        color: isAppDarkMode() ? kDarkSecondColor : kDarkColor,
                      ),
                    ),
                  ),
                  16.sbh,
                  Center(
                    child: Text(
                      l.enterYourInformationBelow,
                      textAlign: TextAlign.center,
                      style: AppStyles.styleRegular16(context).copyWith(
                        color: isAppDarkMode()
                            ? const Color(0xffE8E8E8)
                            : const Color(0xff555555),
                      ),
                    ),
                  ),
                  16.sbh,
                  Text(
                    l.name,
                    style: AppStyles.styleMedium14(context).copyWith(
                      color: isAppDarkMode()
                          ? kDarkThirdColor
                          : kLightThirdColor,
                    ),
                  ),
                  8.sbh,
                  CustomTextFormField(
                    controller: _usernameController,
                    filled: true,
                    hintText: l.enterYourName,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l.usernameRequired;
                      }
                      return null;
                    },
                  ),
                  16.sbh,
                  Text(
                    l.email,
                    style: AppStyles.styleMedium14(context).copyWith(
                      color: isAppDarkMode()
                          ? kDarkThirdColor
                          : kLightThirdColor,
                    ),
                  ),
                  8.sbh,
                  CustomTextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    filled: true,
                    hintText: l.enterYourEmail,
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (email.isEmpty) {
                        return l.emailRequired;
                      }
                      final regex = RegExp(
                        r'^[\w\.\-]+@gmail\.com$',
                        caseSensitive: false,
                      );
                      if (!regex.hasMatch(email)) {
                        return l.invalidGmailAddress;
                      }
                      return null;
                    },
                  ),
                  16.sbh,
                  Text(
                    l.password,
                    style: AppStyles.styleMedium14(context).copyWith(
                      color: isAppDarkMode()
                          ? kDarkThirdColor
                          : kLightThirdColor,
                    ),
                  ),
                  8.sbh,
                  CustomTextFormField(
                    controller: _passwordController,
                    filled: true,
                    hintText: l.password,
                    obscureText: _obscurePassword,
                    prefix: const Icon(Icons.lock_outline),
                    suffix: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (value) {
                      final password = value?.trim() ?? '';
                      if (password.isEmpty) {
                        return l.passwordRequired;
                      }
                      if (password.length < 8) {
                        return l.passwordAtLeast8Characters;
                      }
                      return null;
                    },
                  ),
                  8.sbh,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Checkbox(
                        shape: const CircleBorder(),
                        value: _acceptTerms,
                        onChanged: (value) {
                          setState(() => _acceptTerms = value ?? false);
                        },
                      ),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            text: l.byCreatingAccountYouAgreeToOur,
                            style: AppStyles.styleRegular14(context),
                            children: [
                              TextSpan(
                                text: l.termsAndConditions,
                                style: AppStyles.styleRegular14(context)
                                    .copyWith(
                                      color: isAppDarkMode()
                                          ? kDarkPrimaryColor
                                          : kLightPrimaryColor,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  24.sbh,
                  CustomButton(
                    onPressed: isLoading ? null : () => _submit(context, l),
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
                            l.createAccount,
                            style: AppStyles.styleMedium16(
                              context,
                            ).copyWith(color: Colors.white),
                          ),
                  ),
                  16.sbh,
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
                  16.sbh,
                  buildSocialLoginButtons(context),
                  20.sbh,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l.dontHaveAccount,
                        style: AppStyles.styleRegular16(context),
                      ),
                      TextButton(
                        onPressed: () => router.push(AppRoutes.login),
                        child: Text(
                          'Login',
                          style: AppStyles.styleRegular14(context).copyWith(
                            color: isAppDarkMode()
                                ? kDarkPrimaryColor
                                : kLightPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
