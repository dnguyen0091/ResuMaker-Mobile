import 'package:flutter/material.dart';

import '../../app_color.dart';

class Results extends StatelessWidget {
  final Map<String, dynamic> results;
  final VoidCallback onAnalyzeAgain;
  
  const Results({
    Key? key, 
    required this.results, 
    required this.onAnalyzeAgain
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Resume Analysis Results",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColor.text
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Resume Preview Section
            _buildResumePreviewSection(),
            
            const SizedBox(height: 24),
            
            // Analysis Results Section
            _buildAnalysisSection(),
            
            const SizedBox(height: 32),
            
            // Analyze Again Button
            Center(
              child: ElevatedButton(
                onPressed: onAnalyzeAgain,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.accent,
                  foregroundColor: AppColor.text,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text("Analyze Another Resume"),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildResumePreviewSection() {
    return Card(
      color: AppColor.card,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColor.border, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Your Resume",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.text
                ),
              )
            ),
            const SizedBox(height: 16),
            
            // PDF Container - in a real app, you'd use a PDF viewer plugin
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.userBubble,
                border: Border.all(color: AppColor.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: results['filePath'] != null
                ? Center(
                    child: Text(
                      "PDF Preview would appear here",
                      style: TextStyle(color: AppColor.secondaryText),
                    ),
                  )
                : Center(
                    child: Text(
                      "No preview available",
                      style: TextStyle(color: AppColor.secondaryText),
                    ),
                  ),
            ),
            
            const SizedBox(height: 16),
            
            // File Info
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "File: ${results['fileName'] ?? 'Unknown'}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColor.text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Uploaded: ${_formatDate(results['uploadDate'])}",
                        style: const TextStyle(color: AppColor.secondaryText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAnalysisSection() {
    return Card(
      color: AppColor.card,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColor.border, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Analysis",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.text,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Overall Score
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColor.userBubble,
                      shape: BoxShape.circle,
                      border: Border.all(color: _getScoreColor(results['score']), width: 4),
                    ),
                    child: Center(
                      child: Text(
                        "${results['score']}%",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColor.text,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Overall Score",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColor.text,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Score Categories
            _buildScoreCategory("Keyword Match", results['keywordMatch'] ?? 0),
            const SizedBox(height: 16),
            _buildScoreCategory("Formatting", results['formatting'] ?? 0),
            const SizedBox(height: 16),
            _buildScoreCategory("Content Quality", results['contentQuality'] ?? 0),
            
            const SizedBox(height: 24),
            
            // Suggestions
            const Text(
              "Suggestions for Improvement",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.text,
              ),
            ),
            const SizedBox(height: 8),
            
            // Suggestions List
            ..._buildSuggestionsList(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildScoreCategory(String title, int score) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColor.text,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: score / 100,
                  backgroundColor: AppColor.userBubble,
                  color: _getScoreColor(score),
                  minHeight: 10,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "$score%",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColor.text,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  List<Widget> _buildSuggestionsList() {
    final suggestions = results['suggestions'] as List<dynamic>? ?? [];
    
    if (suggestions.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "No suggestions available", 
            style: TextStyle(color: AppColor.secondaryText),
          ),
        ),
      ];
    }
    
    return suggestions.map<Widget>((suggestion) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.arrow_right, size: 20, color: AppColor.accent),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                suggestion.toString(),
                style: const TextStyle(color: AppColor.text),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
  
  // Helper methods
  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateString);
      return '${date.month}/${date.day}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
  
  Color _getScoreColor(int? score) {
    if (score == null) return AppColor.border;
    
    if (score >= 80) return AppColor.accent; // Using theme accent for good scores
    if (score >= 60) return Colors.orange;
    return Colors.redAccent;
  }
}