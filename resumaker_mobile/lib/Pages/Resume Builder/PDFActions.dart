import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app_assets.dart'; // Ensure AppAssets is imported
import '../../app_color.dart'; // Ensure AppColor is imported

class PdfActionButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onDownload;

  const PdfActionButtons({
    Key? key,
    required this.onSave,
    required this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _circleButton(
          iconAsset: Assets.saveIcon,
          onPressed: onSave,
        ),
        const SizedBox(width: 24),
        _circleButton(
          iconAsset: Assets.downloadIcon,
          onPressed: onDownload,
        ),
      ],
    );
  }

  Widget _circleButton({
    required String iconAsset,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              AppColor.accent,
              AppColor.accent.withOpacity(0.7),
            ],
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            iconAsset,
            width: 28,
            height: 28,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}