import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../colors/app_colors.dart';

class ToastShow {
  static toast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.black,
        textColor: AppColors.white);
  }

  static toastStateError(dynamic state) {
    String error;

    // Check if the state has an error property and is a String
    if (state is String) {
      // Directly use the state if it is a string
      error = state;
    } else if (state is FirebaseAuthException) {
      // Handle FirebaseAuthException
      error = state.message ?? 'Unknown error occurred';
    } else if (state is FirebaseException) {
      // Handle FirebaseException
      error = state.message ?? 'Unknown error occurred';
    } else {
      try {
        // Attempt to parse the error if it's in a specific format
        error = state.error?.split(RegExp(r']'))[1] ?? 'Unknown error occurred';
      } catch (e) {
        // Default error message if parsing fails
        error = state.error?.toString() ?? 'Unknown error occurred';
      }
    }

    if (kDebugMode) {
      print("=========> $error !!!!!!the error in toast show!!!");
    }

    ToastShow.toast(error);
  }

// static toastStateError(dynamic state) {
  //   String error;
  //   try {
  //     error = state.error.split(RegExp(r']'))[1];
  //   } catch (e) {
  //     error = state.error;
  //   }
  //   if (kDebugMode) print("=========> $error !!!!!!the error in toast show!!!");
  //
  //   ToastShow.toast(error);
  // }
}
