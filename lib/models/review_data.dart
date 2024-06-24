class ReviewData {
  final String userId;
  final String review;
  final String date;
  final double rating;

  ReviewData(
      {required this.userId,
      required this.review,
      required this.date,
      required this.rating});

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
        userId: json['userId'],
        review: json['review'],
        date: json['date'],
        rating: json['rating']);
  }
}
