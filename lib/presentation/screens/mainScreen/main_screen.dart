import 'package:flutter/material.dart';

import '../../../logic/backend/api_calls.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () {},
          child: const Text("Sign out"),
        ),
      ),
    );
  }
}
