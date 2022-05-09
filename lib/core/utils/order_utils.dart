enum OrderStatus { ongoing, delivered, cancelled }
enum DeliveryStatus { Pickup, Validate, Delivery, Payment, Completed }

class OrderUtils {
  static const List<String> cancelReasons = [
    'Receiver didn\'t answer call',
    'Taking too long',
    'Driver is Late',
    'Others',
  ];

  static const List<String> returnReasons = [
    'Package is defective',
    'Receiver is not available',
    'Receiver didnot answer call',
    'Others',
  ];
}
