import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasks/presentaion/widgets/app_size_boxes.dart';
import 'package:tasks/presentaion/widgets/custom_text.dart';
import 'package:tasks/presentaion/widgets/snackbar_utill.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

import '../../../application/config/app_assets.dart';
import '../../../application/config/design_system/app_colors.dart';
import '../../../application/config/design_system/app_style.dart';
import '../../../application/core/basecomponents/base_view_model_view.dart';
import '../../../application/core/di/app_component/app_component.dart';
import '../../../application/core/utils/auto_router_setup/app_router.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_loading_widget.dart';
import 'bloc/authentication_bloc.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<LoginPage> {
  final authBloc = locator<AuthenticationBloc>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final tooltipController = JustTheController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.black45,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            70.heightBox(),
            //  SvgPicture.asset(AppAssets.logo, width: 200),
            Icon(Icons.person, size: 100, color: AppColors.primaryColor),
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      10.heightBox(),
                      CustomText(
                        'دخول',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: AppColors.primaryWhite, fontWeight: FontWeight.w900),
                      ),
                      10.heightBox(),
                      CustomText(
                        'من فضلك ادخل اسم المستخدم وكلمة المرور لتسجيل الدخول',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: AppColors.primaryWhite, fontWeight: FontWeight.bold),
                      ),
                      20.heightBox(),
                      AppTextField(
                        controller: usernameController,
                        hintText: 'اسم المستخدم',
                        labelKey: 'اسم المستخدم',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'برجاء ادخال اسم المستخدم';
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
                      state is AuthLoading
                          ? const LoadingWidget()
                          : CustomElevatedButton(
                              title: 'تسجيل الدخول',
                              onPressed: () {
                                if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
                                  context.showMessage(isError: true, 'برجاء ادخال اسم المستخدم وكلمة المرور');
                                  return;
                                }
                                authBloc.add(LoginEvent(username: usernameController.text, password: passwordController.text));
                              },
                            ),
                      20.heightBox(),
                      TextButton(
                        onPressed: () {
                          context.router.replace(const RegisterRoute());
                        },
                        child: const Text('ليس لديك حساب؟ سجل الآن', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
