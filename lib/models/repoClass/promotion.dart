class Promotion{
  final String mediaUrl;
  final String description;
  Promotion({required this.mediaUrl, required this.description});
}

class LoyaltyPromotion extends Promotion{
  final int points;
  LoyaltyPromotion({required super.mediaUrl, required super.description, required this.points});

  factory LoyaltyPromotion.fromJson(data) => LoyaltyPromotion(mediaUrl: data['media_url'], description: data['description'], points: data['points']);

}