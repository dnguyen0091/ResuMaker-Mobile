import 'package:flutter/material.dart';

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
  
  @override
  void initState() {
    super.initState();
    _fetchResumes();
  }
  
  Future<void> _fetchResumes() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // This would be replaced with your actual API call
      // Example: final response = await http.get(Uri.parse('your-api-endpoint'));
      

      await Future.delayed(const Duration(milliseconds: 800));
      
      // Mock data for testing
      final mockResumes = List.generate(
        10, 
        (index) => ResumeData(
          id: 'resume_$index',
          name: 'Resume ${index + 1}',
          createdAt: DateTime.now().subtract(Duration(days: index * 3)),
        )
      );
      
      setState(() {
        _resumes = mockResumes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
      debugPrint('Error fetching resumes: $e');
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
                        : _resumes.isEmpty
                          ? Center(
                              child: Text(
                                'No saved resumes found',
                                style: TextStyle(color: AppColor.secondaryText),
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
  
  void _viewResume(ResumeData resume) {
    // Navigate to resume view
    debugPrint('Viewing resume: ${resume.name}');
    // Navigator.push(
    //   context, 
    //   MaterialPageRoute(
    //     builder: (context) => ResumeViewPage(resumeId: resume.id),
    //   ),
    // );
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
}

// Data model for resumes
class ResumeData {
  final String id;
  final String name;
  final DateTime createdAt; // Kept for data model, but not displayed
  
  ResumeData({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  
  // Factory constructor to create a ResumeData from JSON
  factory ResumeData.fromJson(Map<String, dynamic> json) {
    return ResumeData(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}