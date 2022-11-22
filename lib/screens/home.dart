import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/screens/Add_task.dart';
import 'package:todoapp/screens/Description.dart';

// --------login----------
// kartikpatadiya786@gmail.com
// kartik123
// --------login----------

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String uid = '';
  @override
  void initState() {
    getuid();
    super.initState();
  }

  getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    setState(() {
      uid = user.uid;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO"),
        actions: <Widget>[
          IconButton(
              onPressed: () async{
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Container(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('tasks')
                .doc(uid)
                .collection('mytask')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final docs = snapshot.data?.docs;
                return ListView.builder(
                    itemCount: docs?.length,
                    itemBuilder: (context, index) {
                      var time =
                          (docs![index]['timestamp'] as Timestamp).toDate();

                      return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Description(
                                          title: docs[index]['title'],
                                          description: docs[index]
                                              ['description'],
                                        )));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                color: Color(0xffe3dddc),
                                borderRadius: BorderRadius.circular(10)),
                            height: 90,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            // padding: EdgeInsets.only(top: 10),
                                            margin: EdgeInsets.only(left: 20),
                                            child: Text(
                                              docs![index]['title'],
                                              style: GoogleFonts.roboto(
                                                  fontSize: 20),
                                            )),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Text(
                                            DateFormat.yMd()
                                                .add_jm()
                                                .format(time),
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        )
                                      ]),
                                  Container(
                                    child: IconButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('tasks')
                                            .doc(uid)
                                            .collection('mytask')
                                            .doc(docs[index]['time'])
                                            .delete();
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                ]),
                          ));
                    });
              }
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTask()));
        },
        child: Icon(Icons.add,color: Colors.white,),
      ),

    );
  }
}

// AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
