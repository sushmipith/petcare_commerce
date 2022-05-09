class ProductModel {
  final String id;
  final String title;
  String imageURL;
  final String description;
  String rating;
  List<ReviewModel>? reviews;
  final double price;
  final String type;
  final String category;
  bool isFavourite;

  ProductModel(
      {required this.id,
      this.reviews,
      required this.type,
      required this.category,
      required this.title,
      required this.description,
      required this.rating,
      required this.price,
      required this.imageURL,
      this.isFavourite = false});

  factory ProductModel.fromJson(String prodId, Map<String, dynamic> json,
      Map<String, dynamic> favouriteData) {
    return ProductModel(
        id: prodId,
        type: json['type'],
        category: json['category'],
        title: json['title'],
        description: json['description'],
        rating: json['rating'],
        price: double.tryParse(json["price"].toString()) ?? 0,
        reviews: json['reviews'] == null
            ? null
            : List.from((json['reviews'] as List<dynamic>)
                .map((action) => ReviewModel.fromJson(action))),
        imageURL: json['imageURL'],
        isFavourite:
            favouriteData == null ? false : favouriteData[prodId] ?? false);
  }
}

class ReviewModel {
  String rating;
  String review;
  String userName;

  ReviewModel({
    required this.rating,
    required this.review,
    required this.userName,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
        rating: json['rating'],
        review: json['review'],
        userName: json['userName']);
  }
}
