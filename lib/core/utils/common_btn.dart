import '../../export.dart';
import '../colors/app_colors.dart';

class CustomButton extends StatefulWidget {
  const CustomButton(
      {super.key,
      required this.ontap,
      this.height,
      this.width,
      required this.text});

  final void Function()? ontap;
  final String text;
  final double? height;
  final double? width;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        alignment: Alignment.center,
        height: widget.height ?? 50.h,
        width: widget.width ?? 60.w,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          widget.text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
            fontFamily: poppinsRegular,
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class CommonButton extends StatefulWidget {
  const CommonButton(
      {super.key,
      this.ontap,
      required this.text,
      this.height,
      this.width,
      this.latterSpacing,
      this.color,
      this.padding,
      this.fontSize});

  final void Function()? ontap;
  final String text;
  final double? height;
  final double? width;
  final int? latterSpacing;
  final double? fontSize;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        padding: widget.padding ?? EdgeInsets.zero,
        alignment: Alignment.center,
        height: widget.height ?? 50.h,
        width: widget.width ?? 350.w,
        decoration: BoxDecoration(
          color: widget.color ?? AppColors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: widget.latterSpacing != null ? 2 : 2,
            color: AppColors.white,
            fontSize: widget.fontSize ?? 19.sp,
          ),
        ),
      ),
    );
  }
}

class ImageButton extends StatefulWidget {
  const ImageButton(
      {super.key,
      this.ontap,
      required this.imgPath,
      this.height,
      this.width,
      this.color});

  final void Function()? ontap;
  final String imgPath;
  final double? height;
  final double? width;
  final Color? color;

  @override
  State<ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        alignment: Alignment.center,
        height: widget.height ?? 50.h,
        width: widget.width ?? 350.w,
        decoration: BoxDecoration(
          color: widget.color ?? AppColors.appColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(
          widget.imgPath,
        ),
      ),
    );
  }
}
