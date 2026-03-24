import 'package:flutter/material.dart';
import '../../../constants/colors.dart';

class AIAnalysisPanel extends StatelessWidget {
  final Animation<Offset> slideAnimation;
  final VoidCallback onClose;

  const AIAnalysisPanel({
    required this.slideAnimation,
    required this.onClose,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(-4, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
              decoration: BoxDecoration(
                color: AppColors.messengerBlue.withOpacity(0.05),
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'AI Analysis',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: onClose,
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sentiment Analysis
                    _buildAnalysisSection(
                      title: 'Sentiment Analysis',
                      icon: Icons.sentiment_satisfied_rounded,
                      children: [
                        _buildSentimentItem(
                          label: 'Positive',
                          percentage: 65,
                          color: const Color(0xFF34C759),
                        ),
                        const SizedBox(height: 12),
                        _buildSentimentItem(
                          label: 'Neutral',
                          percentage: 25,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        _buildSentimentItem(
                          label: 'Negative',
                          percentage: 10,
                          color: const Color(0xFFFF3B30),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Priority Assessment
                    _buildAnalysisSection(
                      title: 'Priority Assessment',
                      icon: Icons.priority_high_rounded,
                      children: [
                        _buildPriorityItem(
                          label: 'Urgency Level',
                          value: 'HIGH',
                          color: const Color(0xFFFF3B30),
                        ),
                        const SizedBox(height: 12),
                        _buildPriorityItem(
                          label: 'Category',
                          value: 'Technical Support',
                          color: AppColors.messengerBlue,
                        ),
                        const SizedBox(height: 12),
                        _buildPriorityItem(
                          label: 'Response Time',
                          value: '< 5 minutes',
                          color: const Color(0xFF34C759),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Key Insights
                    _buildAnalysisSection(
                      title: 'Key Insights',
                      icon: Icons.lightbulb_rounded,
                      children: [
                        _buildInsightItem('User is experiencing an issue'),
                        const SizedBox(height: 10),
                        _buildInsightItem(
                          'Needs immediate technical assistance',
                        ),
                        const SizedBox(height: 10),
                        _buildInsightItem(
                          'High satisfaction expected after resolution',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.messengerBlue, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildSentimentItem({
    required String label,
    required int percentage,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 6,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.fromLTRB(0, 6, 8, 0),
          decoration: const BoxDecoration(
            color: AppColors.messengerBlue,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
