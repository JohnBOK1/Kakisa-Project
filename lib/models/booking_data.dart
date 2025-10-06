class BookingData {
  final String id;
  final String fullName;
  final String address;
  final String email;
  final String phone;
  final String package;
  final String checkIn;
  final String checkOut;
  final int guests;
  final double total;
  final DateTime createdAt;

  BookingData({
    required this.id,
    required this.fullName,
    required this.address,
    required this.email,
    required this.phone,
    required this.package,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.total,
    required this.createdAt, 
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'address': address,
      'email': email,
      'phone': phone,
      'package': package,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'guests': guests,
      'total': total,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      id: json['id'],
      fullName: json['fullName'],
      address: json['address'],
      email: json['email'],
      phone: json['phone'],
      package: json['package'],
      checkIn: json['checkIn'],
      checkOut: json['checkOut'],
      guests: json['guests'],
      total: json['total'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']), 
    );
  }

  BookingData copyWith({
    String? id,
    String? fullName,
    String? address,
    String? email,
    String? phone,
    String? package,
    String? checkIn,
    String? checkOut,
    int? guests,
    double? total,
    DateTime? createdAt, 
  }) {
    return BookingData(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      package: package ?? this.package,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      guests: guests ?? this.guests,
      total: total ?? this.total,
      createdAt: DateTime.now(), 
    );
  }
}