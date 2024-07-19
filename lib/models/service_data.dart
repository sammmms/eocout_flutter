import 'dart:io';

import 'package:eocout_flutter/models/user_data.dart';

class ServiceData {
  final String id;
  final String companyName;
  final String description;
  final List<File> images;
  final bool isAcceptPartyPromotionOrMarketing;
  final String location;
  final String name;
  final int price;
  final UserData profile;
  final double averageRating;
  final int ratingCount;

  ServiceData({
    required this.id,
    required this.companyName,
    required this.description,
    this.images = const [],
    this.isAcceptPartyPromotionOrMarketing = false,
    this.location = "",
    this.name = "",
    this.price = 0,
    UserData? profile,
    this.averageRating = 0,
    this.ratingCount = 0,
  }) : profile = profile ?? UserData();

  factory ServiceData.fromJson(Map<String, dynamic> json,
      {List<File>? images, File? profilePic}) {
    return ServiceData(
        id: json['id'],
        companyName: json['company_name'],
        description: json['description'],
        images: images ?? [],
        isAcceptPartyPromotionOrMarketing:
            json['is_accept_party_promotion_or_marketing'] ?? false,
        location: json['location'],
        name: json['name'],
        price: int.tryParse(json['price']) ?? 0,
        profile: UserData.fromJson(
          json['profile'],
          profilePicture: profilePic,
        ),
        averageRating: json['average_rating'],
        ratingCount: json['rating_count']);
  }

  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'price': price,
      'description': description,
      'images': images,
      'is_accept_party_promotion_or_marketing':
          isAcceptPartyPromotionOrMarketing,
      'location': location,
      'name': name,
      'profile': profile.toJson(),
      'average_rating': averageRating,
      'rating_count': ratingCount,
    };
  }

  factory ServiceData.dummy() {
    return ServiceData(
      id: "1",
      companyName: "PT. Eocout",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi.",
      images: [],
      isAcceptPartyPromotionOrMarketing: true,
      location: "Jakarta",
      name: "Eocout",
      price: 1000000,
      profile: UserData.dummy(),
      averageRating: 4.5,
      ratingCount: 100,
    );
  }

  factory ServiceData.empty() {
    return ServiceData(
      id: "",
      companyName: "",
      description: "",
      images: [],
      isAcceptPartyPromotionOrMarketing: false,
      location: "",
      name: "",
      price: 0,
      profile: UserData.empty(),
      averageRating: 0,
      ratingCount: 0,
    );
  }
}

class EditableServiceData {
  String companyName;
  String description;
  List<File> images;
  bool isAcceptPartyPromotionOrMarketing;
  String location;
  String name;
  int price;

  EditableServiceData({
    this.companyName = "",
    this.description = "",
    List<File>? images,
    this.isAcceptPartyPromotionOrMarketing = false,
    this.location = "",
    this.name = "",
    this.price = 0,
  }) : images = images ?? [];

  Map<String, dynamic> toJson([List<String>? imageIds]) {
    return {
      'company_name': companyName,
      'price': price,
      'description': description,
      'is_accept_party_promotion_or_marketing':
          isAcceptPartyPromotionOrMarketing,
      'location': location,
      'name': name,
      "image_ids": imageIds,
    };
  }
}
