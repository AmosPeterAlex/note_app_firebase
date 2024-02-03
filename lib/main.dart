import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseCRUDEx extends StatefulWidget {
  const FirebaseCRUDEx({super.key});

  @override
  State<FirebaseCRUDEx> createState() => _FirebaseCRUDExState();
}

class _FirebaseCRUDExState extends State<FirebaseCRUDEx> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();

  late CollectionReference _userCollection;

  @override
  void initState() {
    _userCollection = FirebaseFirestore.instance.collection('users');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Cloud Storage Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
                onPressed: () {
                  addUser();

                  ///User should be added
                },
                child: const Text('Add User')),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: getUser(),

                ///data should be received from cloud
                ///could be any type of data from firebase
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  final users = snapshot.data!.docs;
                  return Expanded(
                      child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            final userID = user.id;
                            final userName = user['name'];
                            final userEmail = user['email'];
                            return ListTile(
                              title: Text('$userName'),
                              subtitle: Text('$userEmail'),
                              trailing: Wrap(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        editData(userID);
                                      },
                                      icon: const Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        deleteData(userID);
                                      },
                                      icon: const Icon(Icons.delete))
                                ],
                              ),
                            );
                          }));
                })
          ],
        ),
      ),
    );
  }

//create user
  Future<void> addUser() async {
    return _userCollection
        .add({'name': nameController.text, 'email': emailController.text}).then(
            (value) {
          print("user added Successfully");
          nameController.clear();
          emailController.clear();
        }).catchError((error) {
      print("failed to add user $error");
    });
  }

//read user
  Stream<QuerySnapshot> getUser() {
    return _userCollection.snapshots();
  }

  //edit user
  void editData(id) {
    showDialog(
        context: context,
        builder: (context) {
          var nameEController = TextEditingController();
          var emailEController = TextEditingController();
          return AlertDialog(
            title: const Text('Update User'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: nameEController,
                    decoration: const InputDecoration(
                        hintText: "Enter Text", border: OutlineInputBorder())),
                SizedBox(
                  height: 5,
                ),
                TextField(
                    controller: emailEController,
                    decoration: const InputDecoration(
                        hintText: "Enter Text", border: OutlineInputBorder()))
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    updateUser(id, nameEController.text, emailEController.text);
                    Navigator.pop(context);
                  },
                  child: const Text('Update'))
            ],
          );
        });
  }

//update user data
  Future<void> updateUser(var id, String newName, String newEmail) async {
    return _userCollection
        .doc(id)
        .update({'name': newName, 'email': newEmail}).then((value) {
      print('User Updated Successfully');
    }).catchError((error) {
      print('User Data Updation Failed');
    });
  }

  // void deleteData() {}
  Future<void> deleteData(var id) {
    return _userCollection.doc(id).delete().then((value) {
      print("User Deleted Successfully");
    }).catchError((error) {
      print("User deletion failed $error");
    });
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBh5jt-EJluy3aBIr4cw6jnLo4DJ7e9ozk",
          appId: "fir-flutter-ex-667d6",
          messagingSenderId: '',
          projectId: "fir-flutter-ex-667d6",
          storageBucket: "fir-flutter-ex-667d6.appspot.com"));
  runApp(const MaterialApp(
    home: FirebaseCRUDEx(),
    debugShowCheckedModeBanner: false,
  ));
}

 */
