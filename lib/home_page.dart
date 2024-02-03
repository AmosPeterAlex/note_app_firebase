import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteHome extends StatefulWidget {
  @override
  State<NoteHome> createState() => _NoteHomeState();
}

class _NoteHomeState extends State<NoteHome> {
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  late CollectionReference _userCollection;

  @override
  void initState() {
    _userCollection = FirebaseFirestore.instance.collection('users');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dim = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Notes"),
        titleTextStyle: TextStyle(
            color: Colors.blueAccent,
            fontSize: 36,
            fontWeight: FontWeight.bold),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
        toolbarHeight: 90,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: dim.height / 1.7,
              width: dim.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: getUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(color: Colors.redAccent);
                  }
                  final users = snapshot.data!.docs;
                  return Expanded(
                      child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            final userID = user.id;
                            final userName = user['title'];
                            final userEmail = user['subtitle'];
                            return ListTile(
                              title: Text('$userName'),
                              subtitle: Text('$userEmail'),
                              trailing: Wrap(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        editData(userID);
                                      },
                                      icon: Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        deleteData(userID);
                                      },
                                      icon: Icon(Icons.delete))
                                ],
                              ),
                            );
                          }));
                },
              ),
            ),
            Container(
              height: dim.height / 6,
              width: dim.width,
              child: MaterialButton(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2)),
                onPressed: _addNote,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.blueAccent,
                      ),
                      Text(
                        'Add New Note',
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              height: dim.height / 11,
              width: dim.width,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        onPressed: _addNote,
        label: Row(
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            Text(
              'ADD NOTE',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getNote() async {
    return _userCollection.add({
      'title': titleController.text,
      'subtitle': subtitleController.text
    }).then((value) {
      print("user added Successfully");
      titleController.clear();
      subtitleController.clear();
    }).catchError((error) {
      print("failed to add user $error");
    });
  }

  Stream<QuerySnapshot> getUser() {
    return _userCollection.snapshots();
  }

  //edit user
  void editData(id) async {
    showDialog(
        context: context,
        builder: (context) {
          var titleEController = TextEditingController();
          var subEController = TextEditingController();
          return AlertDialog(
            title: const Text('Update User'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: titleEController,
                    decoration: const InputDecoration(
                        hintText: "Enter Text", border: OutlineInputBorder())),
                SizedBox(
                  height: 5,
                ),
                TextField(
                    controller: subEController,
                    decoration: const InputDecoration(
                        hintText: "Enter Text", border: OutlineInputBorder()))
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    updateUser(id, titleEController.text, subEController.text);
                    Navigator.pop(context);
                  },
                  child: const Text('Update'))
            ],
          );
        });
  }

  void _addNote() {
    setState(() {});

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed:
                    getNote,
                  child: Text('Add Data'))
            ],
            title: Text('Add Note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                        hintText: "Enter Title", border: OutlineInputBorder())),
                SizedBox(
                  height: 5,
                ),
                TextField(
                    controller: subtitleController,
                    decoration: const InputDecoration(
                        hintText: "Enter Subtitle", border: OutlineInputBorder()))
              ],
            ),
          );
        });

    // Navigator.pop(context);
  }

  Future<void> updateUser(var id, String newTitle, String newSub) async {
    return _userCollection
        .doc(id)
        .update({'title': newTitle, 'subtitle': newSub}).then((value) {
      print('User Successly aded');
    }).catchError((error) {
      print('user updation failed');
    });
  }

  Future<void> deleteData(String id) {
    return _userCollection.doc(id).delete().then((value) {
      print('Deleted Succes');
    }).catchError((error) {
      print('Failed $error');
    });
  }
}
