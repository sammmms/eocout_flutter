import 'dart:io';

import 'package:eocout_flutter/models/user_data.dart';

class BusinessData {
  final String id;
  final String companyName;
  final String description;
  final List<File> images;
  final bool isAcceptPartyPromotionOrMarketing;
  final String location;
  final String name;
  final int price;
  final UserData profile;

  BusinessData({
    required this.id,
    required this.companyName,
    required this.description,
    this.images = const [],
    this.isAcceptPartyPromotionOrMarketing = false,
    this.location = "",
    this.name = "",
    this.price = 0,
    UserData? profile,
  }) : profile = profile ?? UserData();

  factory BusinessData.fromJson(Map<String, dynamic> json,
      [List<File>? images]) {
    return BusinessData(
      id: json['id'],
      companyName: json['company_name'],
      description: json['description'],
      images: images ?? [],
      isAcceptPartyPromotionOrMarketing:
          json['is_accept_party_promotion_or_marketing'] ?? false,
      location: json['location'],
      name: json['name'],
      price: int.tryParse(json['price']) ?? 0,
      profile: UserData.fromJson(json['profile']),
    );
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
    };
  }

  factory BusinessData.dummy() {
    return BusinessData(
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
    );
  }

  factory BusinessData.empty() {
    return BusinessData(
      id: "",
      companyName: "",
      description: "",
      images: [],
      isAcceptPartyPromotionOrMarketing: false,
      location: "",
      name: "",
      price: 0,
      profile: UserData.empty(),
    );
  }
}

class EditableBusinessData {
  String companyName;
  String description;
  List<File> images;
  bool isAcceptPartyPromotionOrMarketing;
  String location;
  String name;
  int price;

  EditableBusinessData({
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
