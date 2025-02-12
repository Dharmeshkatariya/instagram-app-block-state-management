import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_dharmesh_bloc_demo/features/auth/presentation/bloc/cubit/auth_cubit.dart';

import '../../../../core/asset/asset.dart';
import '../../../../core/colors/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/routes/getnav.dart';
import '../../../../core/style_resource/custom_textstyle.dart';
import '../../../../core/translations/app_lang.dart';
import '../../../../core/utils/date_of_now.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/utils/toast_show.dart';
import '../../../../core/widget/circle_avatar_image/circle_avatar_of_profile_image.dart';
import '../../../../core/widget/custom_widgets/custom_circulars_progress.dart';
import '../../../../core/widget/custom_widgets/custom_linears_progress.dart';
import '../../../../core/widget/custom_widgets/custom_smart_refresh.dart';
import '../../../../core/widget/custom_widgets/custom_text_field.dart';
import '../../../../injection_container.dart';
import '../../../../models/message.dart';
import '../../../../models/user_personal_info.dart';
import '../../../user/domain/entities/sender_info.dart';
import '../../../user/presentation/bloc/user_info_cubit.dart';
import '../../../user/presentation/bloc/users_info_cubit.dart';
import '../../../user/presentation/bloc/users_info_reel_time/users_info_reel_time_bloc.dart';
import '../screen/sign_up_page.dart';
import 'or_text.dart';

class RegisterWidgets extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? fullNameController;
  final Widget customTextButton;
  final bool isThatLogIn;
  final ValueNotifier<bool> validateEmail;
  final ValueNotifier<bool> validatePassword;
  final ValueNotifier<bool>? rememberPassword;

  const RegisterWidgets({
    Key? key,
    required this.emailController,
    this.isThatLogIn = true,
    required this.passwordController,
    required this.customTextButton,
    this.fullNameController,
    this.rememberPassword,
    required this.validateEmail,
    required this.validatePassword,
  }) : super(key: key);

  @override
  State<RegisterWidgets> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<RegisterWidgets> {
  @override
  Widget build(BuildContext context) {
    return buildScaffold(context);
  }

  Scaffold buildScaffold(BuildContext context) {
    double height = MediaQuery.of(context).size.height - 50;
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: isThatMobile
              ? buildColumn(context, height: height)
              : buildForWeb(context),
        )),
      ),
    );
  }

  SizedBox buildForWeb(BuildContext context) {
    return SizedBox(
      width: 352,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 0.2),
            ),
            child: buildColumn(context),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 0.2),
            ),
            child: haveAccountRow(context),
          ),
        ],
      ),
    );
  }

  Widget buildColumn(BuildContext context, {double height = 400}) {
    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!widget.isThatLogIn) const Spacer(),
          SvgPicture.asset(
            instagramLogo,
            colorFilter:
                ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
            height: 50,
          ),
          const SizedBox(height: 30),
          _EmailTextFields(
            hint: StringsManager.email.tr,
            controller: widget.emailController,
            validate: widget.validateEmail,
            isThatLogin: widget.isThatLogIn,
          ),
          SizedBox(height: isThatMobile ? 15 : 6.5),
          if (!widget.isThatLogIn && widget.fullNameController != null) ...[
            CustomTextField(
              hint: StringsManager.fullName.tr,
              controller: widget.fullNameController!,
              isThatLogin: widget.isThatLogIn,
            ),
            SizedBox(height: isThatMobile ? 15 : 6.5),
          ],
          CustomTextField(
            hint: StringsManager.password.tr,
            controller: widget.passwordController,
            isThatEmail: false,
            validate: widget.validatePassword,
            isThatLogin: widget.isThatLogIn,
          ),
          if (!widget.isThatLogIn) ...[
            if (!isThatMobile) const SizedBox(height: 10),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isThatMobile ? 4 : 0,
                    vertical: isThatMobile ? 15 : 0),
                child: Row(
                  children: [
                    const SizedBox(width: 13),
                    ValueListenableBuilder(
                      valueListenable: widget.rememberPassword!,
                      builder: (context, bool rememberPasswordValue, child) =>
                          Checkbox(
                              value: rememberPasswordValue,
                              activeColor: isThatMobile
                                  ? AppColors.white
                                  : AppColors.blue,
                              fillColor: isThatMobile
                                  ? MaterialStateProperty.resolveWith(
                                      (Set states) {
                                      if (states
                                          .contains(MaterialState.disabled)) {
                                        return Colors.blue.withOpacity(.32);
                                      }
                                      return Colors.blue;
                                    })
                                  : null,
                              onChanged: (value) => widget.rememberPassword!
                                  .value = !rememberPasswordValue),
                    ),
                    Text(
                      StringsManager.rememberPassword.tr,
                      style:
                          getNormalStyle(color: Theme.of(context).focusColor),
                    )
                  ],
                ),
              ),
            ),
            if (!isThatMobile) const SizedBox(height: 10),
          ],
          widget.customTextButton,
          const SizedBox(height: 15),
          if (!widget.isThatLogIn) ...[
            const Spacer(),
            const Spacer(),
          ],
          if (isThatMobile) ...[
            const SizedBox(height: 8),
            if (!widget.isThatLogIn) ...[
              const Divider(color: AppColors.lightGrey, height: 1),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, left: 15.0, right: 15.0, bottom: 6.5),
                child: haveAccountRow(context),
              ),
            ] else ...[
              haveAccountRow(context),
              const OrText(),
            ],
          ],
          if (widget.isThatLogIn) ...[
            TextButton(
              onPressed: () {},
              child: Text(
                StringsManager.loginWithFacebook.tr,
                style: getNormalStyle(color: AppColors.blue),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Row haveAccountRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.isThatLogIn
              ? StringsManager.noAccount.tr
              : StringsManager.haveAccount.tr,
          style:
              getNormalStyle(fontSize: 13, color: Theme.of(context).focusColor),
        ),
        const SizedBox(width: 4),
        register(context),
      ],
    );
  }

  InkWell register(BuildContext context) {
    return InkWell(
        onTap: () {
          if (widget.isThatLogIn) {
            Get.to(const SignUpPage(),
                preventDuplicates: true,
                duration: const Duration(milliseconds: 0));
          } else {
            Get.back();
          }
        },
        child: registerText());
  }

  Text registerText() {
    return Text(
      widget.isThatLogIn ? StringsManager.signUp.tr : StringsManager.logIn.tr,
      style: getBoldStyle(fontSize: 13, color: AppColors.blue),
    );
  }
}

