class DraftResponseProgress {
  final String taskId;
  final String status;
  final String? step;
  final String? suggestionText;
  final String? errorMessage;

  const DraftResponseProgress({
    required this.taskId,
    required this.status,
    this.step,
    this.suggestionText,
    this.errorMessage,
  });

  bool get isCompleted => status == 'completed';
  bool get isFailed => status == 'failed';
  bool get isInProgress =>
      status == 'pending' || status == 'in_progress' || status == 'processing';
}
