import '../../export.dart';

class Utility {
  static Future<void> startLoading(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          children: [loader()],
        );
      },
    );
  }

  static Future<void> stopLoading(BuildContext context) async {
    Navigator.of(context).pop();
  }

  static Widget animationLoader() {
    return Lottie.asset(
      loadingLottieAnimation,
      height: 50.h,
      width: 50.w,
    );
  }

  static Widget loader() {
    return Center(
      child: SpinKitPulsingGrid(
        color: AppColors.navyBlue,
        size: 50,
      ),
    );
  }

  static showSnackBar(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: poppinsSemiBold,
            color: AppColors.white,
          ),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.appColor,
        clipBehavior: Clip.none,
        elevation: 0,
      ),
    );
  }

  static errorShowSnackBar({BuildContext? context, String? msg}) {
    ScaffoldMessenger.of(context!).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg ?? "txt_no_internet",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: poppinsSemiBold,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.red,
        clipBehavior: Clip.none,
        elevation: 0,
      ),
    );
  }
}
