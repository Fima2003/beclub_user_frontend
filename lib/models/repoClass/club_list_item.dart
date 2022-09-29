import 'package:equatable/equatable.dart';

class ClubListItem extends Equatable{
  final String nick;
  final String profileImage;
  final String type;

  ClubListItem({required this.nick, required this.profileImage, required this.type});

  @override
  List<Object?> get props => [nick, profileImage, type];
}