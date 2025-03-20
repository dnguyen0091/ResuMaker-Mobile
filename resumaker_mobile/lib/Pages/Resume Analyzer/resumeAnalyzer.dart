import 'package:flutter/material.dart';

import '../../app_color.dart';
import './analysis.dart';
import './results.dart';
import './uploadPDF.dart';

// Define possible states for the analyzer
enum AnalyzerState {
  upload,
  analyzing,
  results
}

class ResumeAnalyzer extends StatefulWidget {
  const ResumeAnalyzer({Key? key}) : super(key: key);

  @override
  State<ResumeAnalyzer> createState() => _ResumeAnalyzerState();
}

class _ResumeAnalyzerState extends State<ResumeAnalyzer> {
  // Current state of the analyzer
  AnalyzerState _currentState = AnalyzerState.upload;
  
  // Store analysis results to pass between components
  Map<String, dynamic>? _analysisResults;

  // Handle successful upload and transition to results
  void _handleUploadSuccess(Map<String, dynamic> results) {
    setState(() {
      _analysisResults = results;
      // You can optionally show the analysis screen first
      _currentState = AnalyzerState.analyzing;
      
      // Simulate analysis process if needed
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _currentState = AnalyzerState.results;
          });
        }
      });
    });
  }

  // Reset the analyzer to upload state
  void _resetAnalyzer() {
    setState(() {
      _currentState = AnalyzerState.upload;
      _analysisResults = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.card,
        foregroundColor: AppColor.text,
        elevation: 0,
        title: Center(
          child: Text(
            _getPageTitle(),
            style: const TextStyle(
              color: AppColor.text,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Show back button only when not in upload state
        leading: _currentState != AnalyzerState.upload
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColor.text),
                onPressed: _resetAnalyzer,
              )
            : null,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildBody(),
      ),
    );
  }

  String _getPageTitle() {
    switch (_currentState) {
      case AnalyzerState.upload:
        return "Resume Analyzer";
      case AnalyzerState.analyzing:
        return "Analyzing Resume";
      case AnalyzerState.results:
        return "Analysis Results";
    }
  }

  Widget _buildBody() {
    switch (_currentState) {
      case AnalyzerState.upload:
        return UploadPDF(
          key: const ValueKey('upload'),
          onUploadSuccess: _handleUploadSuccess,
        );
      
      case AnalyzerState.analyzing:
        return Analysis(
          key: const ValueKey('analyzing'),
          analysisProgress: 0.5,
        );
      
      case AnalyzerState.results:
        // Check if results are null and handle it properly
        if (_analysisResults == null) {
          // If results are null, go back to upload state
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _currentState = AnalyzerState.upload;
            });
          });
          return const Center(
            key: ValueKey('loading'),
            child: CircularProgressIndicator(
              color: AppColor.accent,
            ),
          );
        }
        return Results(
          key: const ValueKey('results'),
          results: _analysisResults!,
          onAnalyzeAgain: _resetAnalyzer,
        );
    }
  }
}