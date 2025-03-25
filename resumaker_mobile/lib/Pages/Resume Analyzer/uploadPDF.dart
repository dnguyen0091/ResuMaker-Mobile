import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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
      setState(() {
        isUploading = true;
      });
      
      FilePickerResult? result;
      try {
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );
      } catch (e) {
        print("Error picking file: $e");
        if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
          // Mock data for development purposes
          setState(() {
            fileName = "sample_resume.pdf";
            isUploading = true;
          });
          
          await Future.delayed(const Duration(milliseconds: 1500));
          
          final analysisResults = {
            'fileName': "sample_resume.pdf",
            'fileSize': 1024 * 1024,
            'uploadDate': DateTime.now().toIso8601String(),
            'filePath': null,
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
          
          widget.onUploadSuccess(analysisResults);
          
          setState(() {
            isUploading = false;
          });
          return;
        } else {
          throw e;
        }
      }

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
      
      String? savedFilePath;
      // For mobile/desktop, copy the file to the app's document directory:
      if (!kIsWeb && file.path != null) {
        final File pickedFile = File(file.path!);
        Directory appDocDir = await getApplicationDocumentsDirectory();
        final String newPath = "${appDocDir.path}/${file.name}";
        final savedFile = await pickedFile.copy(newPath);
        savedFilePath = savedFile.path;
      } else {
        // For web or when file.path isn't available:
        savedFilePath = file.path;
      }
      
      // Simulate an upload delay or analysis delay:
      await Future.delayed(const Duration(milliseconds: 1500));

      final analysisResults = {
        'fileName': file.name,
        'fileSize': file.size,
        'uploadDate': DateTime.now().toIso8601String(),
        'filePath': savedFilePath,
        // Additional analysis results here.
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

      widget.onUploadSuccess(analysisResults);
      
      setState(() {
        isUploading = false;
      });
    } catch (e) {
      print("Error in file pick process: $e");
      setState(() {
        isUploading = false;
      });
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