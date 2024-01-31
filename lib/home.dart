import "package:flutter/material.dart";
import "package:hive/hive.dart";

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Box box;
  @override
  void initState() {
    super.initState();
    box = Hive.box("myBox");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
              child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    box.put("NAME", "Ahmed Elmasry");
                    box.add("Hassan Mohamed");
                  },
                  child: Text("Save")),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    //print(box.get("NAME"));
                    // print(box.get("NAME", defaultValue: ''));
                    // print(box.getAt(0));
                    //print(box.values);
                    box.values.forEach((element) {
                      print(element);
                    });
                  },
                  child: Text("View")),
            ],
          )),
        ),
      ),
    );
  }
}
