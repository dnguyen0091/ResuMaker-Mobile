import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../app_color.dart';

class UploadPDF extends StatefulWidget {
  final Function(Map<String, dynamic>) onUploadSuccess;

  const UploadPDF({Key? key, required this.onUploadSuccess}) : super(key: key);

  @override
  State<UploadPDF> createState() => _UploadPDFState();
}

class _UploadPDFState extends State<UploadPDF> {
  String fileName = '';
  bool isUploading = false;
  String? error;

  // Function to analyze PDF using the API
  Future<Map<String, dynamic>> analyzePdf(File file) async {
    const String apiUrl = 'https://resumaker-api.onrender.com/api/ai/analyze';
    
    try {
      print('Analyzing PDF: ${file.path}');
      
      // Create a multipart request
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      
      // Add the file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: fileName,
        )
      );
      
      print('Starting file upload: $fileName');
      
      // Send the request
      final response = await request.send();
      
      print('Response status: ${response.statusCode}');
      
      if (response.statusCode != 200) {
        // Try to parse error response
        final responseBody = await response.stream.bytesToString();
        try {
          final errorData = jsonDecode(responseBody);
          throw Exception(errorData['error'] ?? 'Server error: ${response.statusCode}');
        } catch (jsonError) {
          throw Exception('Server error: ${response.statusCode} ${response.reasonPhrase}');
        }
      }
      
      // Read response
      final responseBody = await response.stream.bytesToString();
      print('Response text length: ${responseBody.length}');
      
      if (responseBody.isEmpty) {
        throw Exception('Server returned an empty response');
      }
      
      // Parse JSON response
      try {
        final analysisData = jsonDecode(responseBody);
        return analysisData;
      } catch (jsonError) {
        print('JSON parse error: $jsonError');
        print('Raw response: $responseBody');
        throw Exception('Invalid response format from server');
      }
    } catch (e) {
      print('Error in analyzePdf: $e');
      throw e;
    }
  }

  Future<void> _pickFile() async {
    try {
      setState(() {
        isUploading = true;
        error = null;
      });
      
      FilePickerResult? result;
      try {
        result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );
      } catch (e) {
        print("Error picking file: $e");
        throw e;
      }

      if (result == null || result.files.isEmpty) {
        setState(() {
          isUploading = false;
        });
        return;
      }
      
      final file = result.files.first;
      
      if (!file.name.toLowerCase().endsWith('.pdf')) {
        setState(() {
          error = 'Please upload a PDF file';
          isUploading = false;
        });
        return;
      }
      
      setState(() {
        fileName = file.name;
      });
      
      // For mobile/desktop, prepare the file for upload
      if (!kIsWeb && file.path != null) {
        final File pickedFile = File(file.path!);
        
        try {
          // Call API to analyze the PDF
          final analysisResult = await analyzePdf(pickedFile);
          print('Analysis result: $analysisResult');
          
          // Use data from the analysis, with fallbacks for missing fields
          final analysisResults = {
            'fileName': file.name,
            'fileSize': file.size,
            'uploadDate': DateTime.now().toIso8601String(),
            'filePath': file.path,
            'score': analysisResult['overall_score'] ?? 75,
            'keywordMatch': analysisResult['keyword_match'] ?? 70,
            'formatting': analysisResult['formatting'] ?? 65,
            'contentQuality': analysisResult['content_quality'] ?? 60,
            'suggestions': analysisResult['suggestions'] ?? [
              "Unable to generate specific suggestions",
              "Try improving your resume's formatting and content"
            ]
          };
          
          widget.onUploadSuccess(analysisResults);
        } catch (e) {
          print('Error analyzing resume: $e');
          setState(() {
            error = 'Error analyzing resume: ${e.toString()}';
          });
        }
      } else {
        // For web - handle the bytes directly
        setState(() {
          error = 'Web uploads are not supported yet';
        });
      }
      
      setState(() {
        isUploading = false;
      });
    } catch (e) {
      print("Error in file pick process: $e");
      setState(() {
        isUploading = false;
        error = 'Error picking file: ${e.toString()}';
      });
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
          
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                error!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          
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