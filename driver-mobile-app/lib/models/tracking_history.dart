class TrackingHistory {
  final int id;
  final String trackingNumber;
  final String statusMessage;
  final int updatedBy;
  final DateTime timestamp;

  TrackingHistory({
    required this.id,
    required this.trackingNumber,
    required this.statusMessage,
    required this.updatedBy,
    required this.timestamp,
  });

  factory TrackingHistory.fromJson(Map<String, dynamic> json) {
    return TrackingHistory(
      id: json['history_id'],
      trackingNumber: json['tracking_number'],
      statusMessage: json['status_message'],
      updatedBy: json['updated_by'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'history_id': id,
      'tracking_number': trackingNumber,
      'status_message': statusMessage,
      'updated_by': updatedBy,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
