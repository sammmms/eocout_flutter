import 'package:eocout_flutter/models/review_data.dart';

class EventData {
  final String title;
  final String description;
  final String date;
  final String time;
  final String location;
  final String price;
  final String imageLink;
  final String reviewRating;
  final List<ReviewData> reviews;

  EventData({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.price,
    required this.imageLink,
    required this.reviewRating,
    required this.reviews,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      title: json['title'],
      description: json['description'],
      date: json['date'],
      time: json['time'],
      location: json['location'],
      price: json['price'],
      imageLink: json['imageLink'],
      reviewRating: json['reviewRating'],
      reviews:
          (json['reviews'] as List).map((e) => ReviewData.fromJson(e)).toList(),
    );
  }
}
