import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable{

  String nick;
  String email;
  String name;

  factory User.fromJson(Map<String, dynamic> json) => User(
    nick: json['nick'],
    email: json['email'],
    name: json['name']
  );

  factory User.fromString(String str) => User.fromJson(jsonDecode(str));

  Map<String, dynamic> toJson() => {
    nick: nick,
    email: email,
    name: name
  };

  User({required this.nick, required this.email, required this.name});
  factory User.unknown() => User(nick: "", email: "", name: "");

  @override
  String toString() {
    return "nick: $nick\nname: $name\nemail: $email";
  }

  @override
  List<Object?> get props => [nick, name, email];
}