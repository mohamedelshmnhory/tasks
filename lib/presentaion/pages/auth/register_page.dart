import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasks/presentaion/widgets/app_size_boxes.dart';
import 'package:tasks/presentaion/widgets/custom_text.dart';
import 'package:tasks/presentaion/widgets/snackbar_utill.dart';
import 'package:tasks/presentaion/widgets/app_text_field.dart';
import 'package:tasks/presentaion/widgets/custom_elevated_button.dart';
import 'package:tasks/presentaion/widgets/custom_loading_widget.dart';

import '../../../application/config/app_assets.dart';
import '../../../application/config/design_system/app_colors.dart';
import '../../../application/config/design_system/app_style.dart';
import '../../../application/core/basecomponents/base_view_model_view.dart';
import '../../../application/core/di/app_component/app_component.dart';
import '../../../application/core/utils/auto_router_setup/app_router.dart';
import '../../../data/entities/request_entities/auth/login/login_request.dart';
import 'bloc/authentication_bloc.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authBloc = locator<AuthenticationBloc>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.black45,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                70.heightBox(),
                // SvgPicture.asset(AppAssets.logo, width: 240),
                Icon(Icons.person, size: 100, color: AppColors.primaryWhite),
                Container(
                  margin: const EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 100),
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
                  ),
                  child: CustomBlocConsumer<AuthenticationBloc, AuthenticationState>(
                    bloc: authBloc,
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        context.router.replace(const ProjectsRoute());
                      } else if (state is AuthenticationError) {
                        context.showMessage(isError: true, state.message);
                      }
                    },
                    builder: (context, state) {
                      return Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            10.heightBox(),
                            CustomText(
                              'تسجيل حساب جديد',
                              textAlign: TextAlign.center,
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(color: AppColors.primaryWhite, fontWeight: FontWeight.w900),
                            ),
                            10.heightBox(),
                            AppTextField(
                              controller: nameController,
                              hintText: 'الاسم',
                              labelKey: 'الاسم',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'برجاء ادخال الاسم';
                                }
                                return null;
                              },
                            ),
                            10.heightBox(),
                            AppTextField(
                              controller: emailController,
                              hintText: 'البريد الإلكتروني',
                              labelKey: 'البريد الإلكتروني',
                              textInputType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'برجاء ادخال البريد الإلكتروني';
                                }
                                return null;
                              },
                            ),
                            10.heightBox(),
                            AppTextField(
                              controller: phoneController,
                              hintText: 'رقم الهاتف',
                              labelKey: 'رقم الهاتف',
                              textInputType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'برجاء ادخال رقم الهاتف';
                                }
                                return null;
                              },
                            ),
                            10.heightBox(),
                            AppTextField(
                              controller: passwordController,
                              hintText: 'كلمة المرور',
                              labelKey: 'كلمة المرور',
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'برجاء ادخال كلمة المرور';
                                }
                                if (value.length < 6) {
                                  return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                                }
                                return null;
                              },
                            ),
                            20.heightBox(),
                            state is RegisterLoading
                                ? const LoadingWidget()
                                : CustomElevatedButton(
                                    title: 'تسجيل',
                                    onPressed: () {
                                      if (formKey.currentState?.validate() ?? false) {
                                        authBloc.add(
                                          RegisterEvent(
                                            requestModel: LoginRequest(
                                              username: nameController.text,
                                              email: emailController.text,
                                              phone: phoneController.text,
                                              passwordHash: passwordController.text,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                            20.heightBox(),
                            TextButton(
                              onPressed: () {
                                context.router.replace(const LoginRoute());
                              },
                              child: const Text('لديك حساب بالفعل؟ تسجيل الدخول', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
