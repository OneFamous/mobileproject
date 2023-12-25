import 'package:flutter/material.dart';
import 'package:mobileproject/NavBar.dart';
import 'package:mobileproject/screens/todo/favorite_page.dart';

import 'completed_page.dart';
import 'task_page.dart';

class homePageTodo extends StatefulWidget {
  const homePageTodo({super.key});

  @override
  State<homePageTodo> createState() => _homePage();
}

class _homePage extends State<homePageTodo> {
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        drawer: NavBar(),
        appBar: AppBar(
          centerTitle: true,
          title: Text("TO-DO LIST"),
          backgroundColor: Colors.deepOrange,
        ),
        body: Column(
          children: [
            Container(
              color: Colors.deepOrange[100],
              child: TabBar(tabs: [
                Tab(
                  icon: Icon(
                    Icons.star,
                    color: Colors.black,
                  ),
                ),
                Tab(
                  child: Text(
                    "Tasks",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    "Completed",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: TabBarView(children: [
                favorite_page(),
                taskPage(),
                completedPage(),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
