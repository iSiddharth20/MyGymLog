import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CurrentLogDays extends StatefulWidget {
  const CurrentLogDays({ Key? key }) : super(key: key);

  @override
  State<CurrentLogDays> createState() => _CurrentLogDaysState();
}

class _CurrentLogDaysState extends State<CurrentLogDays> {

FirebaseFirestore firestore = FirebaseFirestore.instance;
  deleteAlertDialog(BuildContext context, String docid) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Delete"),
      onPressed: () async {
        FirebaseFirestore.instance
            .collection("days")
            .doc(docid)
            .delete()
            .whenComplete(() => Navigator.of(context).pop());
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete "),
      content: Text(
          "Deleteing this colleaction will remove its sub collections too."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Currently Logged Days"),
        // actions: [
        //   IconButton(icon: Icon(Icons.info_outline_rounded), onPressed: () {})
        // ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: firestore.collection('days').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                physics: new BouncingScrollPhysics(),
                itemBuilder: (context, i) {
                  var a = i + 1;
                  var doc = snapshot.data!.docs;
                  var docId = doc[i].id;
                  var catname = snapshot.data!.docs[i]["new_day"];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                child: Text(a.toString()),
                              ),
                             
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  width: 120,
                                  child: Text(
                                      snapshot.data!.docs[i]["new_day"],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  deleteAlertDialog(context, docId);
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  color: Colors.red,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}