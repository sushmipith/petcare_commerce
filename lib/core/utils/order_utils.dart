enum OrderStatus { ongoing, delivered, cancelled }

/// Helper [OrderUtils] : OrderUtils for getting various constant for orders
class OrderUtils {
  static const List<String> cancelReasons = [
    'Misplaced Order',
    'Order taking too long to process',
    'Duplicated order',
    'Others',
  ];
}
