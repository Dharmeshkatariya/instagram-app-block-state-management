import '../../export.dart';

class CustomTextField extends StatelessWidget {
  final bool obscureText;
  final TextInputType keyboardType;
  final String hintText;
  final Icon prefixIcon;
  final Icon? suffixIcon;
  final Color fillColor;
  final TextStyle textStyle;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    required this.fillColor,
    required this.textStyle,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: textStyle,
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      decoration: InputDecoration(
        fillColor: fillColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        prefixIconColor: AppColors.black,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
