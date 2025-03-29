import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_color.dart';

class SavedResumes extends StatefulWidget {
  final VoidCallback closePopup;
  
  const SavedResumes({
    Key? key, 
    required this.closePopup
  }) : super(key: key);

  @override
  State<SavedResumes> createState() => _SavedResumesState();
}

class _SavedResumesState extends State<SavedResumes> {
  List<ResumeData> _resumes = [];
  bool _isLoading = true;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _fetchResumes();
  }
  
  Future<void> _fetchResumes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      // Get user email from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user');
      
      if (userData == null) {
        throw Exception('User data not found. Please log in again.');
      }
      
      final user = jsonDecode(userData);
      final String? userEmail = user['email'];
      
      if (userEmail == null || userEmail.isEmpty) {
        throw Exception('User email not found. Please log in again.');
      }
      
      // Get authorization token
      final token = prefs.getString('token');
      
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found. Please log in again.');
      }
      
      // API endpoint - same as in your web app
      const apiUrl = 'https://resumaker-api.onrender.com';
      final response = await http.get(
        Uri.parse('$apiUrl/api/resume/$userEmail/resumes'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to fetch resumes');
      }
      
      // Parse the response
      final List<dynamic> resumesJson = jsonDecode(response.body);
      final List<ResumeData> fetchedResumes = resumesJson.map((json) => ResumeData.fromJson(json)).toList();
      
      setState(() {
        _resumes = fetchedResumes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching resumes: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // View resume function - similar to handleViewResume in your web app
  Future<void> _viewResume(ResumeData resume) async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found. Please log in again.');
      }
      
      // API endpoint
      const apiUrl = 'https://resumaker-api.onrender.com';
      final response = await http.get(
        Uri.parse('$apiUrl/api/resume/view/${resume.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode != 200) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to fetch resume');
      }
      
      // Parse the response
      final resumeData = jsonDecode(response.body);
      
      if (resumeData['filePath'] == null) {
        throw Exception('Resume file path not found');
      }
      
      // Construct the full URL to the PDF file
      final pdfUrl = '$apiUrl${resumeData['filePath']}?token=$token';
      
      // Open the PDF in the browser/external viewer
      if (await canLaunch(pdfUrl)) {
        await launch(pdfUrl);
      } else {
        throw Exception('Could not launch $pdfUrl');
      }
    } catch (e) {
      print('Error viewing resume: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error viewing resume: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: GestureDetector(
        onTap: widget.closePopup, // Close on background tap
        behavior: HitTestBehavior.translucent,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black.withOpacity(0.5), // Semi-transparent background
          child: Center(
            child: GestureDetector(
              onTap: () {}, // Prevent closing when tapping inside the modal
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  color: AppColor.card,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Header with close button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Saved Resumes',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColor.text,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: AppColor.icon),
                            onPressed: widget.closePopup,
                          ),
                        ],
                      ),
                    ),
                    
                    Divider(height: 1, color: AppColor.border),
                    
                    // Resume list
                    Expanded(
                      child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColor.accent,
                            ),
                          )
                        : _error != null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 48,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Error loading resumes',
                                      style: TextStyle(
                                        color: AppColor.text,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      _error!,
                                      style: TextStyle(color: AppColor.secondaryText),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: _fetchResumes,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.accent,
                                        foregroundColor: AppColor.text,
                                      ),
                                      child: Text('Try Again'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : _resumes.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.description_outlined,
                                      color: AppColor.secondaryText,
                                      size: 48,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No saved resumes found',
                                      style: TextStyle(color: AppColor.secondaryText),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: GridView.builder(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.9, // Changed from 1.2 to 0.9 for more height
                                  ),
                                  itemCount: _resumes.length,
                                  itemBuilder: (context, index) {
                                    return ResumeCard(
                                      resumeData: _resumes[index],
                                      onView: () => _viewResume(_resumes[index]),
                                    );
                                  },
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResumeCard extends StatelessWidget {
  final ResumeData resumeData;
  final VoidCallback onView;
  
  const ResumeCard({
    Key? key,
    required this.resumeData,
    required this.onView,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.inputField,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.border),
      ),
      // Added padding to ensure content doesn't overflow
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Added to prevent expansion
        children: [
          // Reduced icon size slightly
          Icon(
            Icons.description,
            size: 36, // Reduced from 40
            color: AppColor.accent,
          ),
          const SizedBox(height: 8),
          // Ensure text doesn't overflow with ellipsis
          Flexible(
            child: Text(
              resumeData.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.text,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 4),
          // Add created date
          Flexible(
            child: Text(
              'Created: ${_formatDate(resumeData.createdAt)}',
              style: TextStyle(
                fontSize: 12,
                color: AppColor.secondaryText,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 12),
          // Made button more compact
          SizedBox(
            width: double.infinity, // Full width button
            height: 36,
            child: ElevatedButton(
              onPressed: onView,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.accent,
                foregroundColor: AppColor.text,
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: Text('View'),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to format date
  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

// Data model for resumes - updated to match the API response
class ResumeData {
  final String id;
  final String name;
  final DateTime createdAt;
  final String? filePath;
  
  ResumeData({
    required this.id,
    required this.name,
    required this.createdAt,
    this.filePath,
  });
  
  // Factory constructor to create a ResumeData from JSON
  factory ResumeData.fromJson(Map<String, dynamic> json) {
    return ResumeData(
      id: json['_id'] ?? '', // Using _id as in MongoDB
      name: json['fileName'] ?? 'Untitled Resume',
      createdAt: json['uploadedAt'] != null 
        ? DateTime.parse(json['uploadedAt']) 
        : DateTime.now(),
      filePath: json['filePath'],
    );
  }
}