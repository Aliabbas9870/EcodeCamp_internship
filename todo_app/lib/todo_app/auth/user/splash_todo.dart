import 'dart:nativewrappers/_internal/vm/lib/async_patch.dart';

import 'package:flutter/material.dart';
import 'package:job_search_app_admin/todo_app/auth/user/register_auth.dart';
import 'package:job_search_app_admin/todo_app/home_view_todo.dart';
import 'package:job_search_app_admin/widget/constant.dart';

class SplashTodo extends StatefulWidget {
  const SplashTodo({super.key});

  @override
  State<SplashTodo> createState() => _SplashTodoState();
}

class _SplashTodoState extends State<SplashTodo> {
  final Todo col = Todo(); // color
  @override
  void initState() {
    // TODO: implement
    //
    // initState
    navigate();
    super.initState();
  }

  navigate() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => RegisterAuthTodo()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment(2, 5),
                end: Alignment(5, 0),
                colors: [col.bColor, col.sColor, col.pColor])),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Text(
            "Welcome",
            style: TextStyle(
                color: col.tColor, fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
