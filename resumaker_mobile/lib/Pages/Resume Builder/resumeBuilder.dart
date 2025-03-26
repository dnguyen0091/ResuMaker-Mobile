import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../app_color.dart';
import './PDFActions.dart'; // Ensure PdfActionButtons is imported
import 'FormBuilders/CustomSection.dart';
import 'FormBuilders/Education.dart';
import 'FormBuilders/Experience.dart';
import 'FormBuilders/PersonalInfo.dart';

class ResumeBuilder extends StatefulWidget {
  const ResumeBuilder({Key? key}) : super(key: key);

  @override
  State<ResumeBuilder> createState() => _ResumeBuilderState();
}

class _ResumeBuilderState extends State<ResumeBuilder> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 2; // Reduced from 3 to 2 pages
  
  final List<String> _pageTitles = [
    "Resume Builder", // Changed from "AI Chat Assistant"
    "PDF Preview"
  ];

  // Resume data
  Map<String, dynamic> _resumeData = {
    'personalInfo': {
      'name': '',
      'location': '',
      'email': '',
      'phone': '',
    },
    'experienceList': [
      ExperienceItem(
        id: 1,
        title: '',
        company: '',
        location: '',
        startDate: '',
        endDate: '',
        isCurrentPosition: false,
        bulletPoints: ['', '', ''],
      ),
    ],
    'educationList': [
      EducationItem(
        id: 1,
        school: '',
        location: '',
        degree: '',
        fieldOfStudy: '',
        startDate: '',
        endDate: '',
        bulletPoints: ['', ''],
      ),
    ],
    'customSections': <CustomSection>[], // Start with no custom sections
  };

  // Update functions for form data
  void _updatePersonalInfo(String key, String value) {
    setState(() {
      _resumeData['personalInfo'][key] = value;
    });
    print('Updated personal info: ${_resumeData['personalInfo']}');
  }

  void _updateExperienceList(List<ExperienceItem> experienceList) {
    setState(() {
      _resumeData['experienceList'] = experienceList;
    });
    print('Updated experience list: ${_resumeData['experienceList'].length} items');
  }

  void _updateEducationList(List<EducationItem> educationList) {
    setState(() {
      _resumeData['educationList'] = educationList;
    });
    print('Updated education list: ${_resumeData['educationList'].length} items');
  }

  void _updateCustomSection(int index, CustomSection updatedSection) {
    setState(() {
      _resumeData['customSections'][index] = updatedSection;
    });
    print('Updated custom section: ${updatedSection.title}');
  }

  void _addCustomSection() {
    setState(() {
      (_resumeData['customSections'] as List<CustomSection>).add(
        CustomSection(
          title: 'TAP TO EDIT',
          entries: [
            CustomSectionEntry(
              id: 1,
              bulletPoints: ['', '', ''],
            ),
          ],
        ),
      );
    });
    print('Added new custom section');
  }

  void _removeCustomSection(int index) {
    setState(() {
      (_resumeData['customSections'] as List<CustomSection>).removeAt(index);
    });
    print('Removed custom section at index $index');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.card,
        foregroundColor: AppColor.text,
        elevation: 0,
        title: Text(
          _pageTitles[_currentPage],
          style: const TextStyle(
            color: AppColor.text,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: _currentPage > 0
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _goToPreviousPage,
            )
          : null,
        actions: [
          if (_currentPage < _totalPages - 1)
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: _goToNextPage,
            ),
        ],
      ),
      body: Column(
        children: [
          // Page indicator dots
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_totalPages, (index) {
                return Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentPage 
                        ? AppColor.accent 
                        : AppColor.border,
                  ),
                );
              }),
            ),
          ),
          
          // PageView for the content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                // Page 1: Resume Builder Form (now the first page)
                _buildResumeFormPage(),
                
                // Page 2: PDF Preview
                _buildPdfPreviewPage(),
              ],
            ),
          ),
          
          // Bottom navigation buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back button
                if (_currentPage > 0)
                  ElevatedButton.icon(
                    onPressed: _goToPreviousPage,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Previous"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.userBubble,
                      foregroundColor: AppColor.text,
                    ),
                  )
                else
                  const SizedBox(width: 100),
                
                // Next button
                if (_currentPage < _totalPages - 1)
                  ElevatedButton.icon(
                    onPressed: _goToNextPage,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("Next"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.accent,
                      foregroundColor: AppColor.text,
                    ),
                  )
                else
                  // Place this widget in your bottom navigation section, for example:
                  PdfActionButtons(
                    onSave: () {
                      // Logic for saving the PDF to the database
                      print('Saving resume data: $_resumeData');
                    },
                    onDownload: _downloadPdf,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method 1: Generate the PDF document
Future<pw.Document> _generatePdf() async {
  final pdfDoc = pw.Document();

  pdfDoc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (pw.Context context) {
        // Retrieve resume sections from _resumeData
        final personalInfo = _resumeData['personalInfo'];
        final List<dynamic> educations = _resumeData['educationList'];
        final List<dynamic> experiences = _resumeData['experienceList'];
        final List<dynamic> customSections = _resumeData['customSections'];

        return <pw.Widget>[
          // Personal Info Header
          pw.Center(
            child: pw.Text(
              personalInfo['name']?.toString().isNotEmpty == true
                  ? personalInfo['name']
                  : 'Your Name',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(personalInfo['email'] ?? 'email@example.com'),
              pw.Text(" | "),
              pw.Text(personalInfo['phone'] ?? '(123) 456-7890'),
              pw.Text(" | "),
              pw.Text(personalInfo['location'] ?? 'City, State'),
            ],
          ),
          pw.SizedBox(height: 20),

          // Education Section
          pw.Text(
            "Education",
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(height: 4, thickness: 1),
          pw.SizedBox(height: 4),
          ...educations.map((edu) {
            // Handle null or empty values safely
            String school = '';
            String degree = '';
            String fieldOfStudy = '';
            String startDate = '';
            String endDate = '';
            List<String> bulletPoints = [];
            
            try {
              school = edu.school ?? '';
              degree = edu.degree ?? '';
              fieldOfStudy = edu.fieldOfStudy ?? '';
              startDate = edu.startDate ?? '';
              endDate = edu.endDate ?? '';
              
              // Handle bulletPoints safely
              if (edu.bulletPoints != null) {
                bulletPoints = List<String>.from(
                  edu.bulletPoints.map((point) => point?.toString() ?? '').toList()
                );
              }
            } catch (e) {
              print("Error processing education: $e");
            }
            
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 12),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    school.isNotEmpty ? school : 'University/School',
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    (degree.isNotEmpty || fieldOfStudy.isNotEmpty)
                        ? '${degree} ${fieldOfStudy}'.trim()
                        : 'Degree & Field',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                  ),
                  pw.Text(
                    '${startDate.isNotEmpty ? startDate : 'Start Date'} - ${endDate.isNotEmpty ? endDate : 'End Date'}',
                    style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 12),
                  ),
                  pw.SizedBox(height: 4),
                  ...bulletPoints.where((point) => point.isNotEmpty).map((point) {
                    return pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('• ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Expanded(child: pw.Text(point)),
                      ],
                    );
                  }).toList(),
                ],
              ),
            );
          }).toList(),

          // Experience Section
          pw.SizedBox(height: 20),
          pw.Text(
            "Experience",
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(height: 4, thickness: 1),
          pw.SizedBox(height: 4),
          ...experiences.map((exp) {
            // Handle null or empty values safely
            String title = '';
            String company = '';
            String startDate = '';
            String endDate = '';
            bool isCurrentPosition = false;
            List<String> bulletPoints = [];
            
            try {
              title = exp.title ?? '';
              company = exp.company ?? '';
              startDate = exp.startDate ?? '';
              endDate = exp.endDate ?? '';
              isCurrentPosition = exp.isCurrentPosition ?? false;
              
              // Handle bulletPoints safely
              if (exp.bulletPoints != null) {
                bulletPoints = List<String>.from(
                  exp.bulletPoints.map((point) => point?.toString() ?? '').toList()
                );
              }
            } catch (e) {
              print("Error processing experience: $e");
            }
            
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 12),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    title.isNotEmpty ? title : 'Position',
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    company.isNotEmpty ? company : 'Company',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                  ),
                  pw.Text(
                    '${startDate.isNotEmpty ? startDate : 'Start Date'} - ${isCurrentPosition ? 'Present' : (endDate.isNotEmpty ? endDate : 'End Date')}',
                    style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 12),
                  ),
                  pw.SizedBox(height: 4),
                  ...bulletPoints.where((point) => point.isNotEmpty).map((point) {
                    return pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('• ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Expanded(child: pw.Text(point)),
                      ],
                    );
                  }).toList(),
                ],
              ),
            );
          }).toList(),

          // Custom Sections
          pw.SizedBox(height: 20),
          ...customSections.map((section) {
            // Handle null or empty values safely
            String title = '';
            List<dynamic> entries = [];
            
            try {
              title = section.title ?? '';
              entries = section.entries ?? [];
            } catch (e) {
              print("Error processing custom section: $e");
            }
            
            if (title.isEmpty && entries.every((entry) {
              try {
                return entry.title?.isEmpty ?? true;
              } catch (e) {
                return true;
              }
            })) {
              return pw.Container();
            }
            
            return pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 16),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    title.isNotEmpty ? title : 'Custom Section',
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Divider(height: 4, thickness: 1),
                  pw.SizedBox(height: 4),
                  ...entries.map((entry) {
                    // Handle null or empty values safely
                    String entryTitle = '';
                    String subtitle = '';
                    String location = '';
                    String startDate = '';
                    String endDate = '';
                    bool isCurrentPosition = false;
                    List<String> bulletPoints = [];
                    
                    try {
                      entryTitle = entry.title ?? '';
                      subtitle = entry.subtitle ?? '';
                      location = entry.location ?? '';
                      startDate = entry.startDate ?? '';
                      endDate = entry.endDate ?? '';
                      isCurrentPosition = entry.isCurrentPosition ?? false;
                      
                      // Handle bulletPoints safely
                      if (entry.bulletPoints != null) {
                        bulletPoints = List<String>.from(
                          entry.bulletPoints.map((point) => point?.toString() ?? '').toList()
                        );
                      }
                    } catch (e) {
                      print("Error processing custom section entry: $e");
                    }
                    
                    if (entryTitle.isEmpty && bulletPoints.every((point) => point.isEmpty)) {
                      return pw.Container();
                    }
                    
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 12),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          if (entryTitle.isNotEmpty)
                            pw.Text(
                              entryTitle,
                              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                            ),
                          if (subtitle.isNotEmpty)
                            pw.Text(subtitle, style: pw.TextStyle(fontWeight: pw.FontWeight.normal)),
                          if (location.isNotEmpty)
                            pw.Text(location),
                          pw.Text(
                            '${startDate.isNotEmpty ? startDate : 'Start Date'} - ${isCurrentPosition ? 'Present' : (endDate.isNotEmpty ? endDate : 'End Date')}',
                            style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 12),
                          ),
                          pw.SizedBox(height: 4),
                          ...bulletPoints.where((point) => point.isNotEmpty).map((point) {
                            return pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('• ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                pw.Expanded(child: pw.Text(point)),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            );
          }).toList(),
        ];
      },
    ),
  );
  
  return pdfDoc;
}


