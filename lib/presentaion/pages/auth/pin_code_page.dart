import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tasks/application/core/utils/helpers/extension_functions/size_extension.dart';
import 'package:tasks/presentaion/widgets/app_size_boxes.dart';
import 'package:tasks/presentaion/widgets/snackbar_utill.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../application/config/app_assets.dart';
import '../../../application/config/design_system/app_colors.dart';
import '../../../application/config/design_system/app_style.dart';
import '../../../application/core/basecomponents/base_view_model_view.dart';
import '../../../application/core/di/app_component/app_component.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_loading_widget.dart';
import '../../widgets/custom_text.dart';
import 'bloc/authentication_bloc.dart';

@RoutePage()
class PinCodeVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;
  final String phoneCountry;

  const PinCodeVerificationPage({super.key, required this.phoneNumber, required this.countryCode, required this.phoneCountry});

  @override
  _PinCodeVerificationPageState createState() => _PinCodeVerificationPageState();
}

class _PinCodeVerificationPageState extends State<PinCodeVerificationPage> {
  final fieldsLength = 4;
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();

  // ..text = "123456";
  final bloc = locator<AuthenticationBloc>();
  late StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.black45,
        body: SingleChildScrollView(
          child: Column(
            children: [
              90.heightBox(),
              Image.asset(AppAssets.logo, width: 240),
              Container(
                margin: const EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 100),
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.all(Radius.circular(AppStyle.borderRadius)),
                ),
                child: Column(
                  children: <Widget>[
                    20.heightBox(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomText(
                        'تحقق من رقم الهاتف',
                        style: AppStyle.bold24.copyWith(color: AppColors.primaryWhite),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    10.heightBox(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomText(
                        'من فضلك ادخل الرمز المرسل إلي رقم الهاتف',
                        style: AppStyle.bold20.copyWith(color: AppColors.primaryWhite),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: CustomText(
                          widget.phoneNumber,
                          style: AppStyle.bold20.copyWith(color: AppColors.primaryWhite),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                        child: PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.bold),
                          length: fieldsLength,
                          obscureText: false,
                          obscuringCharacter: '*',
                          animationType: AnimationType.fade,
                          validator: (v) {
                            if (v != null && v.length < 4) {
                              return "";
                            } else {
                              return null;
                            }
                          },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(7),
                            fieldHeight: 70.w,
                            fieldWidth: 70.w,
                            activeFillColor: hasError ? AppColors.primaryWhite : AppColors.primaryWhite,
                            activeColor: AppColors.primaryWhite,
                            inactiveColor: AppColors.primaryWhite,
                            selectedColor: AppColors.primaryWhite,
                            disabledColor: AppColors.primaryWhite,
                            selectedFillColor: AppColors.primaryWhite,
                            inactiveFillColor: AppColors.primaryWhite,
                            errorBorderColor: AppColors.errorColor,
                            borderWidth: 0,
                            disabledBorderWidth: 0,
                            selectedBorderWidth: 0,
                            activeBorderWidth: 1,
                            errorBorderWidth: 1,
                            inactiveBorderWidth: 0,
                            inActiveBoxShadow: const [BoxShadow(offset: Offset(0, 1), color: Colors.black12, blurRadius: 10)],
                            activeBoxShadow: const [BoxShadow(offset: Offset(0, 1), color: Colors.black12, blurRadius: 10)],
                          ),
                          cursorColor: AppColors.primaryColor,
                          animationDuration: const Duration(milliseconds: 300),
                          textStyle: const TextStyle(color: AppColors.primaryBlack, fontSize: 24, height: 1.6),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          boxShadows: const [BoxShadow(offset: Offset(0, 1), color: Colors.black12, blurRadius: 10)],
                          onCompleted: (v) {
                            print("Completed");
                          },
                          // onTap: () {
                          //   print("Pressed");
                          // },
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            print("Allowing to paste $text");
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        hasError ? "*Please fill up all the cells properly" : "",
                        style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ),
                    CustomBlocConsumer<AuthenticationBloc, AuthenticationState>(
                      bloc: bloc,
                      listener: (context, state) {
                        if (state is LoginSuccess) {
                          //  context.router.pushAndPopUntil(LandingRoute(), predicate: (_) => false);
                        } else if (state is AuthenticationError) {
                          errorController.add(ErrorAnimationType.shake);
                          context.showMessage(isError: true, state.message);
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const LoadingWidget();
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomElevatedButton(
                                onPressed: () {
                                  formKey.currentState?.validate();
                                  // conditions for validating
                                  if (currentText.length != fieldsLength) {
                                    errorController.add(ErrorAnimationType.shake); // Triggering error shake animation
                                    setState(() {
                                      hasError = true;
                                    });
                                  } else {
                                    setState(() {
                                      hasError = false;
                                    });
                                    bloc.add(LoginEvent());
                                  }
                                },
                                title: 'تأكيد',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText('لم استلم الرمز؟', style: AppStyle.meduim16),
                        TextButton(
                          onPressed: () {},
                          child: CustomText(
                            'إعادة إرسال',
                            style: AppStyle.bold18.copyWith(color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
