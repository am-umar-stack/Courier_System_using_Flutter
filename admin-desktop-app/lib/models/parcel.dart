enum ParcelStatus { pending, inTransit, outForDelivery, delivered }

class Parcel {
  final String trackingNumber;
  final int senderId;
  final String receiverName;
  final String deliveryAddress;
  final ParcelStatus status;
  final int? currentHubId;
  final int? driverId;

  Parcel({
    required this.trackingNumber,
    required this.senderId,
    required this.receiverName,
    required this.deliveryAddress,
    required this.status,
    this.currentHubId,
    this.driverId,
  });

  factory Parcel.fromJson(Map<String, dynamic> json) {
    return Parcel(
      trackingNumber: json['tracking_number'],
      senderId: json['sender_id'],
      receiverName: json['receiver_name'],
      deliveryAddress: json['delivery_address'],
      status: ParcelStatus.values.firstWhere(
        (e) => e.name == _toCamelCase(json['current_status']),
        orElse: () => ParcelStatus.pending,
      ),
      currentHubId: json['current_hub_id'],
      driverId: json['driver_id'],
    );
  }

  static String _toCamelCase(String snake) {
    List<String> parts = snake.toLowerCase().split('_');
    if (parts.length < 2) return snake.toLowerCase();
    String camel = parts[0];
    for (int i = 1; i < parts.length; i++) {
      camel += parts[i][0].toUpperCase() + parts[i].substring(1);
    }
    return camel;
  }

  Map<String, dynamic> toJson() {
    return {
      'tracking_number': trackingNumber,
      'sender_id': senderId,
      'receiver_name': receiverName,
      'delivery_address': deliveryAddress,
      'current_status': status.name,
      'current_hub_id': currentHubId,
      'driver_id': driverId,
    };
  }
}
