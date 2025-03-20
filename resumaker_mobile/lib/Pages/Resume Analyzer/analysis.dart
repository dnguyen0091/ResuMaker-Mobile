import 'package:flutter/material.dart';

import '../../app_color.dart';
class Analysis extends StatelessWidget {
  final double analysisProgress;
  
  const Analysis({Key? key, required this.analysisProgress}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(value: analysisProgress, color: AppColor.accent ,),
          const SizedBox(height: 20),
          const Text("Analyzing your resume...", style: TextStyle(color: AppColor.text)),
        ],
      ),
    );
  }
}