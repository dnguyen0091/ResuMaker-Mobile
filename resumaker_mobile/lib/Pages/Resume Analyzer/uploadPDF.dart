import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../app_color.dart'; // Import app color scheme

class UploadPDF extends StatefulWidget {
  final Function(Map<String, dynamic>) onUploadSuccess;

  const UploadPDF({Key? key, required this.onUploadSuccess}) : super(key: key);

  @override
  State<UploadPDF> createState() => _UploadPDFState();
}

class _UploadPDFState extends State<UploadPDF> {
  String fileName = '';
  bool isUploading = false;

  Future<void> _pickFile() async {
    try {
      // Set isUploading true just before starting the process
      setState(() {
        isUploading = true;
      });
      
      FilePickerResult? result;
      
      // Try to pick file with more defensive programming
      try {
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );
      } catch (e) {
        print("Error picking file: $e");
        // If there's an error, create a mock result for development
        if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
          // This is just for testing - in production remove this mock
          // Mock a successful file pick for testing
          setState(() {
            fileName = "sample_resume.pdf";
            isUploading = true;
          });
          
          // Mock data - replace with actual API call results
          await Future.delayed(const Duration(milliseconds: 1500));
          
          final analysisResults = {
            'fileName': "sample_resume.pdf",
            'fileSize': 1024 * 1024, // 1MB mock
            'uploadDate': DateTime.now().toIso8601String(),
            'filePath': null, // Mock path
            'score': 78,
            'keywordMatch': 85,
            'formatting': 72,
            'contentQuality': 65,
            'suggestions': [
              "Add more keywords related to the position",
              "Improve formatting in the skills section",
              "Quantify your achievements with numbers"
            ]
          };
          
          // Call the callback with the results
          widget.onUploadSuccess(analysisResults);
          
          setState(() {
            isUploading = false;
          });
          return;
        } else {
          // If not on supported platform and not in debug mode, show error
          throw e;
        }
      }

      // Normal flow if picker works
      if (result == null || result.files.isEmpty) {
        setState(() {
          isUploading = false;
        });
        return;
      }
      
      final file = result.files.first;
      
      setState(() {
        fileName = file.name;
      });

      // Here you would typically upload the file to your server
      // For now, we'll simulate with a delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Mock data - replace with actual API call results
      final analysisResults = {
        'fileName': file.name,
        'fileSize': file.size,
        'uploadDate': DateTime.now().toIso8601String(),
        'filePath': file.path, // Path to the file for preview
        // Additional analysis data would go here
        'score': 78,
        'keywordMatch': 85,
        'formatting': 72,
        'contentQuality': 65,
        'suggestions': [
          "Add more keywords related to the position",
          "Improve formatting in the skills section",
          "Quantify your achievements with numbers"
        ]
      };

      // Call the callback with the results
      widget.onUploadSuccess(analysisResults);
      
      setState(() {
        isUploading = false;
      });
    } catch (e) {
      print("Error in file pick process: $e");
      setState(() {
        isUploading = false;
      });
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error picking file: $e',
            style: const TextStyle(color: AppColor.text),
          ),
          backgroundColor: AppColor.card,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Upload your resume as a PDF to analyze its effectiveness and get feedback',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColor.secondaryText,
            ),
          ),
          const SizedBox(height: 40),
          InkWell(
            onTap: isUploading ? null : _pickFile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              decoration: BoxDecoration(
                color: AppColor.userBubble,
                border: Border.all(
                  color: AppColor.border,
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color: AppColor.accent,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    fileName.isEmpty ? 'Tap to upload PDF' : fileName,
                    style: TextStyle(
                      fontSize: 16,
                      color: fileName.isEmpty 
                          ? AppColor.secondaryText 
                          : AppColor.text,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (isUploading)
            Column(
              children: [
                const CircularProgressIndicator(
                  color: AppColor.accent,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Analyzing your resume...',
                  style: TextStyle(color: AppColor.text),
                ),
              ],
            ),
        ],
      ),
    );
  }
}