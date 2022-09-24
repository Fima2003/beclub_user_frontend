import 'dart:convert';

import 'package:cluves/models/repoClass/promotion.dart';
import 'package:expandable_text/expandable_text.dart';

import '../../../logic/backend/api_calls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/club_types.dart';
import '../../../constants/palette.dart';

part './top_panel.dart';
part './bottom_panel.dart';

class ClubScreen extends StatefulWidget {
  final String nick;
  const ClubScreen(this.nick, {Key? key}) : super(key: key);

  @override
  State<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends State<ClubScreen> {

  late Future<dynamic> _value;

  @override
  void initState() {
    _value = fetchClub(widget.nick);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(
            'assets/icons/BackIcon.svg',
            width: 20,
            height: 20,
          ),
        ),
        title: Text(widget.nick, style: Theme.of(context).textTheme.bodyMedium),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _value,
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Center(
              child: Text(
                "Could not get the club information",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          } else if (snapshot.hasData) {
            var data = jsonDecode(snapshot.data.toString());
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TopPanel(
                  url: data['profile_image'] ?? "null",
                  type: data["type"] ?? "unknown",
                  name: data["name"] ?? "No name",
                  website: data["website"] ?? "no website",
                  description: data['description'] ?? "No description",
                ),
                Expanded(
                  child: BottomPanel(
                    type: data["type"] ?? "unknown",
                    promotions: data["promotions"] is List<dynamic> ? List<LoyaltyPromotion>.from(
                      data['promotions']?.map((el) => LoyaltyPromotion.fromJson(el))
                    ) ?? <LoyaltyPromotion>[
                        LoyaltyPromotion(mediaUrl: "https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?auto=compress&cs=tinysrgb&w=1600", description: "This is the description", points: 22),
                        LoyaltyPromotion(mediaUrl: "https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?auto=compress&cs=tinysrgb&w=1600", description: "This is the description", points: 22),
                        LoyaltyPromotion(mediaUrl: "https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?auto=compress&cs=tinysrgb&w=1600", description: "This is the description", points: 22),
                        LoyaltyPromotion(mediaUrl: "https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?auto=compress&cs=tinysrgb&w=1600", description: "This is the description", points: 22),
                        LoyaltyPromotion(mediaUrl: "https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?auto=compress&cs=tinysrgb&w=1600", description: "This is the description", points: 22),
                        LoyaltyPromotion(mediaUrl: "https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?auto=compress&cs=tinysrgb&w=1600", description: "This is the description", points: 22),
                        LoyaltyPromotion(mediaUrl: "https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?auto=compress&cs=tinysrgb&w=1600", description: "This is the description", points: 22),
                        LoyaltyPromotion(mediaUrl: "https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?auto=compress&cs=tinysrgb&w=1600", description: "This is the description", points: 22),
                        LoyaltyPromotion(mediaUrl: "https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?auto=compress&cs=tinysrgb&w=1600", description: "This is the description", points: 22),
                        LoyaltyPromotion(mediaUrl: "https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?auto=compress&cs=tinysrgb&w=1600", description: "This is the description", points: 22),
                        LoyaltyPromotion(mediaUrl: "https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?auto=compress&cs=tinysrgb&w=1600", description: "This is the description", points: 22),
                        LoyaltyPromotion(mediaUrl: "https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?auto=compress&cs=tinysrgb&w=1600", description: "This is the description", points: 22)
                      ] : [],
                  ),
                )
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: kBlack,
              ),
            );
          }
        },
      ),
    );
  }
}