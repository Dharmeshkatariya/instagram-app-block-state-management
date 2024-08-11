import '../../export.dart';

class Common {
  static AppBar cmnAppBar({required String title}) {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColors.white,
      title: Text(
        title,
        style: TextStyle(fontSize: 17.h),
      ),
    );
  }

  static Widget bookCardNetworkImg(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
        height: 50.h,
        width: 100.w,
        maxWidthDiskCache: 5000,
        maxHeightDiskCache: 5000,
        // errorWidget: (context, url, error) => const Center(
        //   child: Icon(
        //     Icons.running_with_errors_sharp,
        //     size: 48,
        //     color: Colors.red,
        //   ),
        // ),
        progressIndicatorBuilder: (_, __, progress) =>
            Center(child: Utility.animationLoader()),
      ),
    );
  }

  static Widget cacheCarouselSlider(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
        height: 60.h,
        width: double.infinity,
        maxWidthDiskCache: 5000,
        maxHeightDiskCache: 5000,
        progressIndicatorBuilder: (_, __, progress) =>
            Center(child: Utility.animationLoader()),
      ),
    );
  }

  static String mobileNumber = "";

  static Widget forgotPassRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            // Get.toNamed(Routes.FORGOT_PASSWORD);
          },
          child: Text(
            "Forgot Password ?",
          ),
        ),
      ],
    );
  }

  static Widget accountHaveRow({
    required String account,
    required String sign,
    required Function()? onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          account,
        ),
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.only(left: 10.sp),
            child: Text(
              sign,
            ),
          ),
        )
      ],
    );
  }

  static Widget cmnPositionWidget({
    required void Function() ontap,
    required Widget createWidget,
  }) {
    return Positioned(
      bottom: 2.h,
      right: 2.w,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: ontap,
          child: CircleAvatar(
              backgroundColor: AppColors.grey,
              radius: 18.r,
              child: createWidget),
        ),
      ),
    );
  }

  static Widget cmnSvg(
      {required String img, double? h, double? w, Color? color}) {
    return SvgPicture.asset(
      img,
      height: h ?? 25.h,
      width: w ?? 35.w,
      color: color ?? Colors.white,
      fit: BoxFit.cover,
    );
  }

  static Widget circleAvatarUser(String img) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.grey,
          width: 0.6,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: AppColors.white,
        radius: 40.r,
        backgroundImage: AssetImage(img),
      ),
    );
  }

  static Widget circleNetworkImage(String userImage) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.grey,
          width: 1,
        ),
      ),
      child: CircleAvatar(
        backgroundColor: AppColors.white,
        radius: 40.r,
        backgroundImage: CachedNetworkImageProvider(userImage),
      ),
    );
  }
}
