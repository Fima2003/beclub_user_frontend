import 'package:equatable/equatable.dart';

import './promotion.dart';

class Club extends Equatable{
  final String profileImage, type, name, website, description;
  final List<LoyaltyPromotion> promotions;

  const Club(
      {required this.profileImage,
      required this.type,
      required this.name,
      required this.website,
      required this.description,
      required this.promotions});

  factory Club.fromJson(Map<String, dynamic> data) => Club(
    profileImage: data['profile_image'],
    type: data['type'],
    website: data['website'],
    description: data['description'] ?? "Description",
    promotions: data['promotions'] != null ? List.from(data['promotions'].map((el) => LoyaltyPromotion(mediaUrl: el['mediaUrl'], description: el['description'], points: el['points']))) : <LoyaltyPromotion>[],
    name: data['name']
  );

  factory Club.unknown() => const Club(
      profileImage: "",
      type: "",
      website: "",
      description: "",
      promotions: <LoyaltyPromotion>[],
      name: ""
  );

  @override
  List<Object?> get props => [profileImage, type, name, website, description, promotions];

  @override
  String toString() {
    return "profileImage: $profileImage\ntype: $type\nwebsite: $website\ndescription: $description\npromotions: $promotions\nname: $name";
  }
}