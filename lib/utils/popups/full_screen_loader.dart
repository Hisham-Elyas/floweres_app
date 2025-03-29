import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';
import '../constants/sizes.dart';

/// A utility class for managing a full-screen loading dialog.
class HFullScreenLoader {
  /// Open a full-screen loading dialog with a given text and animation.
  /// This method doesn't return anything.
  ///
  /// Parameters:
  ///   - text: The text to be displayed in the loading dialog.
  ///   - animation: The Lottie animation to be shown.
  // static void openLoadingDialog(String text, String animation) {
  //   showDialog(
  //     context:
  //         Get.overlayContext!, // Use Get.overlayContext for overlay dialogs
  //     barrierDismissible:
  //         false, // The dialog can't be dismissed by tapping outside it
  //     builder: (_) => PopScope(
  //       canPop: false, // Disable popping with the back button
  //       child: Container(
  //         color: HHelperFunctions.isDarkMode(Get.context!)
  //             ? HColors.dark
  //             : HColors.white,
  //         width: double.infinity,
  //         height: double.infinity,
  //         child: Column(
  //           children: [
  //             const SizedBox(height: 250), // Adjust the spacing as needed
  //             HAnimationLoaderWidget(text: text, animation: animation),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  static void popUpCircular() {
    Get.defaultDialog(
      title: '',
      onWillPop: () async => false,
      content: const HCircularLoader(),
      backgroundColor: Colors.transparent,
    );
  }

  /// Stop the currently open loading dialog.
  /// This method doesn't return anything.
  static stopLoading() {
    Navigator.of(Get.overlayContext!)
        .pop(); // Close the dialog using the Navigator
  }
}

class HCircularLoader extends StatelessWidget {
  /// Default constructor for the HCircularLoader.
  ///
  /// Parameters:
  ///   - foregroundColor: The color of the circular loader.
  ///   - backgroundColor: The background color of the circular loader.
  const HCircularLoader({
    super.key,
    this.foregroundColor = HColors.white,
    this.backgroundColor = HColors.primary,
  });

  final Color? foregroundColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(HSizes.lg),
      decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle), // Circular background
      child: Center(
        child: CircularProgressIndicator(
            color: foregroundColor,
            backgroundColor: Colors.transparent), // Circular loader
      ),
    );
  }
}