Future<void> _savePdfToDevice(pw.Document pdfDoc) async {
  try {
    // Generate the PDF bytes
    final bytes = await pdfDoc.save();
    // Use path_provider to get the app's documents directory
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'resume_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    // Write the PDF bytes to file
    await file.writeAsBytes(bytes);
    
    // Print the path for debugging and show a success message
    print('PDF saved successfully at: $filePath');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PDF saved successfully! \nPath: $filePath'),
        duration: const Duration(seconds: 5),
      ),
    );
  } catch (e) {
    print('Error while saving PDF: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error saving PDF: ${e.toString()}'),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}

  // Method to call in your UI that combines both methods
  Future<void> _downloadPdf() async {
    try {
      // First generate the PDF
      final pdfDoc = await _generatePdf();
      
      // Then save it to the device
      await _savePdfToDevice(pdfDoc);
    } catch (e) {
      print('Error in PDF download process: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: ${e.toString()}'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
  // Page 1: Resume Builder Form
  Widget _buildResumeFormPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // AI explanation card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: AppColor.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColor.accent.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: AppColor.accent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "AI-Powered Resume Builder",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.text,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Click the \"Generate with AI\" buttons in each section to automatically create professional bullet points based on your information.",
                      style: TextStyle(
                        color: AppColor.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Personal Info Form
          PersonalInfo(
            personalInfo: Map<String, String>.from(_resumeData['personalInfo']),
            onChange: _updatePersonalInfo,
          ),
          
          // Education Form
          Education(
            educationList: List<EducationItem>.from(_resumeData['educationList']),
            setEducationList: _updateEducationList,
          ),

          // Experience Form
          Experience(
            experienceList: List<ExperienceItem>.from(_resumeData['experienceList']),
            setExperienceList: _updateExperienceList,
          ),
          
          // Custom Sections (with remove buttons)
          ..._resumeData['customSections'].asMap().entries.map((entry) {
            final index = entry.key;
            final section = entry.value as CustomSection;
            
            return Stack(
              key: ValueKey('custom-section-$index'),
              children: [
                // The custom section form
                CustomSectionForm(
                  section: section,
                  onChange: (updatedSection) => _updateCustomSection(index, updatedSection),
                ),
                
                // Remove button (positioned at top right)
                Positioned(
                  top: 16,
                  right: 16,
                  child: InkWell(
                    onTap: () => _removeCustomSection(index),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColor.userBubble,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
          
          // Add custom section button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ElevatedButton.icon(
              onPressed: _addCustomSection,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add Custom Section'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.accent,
                foregroundColor: AppColor.text,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          
          // Bottom padding for better scrolling
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // Page 2: PDF Preview (unchanged)
  Widget _buildPdfPreviewPage() {
    // Existing PDF preview code remains the same
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resume preview header
          const Text(
            "Resume Preview",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColor.text,
            ),
          ),
          const SizedBox(height: 24),
          
          // Preview container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Center(
                  child: Text(
                    _resumeData['personalInfo']['name']?.isNotEmpty == true ? _resumeData['personalInfo']['name'] : 'Your Name',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                
                
                // Contact info
                const SizedBox(height: 1),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        _resumeData['personalInfo']['email'] ?? 'email@example.com',
                        style: TextStyle(color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(" | ", style: TextStyle(color: Colors.grey[700])),
                    Flexible(
                      child: Text(
                        _resumeData['personalInfo']['phone'] ?? '(123) 456-7890',
                        style: TextStyle(color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(" | ", style: TextStyle(color: Colors.grey[700])),
                    Flexible(
                      child: Text(
                        _resumeData['personalInfo']['location'] ?? 'City, State',
                        style: TextStyle(color: Colors.grey[700]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 2),
                
                // Education section
                ..._buildPreviewEducation(),
                
                // Experience section
                ..._buildPreviewExperience(),
                
                // Custom sections
                ..._buildPreviewCustomSections(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper methods remain unchanged
  List<Widget> _buildPreviewExperience() {
    // Existing code
    final List<ExperienceItem> experiences = _resumeData['experienceList'];
    
    if (experiences.isEmpty) {
      return [];
    }
    
    return [
      Text(
        'Experience',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
      const Divider(height: 5, color: Colors.grey),
      const SizedBox(height: 4),
      
      ...experiences.map((exp) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    exp.title.isNotEmpty ? exp.title : 'Position',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Text(
                  '${exp.startDate.isNotEmpty ? exp.startDate : 'Start Date'} - ${exp.isCurrentPosition ? 'Present' : (exp.endDate.isNotEmpty ? exp.endDate : 'End Date')}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    exp.company.isNotEmpty ? exp.company : 'Company',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                if (exp.location.isNotEmpty)
                  Text(
                    exp.location,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
              ],
            ),         
            
            const SizedBox(height: 6),
            
            ...exp.bulletPoints.where((point) => point.isNotEmpty).map((point) {
              return Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        point,
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            
            const SizedBox(height: 12),
          ],
        );
      }).toList(),
      
      const SizedBox(height: 16),
    ];
  }
  
  List<Widget> _buildPreviewEducation() {
    // Existing code
    final List<EducationItem> educations = _resumeData['educationList'];
    
    if (educations.isEmpty) {
      return [];
    }
    
    return [
      Text(
        'Education',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
      const Divider(height: 5, color: Colors.grey),
      const SizedBox(height: 4),
      
      ...educations.map((edu) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    edu.school.isNotEmpty ? edu.school : 'University/School',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (edu.location.isNotEmpty)
                  Text(
                    edu.location,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (edu.degree.isNotEmpty || edu.fieldOfStudy.isNotEmpty)
                  Expanded(
                    child: Text(
                      '${edu.degree.isNotEmpty ? edu.degree : ''} ${edu.fieldOfStudy.isNotEmpty ? 'in ' + edu.fieldOfStudy : ''}'.trim(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                if (edu.startDate.isNotEmpty || edu.endDate.isNotEmpty)
                  Text(
                    '${edu.startDate.isNotEmpty ? edu.startDate : 'Start Date'} - ${edu.endDate.isNotEmpty ? edu.endDate : 'End Date'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 3),
            
            ...edu.bulletPoints.where((point) => point.isNotEmpty).map((point) {
              return Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        point,
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            
            const SizedBox(height: 12),
          ],
        );
      }).toList(),
      
      const SizedBox(height: 16),
    ];
  }
  
  List<Widget> _buildPreviewCustomSections() {
    // Existing code
    final List<CustomSection> customSections = _resumeData['customSections'];
    
    if (customSections.isEmpty) {
      return [];
    }
    
    List<Widget> sectionsWidgets = [];
    
    for (final section in customSections) {
      if (section.title.isEmpty && section.entries.every((entry) => entry.title.isEmpty)) {
        continue; // Skip empty sections
      }
      
      sectionsWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section.title.isNotEmpty ? section.title : 'Custom Section',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const Divider(
              height: 5,
              thickness: 1,
              color: Colors.grey,
            ),
          ],
        ),
      );
      
      sectionsWidgets.add(const SizedBox(height: 4));
      
      for (final entry in section.entries) {
        if (entry.title.isEmpty && entry.bulletPoints.every((point) => point.isEmpty)) {
          continue; // Skip empty entries
        }
        
        sectionsWidgets.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (entry.title.isNotEmpty)
                    Expanded(
                      child: Text(
                        entry.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  if (entry.startDate.isNotEmpty || entry.endDate.isNotEmpty)
                    Text(
                      '${entry.startDate.isNotEmpty ? entry.startDate : 'Start Date'} - ${entry.isCurrentPosition ? 'Present' : (entry.endDate.isNotEmpty ? entry.endDate : 'End Date')}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (entry.subtitle.isNotEmpty)
                    Expanded(
                      child: Text(
                        entry.subtitle,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  if (entry.location.isNotEmpty)
                    Text(
                      entry.location,
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                ],
              ),
              
              
              const SizedBox(height: 6),
              
              ...entry.bulletPoints.where((point) => point.isNotEmpty).map((point) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          point,
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              
              const SizedBox(height: 12),
            ],
          ),
        );
      }
      
      sectionsWidgets.add(const SizedBox(height: 16));
    }
    
    return sectionsWidgets;
  }
}