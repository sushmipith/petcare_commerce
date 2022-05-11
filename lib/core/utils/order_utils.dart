enum OrderStatus { ongoing, delivered, cancelled }

class OrderUtils {
  static const List<String> cancelReasons = [
    'Misplaced Order',
    'Order taking too long to process',
    'Duplicated order',
    'Others',
  ];
}
