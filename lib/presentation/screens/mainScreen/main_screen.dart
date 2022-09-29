import 'dart:async';
import 'dart:convert';

import 'package:cluves/logic/internet/internet_cubit.dart';
import 'package:cluves/presentation/screens/mainScreen/personal_screen.dart';
import 'package:cluves/presentation/screens/mainScreen/promotions_screen.dart';
import 'package:cluves/presentation/screens/mainScreen/qr_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../../constants/palette.dart';
import '../../../constants/club_types.dart';
import '../../../logic/user/user_bloc.dart';
import '../../../models/repoClass/club_list_item.dart';
import '../../../models/repoClass/dio_client.dart';
import '../../../models/repoClass/user.dart';
import '../../../presentation/screens/clubScreen/club_screen.dart';

part 'search_screen.dart';
part 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late User user = User.unknown();

  int _selectedIndex = 0;
  final List<Widget> screens = [const QrScreen(), const SearchScreen(), const PromotionsScreen(), const PersonalScreen()];

  Widget noInternetConnectionWidget(Size size) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      width: size.width,
      decoration: BoxDecoration(
        color: kBlack,
        border: Border.all(color: kBlack),
        borderRadius: BorderRadius.circular(3),
        boxShadow: const [BoxShadow(color: kRed, blurRadius: 5, spreadRadius: 3)]
      ),
      child: const Text("No Internet connection", textAlign: TextAlign.center, style: TextStyle(color: kWhite),),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Builder(
      builder: (BuildContext context) {
        var internetState = context.watch<InternetCubit>().state;
        var userState = context.watch<UserBloc>().state;
        if(userState.nick == ""){
          context.read<UserBloc>().add(UserEventFetchInformation());
        }
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 50),
            child: userState.nick == "" ? Container() : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: screens[_selectedIndex]),
                internetState is InternetDisconnected ? noInternetConnectionWidget(size) : const SizedBox(),
              ],
            ),
          ),
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
    );
  }
}
