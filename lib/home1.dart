import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:noteapplication/Note.dart';
import 'package:noteapplication/dateTimeManager.dart';
import 'package:noteapplication/noteColor.dart';
import "package:hive_flutter/hive_flutter.dart";

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<FormState> _editKey = GlobalKey();
  late TextEditingController _controller;
  late TextEditingController _editController;
  Color selectedColor = colors[0].color;
  late Box<Note> box;
  @override
  void initState() {
    super.initState();
    box = Hive.box("notesBox");
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(children: [
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: colors.length,
                itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        setState(() {
                          colors.forEach((element) {
                            element.isSelected = false;
                          });
                          colors[index].isSelected = !colors[index].isSelected;
                          selectedColor = colors[index].color;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        color: colors[index].color,
                        margin: EdgeInsets.all(3),
                        alignment: Alignment.center,
                        child: Visibility(
                          child: Icon(Icons.check),
                          visible: colors[index].isSelected,
                        ),
                      ),
                    )),
            Form(
                key: _key,
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                      hintText: 'Note', labelText: 'Write Notes'),
                )),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    Note note = Note();
                    note.noteText = _controller.value.text;
                    note.noteDate = DateTimeManager.getCurrentDateTime();
                    note.noteColor = selectedColor.value.toString();
                    box.add(note);
                    _controller.text = "";
                    setState(() {
                      colors.forEach((element) {
                        element.isSelected = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Note Added Succefually")));
                    });
                  }
                },
                child: Text("Add Note")),
            SizedBox(
              height: 30,
            ),
            ValueListenableBuilder<Box<Note>>(
                valueListenable: box.listenable(),
                builder: (context, myBox, child) => ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: myBox.values.length,
                    itemBuilder: (context, index) => Container(
                        color: Color(int.parse(myBox.getAt(index)!.noteColor)),
                        child: Expanded(
                          child: ListTile(
                            title: Text(myBox.getAt(index)!.noteText),
                            subtitle: Text(myBox.getAt(index)!.noteDate),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        updateNote(myBox.getAt(index), index);
                                      },
                                      icon: Icon(Icons.edit,
                                          color: Colors.green)),
                                  IconButton(
                                      onPressed: () {
                                        box.deleteAt(index);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Note Deleted Succefually")));
                                      },
                                      icon: Icon(Icons.delete,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                        ))))
          ]),
        )),
      ),
    );
  }

  void updateNote(Note? note, int index) {
    _editController = TextEditingController(text: note!.noteText);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Update Note"),
              content: Form(
                  key: _editKey,
                  child: TextFormField(
                    controller: _editController,
                    validator: (value) =>
                        value!.isEmpty ? "This field is required" : null,
                    decoration: InputDecoration(
                        hintText: 'Note', labelText: 'Write Note'),
                  )),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () {
                      if (_editKey.currentState!.validate()) {
                        note.noteText = _editController.value.text;
                        box.putAt(index, note);
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Update")),
              ],
            ));
  }
}
