enum OrderStatus { ongoing, delivered, cancelled }
enum DeliveryStatus { Pickup, Validate, Delivery, Payment, Completed }

class OrderUtils {
  static const List<String> cancelReasons = [
    'Misplaced Order',
    'Order taking too long to process',
    'Duplicated order',
    'Others',
  ];
}
