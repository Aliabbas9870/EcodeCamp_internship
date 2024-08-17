import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_search_app_admin/services/database.dart';
import 'package:job_search_app_admin/widget/constant.dart';
import 'package:job_search_app_admin/widget/slect_day.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:random_string/random_string.dart';

class HomeViewTodo extends StatefulWidget {
  const HomeViewTodo({super.key});

  @override
  State<HomeViewTodo> createState() => _HomeViewTodoState();
}

class _HomeViewTodoState extends State<HomeViewTodo> {
  final Todo col = Todo(); // color
  bool today = true, tomorrow = false, nextWeek = false;
  Stream? todoStream;
  loadData() async {
    todoStream = await DatabaseTodo().getAllWorkTodo(today
        ? "Today"
        : tomorrow
            ? "Tomorrow"
            : "NextWeek");
    setState(() {});
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Widget allwork() {
    return StreamBuilder(
        stream: todoStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            activeColor: col.tColor,
                            checkColor: col.sColor,
                            title: Text(
                              ds["work"],
                              style: TextStyle(color: col.tColor, fontSize: 20),
                            ),
                            value: ds["yes"],
                            onChanged: (val) async {
                              val = await DatabaseTodo().updateClick(
                                  ds["id"],
                                  today
                                      ? "Today"
                                      : tomorrow
                                          ? "Tomorrow"
                                          : "NextWeek");
                              setState(() {
                                // val = val!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: col.tColor),
                          onPressed: () async {
                            await DatabaseTodo().deleteTodo(
                                ds.id,
                                today
                                    ? "Today"
                                    : tomorrow
                                        ? "Tomorrow"
                                        : "NextWeek");
                          },
                        ),
                      ],
                    );
                  })
              : Center(child: CircularProgressIndicator());
        });
  }

  var txtController = TextEditingController();
  bool sugest = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: col.bColor,
        onPressed: () {
          openBox();
        },
        child: Icon(
          Icons.add,
          color: col.tColor,
          size: 30,
        ),
      ),
      backgroundColor: col.pColor,
      body: Container(
        width: size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment(2, 5),
                end: Alignment(5, 0),
                colors: [col.bColor, col.sColor, col.pColor])),
        height: size.height,
        padding: EdgeInsets.only(top: 60, left: 22, right: 12),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi!",
              style: TextStyle(
                  color: col.tColor, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            // Text(
            //   "Good ",
            //   style: TextStyle(
            //       color: col.tColor, fontSize: 25, fontWeight: FontWeight.bold),
            // ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                today
                    ? SlectDay(titel: "Today")
                    : InkWell(
                        onTap: () async {
                          today = true;
                          tomorrow = false;
                          nextWeek = false;
                          await loadData();
                          setState(() {});
                        },
                        child: Text(
                          "Today",
                          style: TextStyle(
                              color: col.tColor,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                SizedBox(
                  width: 8,
                ),
                tomorrow
                    ? SlectDay(titel: "Tomorrow")
                    : InkWell(
                        onTap: () async {
                          today = false;
                          tomorrow = true;
                          nextWeek = false;
                          await loadData();

                          setState(() {});
                        },
                        child: Text(
                          "Tomorrow",
                          style: TextStyle(
                              color: col.tColor,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                SizedBox(
                  width: 8,
                ),
                nextWeek
                    ? SlectDay(titel: "Next Week")
                    : InkWell(
                        onTap: () async {
                          today = false;
                          tomorrow = false;
                          nextWeek = true;
                          await loadData();

                          setState(() {});
                        },
                        child: Text(
                          "Next Week",
                          style: TextStyle(
                              color: col.tColor,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
            SizedBox(
              height: 13,
            ),
            Expanded(child: allwork())
          ],
        ),
      ),
    );
  }

  Future openBox() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.cancel, color: col.bColor)),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Add the work Todo",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: col.bColor),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Add Todo",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: col.bColor),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12)),
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Enter Text"),
                        controller: txtController,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          String id = randomAlphaNumeric(6);
                          Map<String, dynamic> userTodo = {
                            "work": txtController.text,
                            "id": id,
                            "yes": false,
                          };
                          today
                              ? DatabaseTodo().addTodoDay(userTodo, id)
                              : tomorrow
                                  ? DatabaseTodo().addTodoTomorrow(userTodo, id)
                                  : nextWeek
                                      ? DatabaseTodo().addTodoWeek(userTodo, id)
                                      : Navigator.pop(context);

                          txtController.clear();
                          Navigator.pop(context);
                          QuickAlert.show(
                            context: context,
                            autoCloseDuration: Duration(seconds: 1),
                            type: QuickAlertType.success,
                            title: "Todo",
                            text: 'Todo Inserted successfully',
                          );
                        },
                        child: Container(
                          width: 90,
                          height: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment(2, 5),
                                  end: Alignment(5, 0),
                                  colors: [col.bColor, col.sColor, col.pColor]),
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text(
                              "ADD",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: col.tColor),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
