import 'dart:convert';

import 'package:cluves/models/repoClass/promotion.dart';
import 'package:expandable_text/expandable_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/club_types.dart';
import '../../../constants/palette.dart';
import '../../../models/repoClass/club.dart';
import '../../../models/repoClass/dio_client.dart';

part './top_panel.dart';
part './bottom_panel.dart';

class ClubScreen extends StatefulWidget {
  final String nick;
  const ClubScreen(this.nick, {Key? key}) : super(key: key);

  @override
  State<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends State<ClubScreen> {

  late Future<Club> _value;

  @override
  void initState() {
    var result = DioClient().fetchClub(widget.nick);
    _value = result;
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
      body: FutureBuilder<Club>(
        future: _value,
        builder: (context, snapshot) {
          if(snapshot.hasError || snapshot.data == Club.unknown()){
            print("In the dull section: ${snapshot.data}");
            return Center(
              child: Text(
                "Could not fetch the club information",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          } else if (snapshot.hasData) {
            print("In the ok section: ${snapshot.data}");
            Club club = snapshot.data!;
            print(club);
            if(club == Club.unknown()){
              return Center(
                child: Text(
                  "Could not fetch the club information",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TopPanel(club: club),
                Expanded(
                  child: BottomPanel(club: club),
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