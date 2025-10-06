import 'package:flutter/foundation.dart';
import '../models/booking_data.dart';


class BookingProvider with ChangeNotifier {
  final List<BookingData> _bookings = [];

  List<BookingData> get bookings => List.unmodifiable(_bookings);

  void addBooking(BookingData booking) {
    _bookings.add(booking);
    notifyListeners();
  }

  void removeBooking(String bookingId) {
    _bookings.removeWhere((booking) => booking.id == bookingId);
    notifyListeners();
  }

  void clearBookings() {
    _bookings.clear();
    notifyListeners();
  }

  BookingData? getBookingById(String id) {
    try {
      return _bookings.firstWhere((booking) => booking.id == id);
    } catch (e) {
      return null;
    }
  }

  int get bookingCount => _bookings.length;

  double get totalBookingValue {
    return _bookings.fold(0.0, (total, booking) => total + booking.total);
  }

  double get totalRevenue {
  return bookings.fold(0.0, (sum, booking) => sum + booking.total);
}
}