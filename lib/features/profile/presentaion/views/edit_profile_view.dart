import 'package:e_commerce_final/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/function/components.dart';
import '../../../../core/function/custom_app_bar.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/constant.dart';
import '../../../../core/widgets/custom_buttons.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../generated/l10n.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.user;
    _nameController = TextEditingController(text: user?.username ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    return Scaffold(
      appBar: customAppBar(context, l.editProfile),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.error && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message!)),
            );
          }
          if (state.status == AuthStatus.authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: 24.psh,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  24.sbh,
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            AppImages.profileImg,
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {},
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: const ShapeDecoration(
                                color: Color(0xFFF6F8FA),
                                shape: OvalBorder(),
                              ),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 17,
                                color: isAppDarkMode()
                                    ? kDarkPrimaryColor
                                    : kLightPrimaryColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  28.sbh,
                  Text(
                    l.name,
                    style: AppStyles.styleMedium14(context).copyWith(
                      color: isAppDarkMode()
                          ? kDarkSecondColor
                          : const Color(0xff555555),
                    ),
                  ),
                  8.sbh,
                  CustomTextFormField(
                    controller: _nameController,
                    filled: true,
                    hintText: l.enterYourName,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l.name;
                      }
                      return null;
                    },
                  ),
                  16.sbh,
                  Text(
                    l.email,
                    style: AppStyles.styleMedium14(context).copyWith(
                      color: isAppDarkMode()
                          ? kDarkSecondColor
                          : const Color(0xff555555),
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
                        return l.email;
                      }
                      final regex =
                          RegExp(r'^[\w\.\-]+@gmail\.com$', caseSensitive: false);
                      if (!regex.hasMatch(email)) {
                        return 'Please enter a valid Gmail address';
                      }
                      return null;
                    },
                  ),
                  16.sbh,
                  Text(
                    l.address,
                    style: AppStyles.styleMedium14(context).copyWith(
                      color: isAppDarkMode()
                          ? kDarkSecondColor
                          : const Color(0xff555555),
                    ),
                  ),
                  8.sbh,
                  CustomTextFormField(
                    controller: _addressController,
                    filled: true,
                    hintText: l.enterYourAddress,
                  ),
                  16.sbh,
                  Text(
                    l.password,
                    style: AppStyles.styleMedium14(context).copyWith(
                      color: isAppDarkMode()
                          ? kDarkSecondColor
                          : const Color(0xff555555),
                    ),
                  ),
                  8.sbh,
                  CustomTextFormField(
                    controller: _passwordController,
                    prefix: const Icon(Icons.lock_outline),
                    suffix: const Icon(Icons.remove_red_eye_outlined),
                    filled: true,
                    hintText: l.password,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                  ),
                  56.sbh,
                  CustomButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        context.read<AuthCubit>().updateProfile(
                              username: _nameController.text,
                              email: _emailController.text,
                              address: _addressController.text,
                              password: _passwordController.text,
                            );
                      }
                    },
                    child: Text(
                      l.save,
                      style: AppStyles.styleMedium16(context)
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  8.sbh,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
