import 'dart:async';
import 'dart:convert';

import 'package:cluves/presentation/screens/mainScreen/personal_screen.dart';
import 'package:cluves/presentation/screens/mainScreen/promotions_screen.dart';
import 'package:cluves/presentation/screens/mainScreen/qr_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../../constants/palette.dart';
import '../../../constants/club_types.dart';
import '../../../logic/backend/api_calls.dart';
import '../../../presentation/screens/clubScreen/club_screen.dart';

part 'search_screen.dart';
part 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _selectedIndex = 0;
  final List<Widget> screens = [const QrScreen(), const SearchScreen(), const PromotionsScreen(), const PersonalScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/icons/Navigation/QR.svg"),
              activeIcon: SimpleShadow(
                opacity: .7,
                offset: const Offset(0, 4),
                sigma: 4,
                child: SvgPicture.asset("assets/icons/Navigation/QR.svg"),
              ),
              label: 'QR'
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/Navigation/Search.svg", color: kBlack,),
            activeIcon: SimpleShadow(
              opacity: .7,
              offset: const Offset(0, 4),
              sigma: 4,
              child: SvgPicture.asset("assets/icons/Navigation/Search.svg"),
            ),
            label: 'Search'
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/icons/Navigation/Promotions.svg"),
              activeIcon: SimpleShadow(
                opacity: .7,
                offset: const Offset(0, 4),
                sigma: 4,
                child: SvgPicture.asset("assets/icons/Navigation/Promotions.svg"),
              ),
              label: 'Promotions'
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/icons/Navigation/Personal.svg"),
              activeIcon: SimpleShadow(
                opacity: .7,
                offset: const Offset(0, 4),
                sigma: 4,
                child: SvgPicture.asset("assets/icons/Navigation/Personal.svg"),
              ),
              label: 'Personal'
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() {_selectedIndex = index;}),
      ),
    );
  }
}
