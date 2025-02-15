import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:instagram_dharmesh_bloc_demo/features/auth/presentation/bloc/cubit/auth_cubit.dart';
import 'package:instagram_dharmesh_bloc_demo/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/colors/app_colors.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/style_resource/custom_textstyle.dart';
import '../../../../core/utils/strings_manager.dart';
import '../../../../core/utils/toast_show.dart';
import '../../../../core/widget/custom_widgets/custom_elevated_button.dart';
import '../../../../models/user_personal_info.dart';
import '../../../user/presentation/bloc/add_new_user_cubit.dart';
import '../../../user/presentation/bloc/searchAboutUser/search_about_user_bloc.dart';
import '../../domain/entities/registered_user.dart';
import '../widgets/get_my_user_info.dart';
import '../widgets/register_widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final bool validateControllers = false;
  ValueNotifier<bool> validateEmail = ValueNotifier(false);
  ValueNotifier<bool> validatePassword = ValueNotifier(false);
  ValueNotifier<bool> rememberPassword = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return RegisterWidgets(
      fullNameController: fullNameController,
      customTextButton: customTextButton(),
      emailController: emailController,
      passwordController: passwordController,
      isThatLogIn: false,
      validateEmail: validateEmail,
      validatePassword: validatePassword,
      rememberPassword: rememberPassword,
    );
  }

  Widget customTextButton() {
    return ValueListenableBuilder(
      valueListenable: rememberPassword,
      builder: (context, bool rememberPasswordValue, child) =>
          ValueListenableBuilder(
        valueListenable: validateEmail,
        builder: (context, bool validateEmailValue, child) =>
            ValueListenableBuilder(
          valueListenable: validatePassword,
          builder: (context, bool validatePasswordValue, child) {
            bool validate = validatePasswordValue &&
                validateEmailValue &&
                rememberPasswordValue &&
                fullNameController.text.isNotEmpty;
            return CustomElevatedButton(
              isItDone: true,
              isThatSignIn: true,
              nameOfButton: StringsManager.next.tr,
              blueColor: validate ? true : false,
              onPressed: () async {
                if (validate) {
                  Get.to(
                      UserNamePage(
                        emailController: emailController,
                        passwordController: passwordController,
                        fullNameController: fullNameController,
                      ),
                      duration: const Duration(seconds: 0));
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class UserNamePage extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController fullNameController;
  const UserNamePage({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.fullNameController,
  }) : super(key: key);

  @override
  State<UserNamePage> createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  final userNameController = TextEditingController();

  bool isToastShowed = false;

  bool validateEdits = false;

  bool isFieldEmpty = true;

  bool isHeMovedToHome = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: isThatMobile
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: buildColumn(context),
                )
              : buildForWeb(context),
        ),
      ),
    );
  }

  Widget buildColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 100),
        Text(
          StringsManager.createUserName.tr,
          style:
              getMediumStyle(color: Theme.of(context).focusColor, fontSize: 15),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            StringsManager.addUserName.tr,
            style: getNormalStyle(color: AppColors.grey, fontSize: 13),
          ),
        ),
        Text(
          StringsManager.youCanChangeUserNameLater.tr,
          style: getNormalStyle(color: AppColors.grey, fontSize: 13),
        ),
        const SizedBox(height: 30),
        userNameTextField(context),
        customTextButton(),
      ],
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
        ],
      ),
    );
  }

  Widget userNameTextField(BuildContext context) {
    return BlocBuilder<SearchAboutUserBloc, SearchAboutUserState>(
      bloc: BlocProvider.of<SearchAboutUserBloc>(context)
        ..add(FindSpecificUser(userNameController.text,
            searchForSingleLetter: true)),
      buildWhen: (previous, current) =>
          previous != current && current is SearchAboutUserBlocLoaded,
      builder: (context, state) {
        List<UserPersonalInfo> usersWithSameUserName = [];

        if (state is SearchAboutUserBlocLoaded) {
          usersWithSameUserName = state.users;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
              validateEdits = usersWithSameUserName.isEmpty;
              if (userNameController.text.isEmpty) {
                validateEdits = false;
                isFieldEmpty = true;
              } else {
                isFieldEmpty = false;
              }
            }));
        return customTextField(context);
      },
    );
  }

  Padding customTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
      child: SizedBox(
        height: isThatMobile ? null : 37,
        width: double.infinity,
        child: TextField(
          controller: userNameController,
          cursorColor: AppColors.teal,
          style:
              getNormalStyle(color: Theme.of(context).focusColor, fontSize: 15),
          decoration: InputDecoration(
            hintText: StringsManager.username.tr,
            hintStyle: isThatMobile
                ? getNormalStyle(color: Theme.of(context).indicatorColor)
                : getNormalStyle(color: AppColors.black54, fontSize: 12),
            fillColor: const Color.fromARGB(48, 232, 232, 232),
            filled: true,
            focusedBorder: outlineInputBorder(),
            suffixIcon: isFieldEmpty
                ? null
                : (validateEdits ? rightIcon() : wrongIcon()),
            enabledBorder: outlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(
                horizontal: 10, vertical: isThatMobile ? 15 : 5),
            errorText: (isFieldEmpty || validateEdits)
                ? null
                : (isThatMobile ? StringsManager.thisUserNameExist.tr : null),
            errorStyle: getNormalStyle(color: AppColors.red),
          ),
          onChanged: (value) {
            SearchAboutUserBloc.get(context).add(FindSpecificUser(
                userNameController.text,
                searchForSingleLetter: true));
          },
        ),
      ),
    );
  }

  Icon rightIcon() {
    return const Icon(Icons.check_rounded, color: AppColors.green, size: 27);
  }

  Widget wrongIcon() {
    return Icon(
      Icons.close_rounded,
      color: AppColors.red,
      size: 27,
    );
  }

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(isThatMobile ? 5.0 : 1.0),
      borderSide: BorderSide(
          color: AppColors.lightGrey, width: isThatMobile ? 1.0 : 0.8),
    );
  }

  Widget customTextButton() {
    return Builder(builder: (context) {
      FireStoreAddNewUserCubit userCubit =
          FireStoreAddNewUserCubit.get(context);
      return BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is CubitAuthConfirmed) {
            addNewUser(state, userCubit);
            moveToMain(state);
          } else if (state is CubitAuthFailed && !isToastShowed) {
            ToastShow.toastStateError(state.error);
          }
        },
        buildWhen: (previous, current) => previous != current,
        builder: (context, authState) {
          return CustomElevatedButton(
            isItDone: authState is! CubitAuthConfirming,
            nameOfButton: StringsManager.signUp.tr,
            blueColor: validateEdits,
            onPressed: () async {
              AuthCubit authCubit = AuthCubit.get(context);

              if (validateEdits) {
                setState(() => isToastShowed = false);

                await authCubit.signUp(RegisteredUser(
                  email: widget.emailController.text,
                  password: widget.passwordController.text,
                ));
              }
            },
          );
        },
      );
    });
  }

  moveToMain(CubitAuthConfirmed authState) async {
    myPersonalId = authState.user.uid;

    final SharedPreferences sharePrefs = locator<SharedPreferences>();
    if (!isHeMovedToHome) {
      setState(() => isHeMovedToHome = true);

      if (myPersonalId.isNotEmpty) {
        await sharePrefs.setString("myPersonalId", myPersonalId);
        Get.offAll(GetMyPersonalInfo(myPersonalId: myPersonalId));
      } else {
        ToastShow.toast(StringsManager.somethingWrong.tr);
      }
    }
  }

  addNewUser(CubitAuthConfirmed authState, FireStoreAddNewUserCubit userCubit) {
    String fullName = widget.fullNameController.text;
    List<dynamic> charactersOfName = [];
    String nameOfLower = fullName.toLowerCase();

    for (int i = 0; i < nameOfLower.length; i++) {
      charactersOfName = charactersOfName + [nameOfLower.substring(0, i + 1)];
    }
    String userName = userNameController.text;
    UserPersonalInfo newUserInfo = UserPersonalInfo(
      name: fullName,
      charactersOfName: charactersOfName,
      email: authState.user.email!,
      userName: userName,
      bio: "",
      profileImageUrl: "",
      userId: authState.user.uid,

      /// I have some issues when set those as initial value in UserPersonalInfo
      followerPeople: const [],
      followedPeople: const [],
      posts: const [],
      chatsOfGroups: const [],
      stories: const [],
      lastThreePostUrls: const [],

      /// -------------------------------->
    );
    userCubit.addNewUser(newUserInfo);
  }
}