class _EmailTextFields extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final ValueNotifier<bool>? validate;
  final bool isThatLogin;
  const _EmailTextFields(
      {required this.controller,
      required this.hint,
      required this.isThatLogin,
      this.validate,
      Key? key})
      : super(key: key);

  @override
  State<_EmailTextFields> createState() => _EmailTextFieldsState();
}

class _EmailTextFieldsState extends State<_EmailTextFields> {
  String? errorMassage;
  @override
  void initState() {
    widget.controller.addListener(() {
      if (widget.controller.text.isNotEmpty) {
        errorMassage = _validateEmail();
      } else {
        errorMassage = null;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: isThatMobile ? null : 37,
        width: double.infinity,
        child: BlocConsumer<AuthCubit, AuthState>(
          bloc: AuthCubit.get(context)
            ..isThisEmailToken(email: widget.controller.text),
          listenWhen: (previous, current) =>
              previous != current && current is CubitEmailVerificationLoaded,
          listener: (context, state) {
            if (!widget.isThatLogin) {
              if (state is CubitEmailVerificationLoaded &&
                  state.isThisEmailToken) {
                errorMassage = "This email already exists.";
                widget.validate?.value = false;
              } else {
                errorMassage = null;
                widget.validate?.value = true;
              }
            }
          },
          buildWhen: (previous, current) =>
              previous != current && current is CubitEmailVerificationLoaded,
          builder: (context, state) {
            return TextFormField(
              controller: widget.controller,
              cursorColor: AppColors.teal,
              style: getNormalStyle(
                  color: Theme.of(context).focusColor, fontSize: 15),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: isThatMobile
                    ? getNormalStyle(color: Theme.of(context).indicatorColor)
                    : getNormalStyle(color: AppColors.black54, fontSize: 12),
                fillColor: const Color.fromARGB(48, 232, 232, 232),
                filled: true,
                focusedBorder: outlineInputBorder(),
                enabledBorder: outlineInputBorder(),
                errorStyle: getNormalStyle(color: AppColors.red),
                errorText: isThatMobile ? errorMassage : null,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: isThatMobile ? 15 : 5),
              ),
            );
          },
        ),
      ),
    );
  }

  String? _validateEmail() {
    if (!widget.controller.text.isEmail) {
      setState(() => widget.validate!.value = false);
      return 'Please make sure your email address is valid';
    } else {
      setState(() => widget.validate!.value = true);
      return null;
    }
  }

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(isThatMobile ? 5.0 : 1.0),
      borderSide: BorderSide(
          color: AppColors.lightGrey, width: isThatMobile ? 1.0 : 0.8),
    );
  }
}
