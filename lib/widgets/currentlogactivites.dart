import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CurrentLogActivites extends StatefulWidget {
  const CurrentLogActivites({ Key? key }) : super(key: key);

  @override
  State<CurrentLogActivites> createState() => _CurrentLogActivitesState();
}

class _CurrentLogActivitesState extends State<CurrentLogActivites> {
 
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
            .collection("activities")
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
          stream: firestore.collection('activities').snapshots(),
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
                  var catname = snapshot.data!.docs[i]["new_activity"];
                  var catnameone = snapshot.data!.docs[i]["selected_day"];
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
                                  child: ListTile(
                                    title: Text(
                                        snapshot.data!.docs[i]["selected_day"],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        )),
                                        subtitle:  Text(
                                        snapshot.data!.docs[i]["new_activity"],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        )),
                                  
                                  ),
                                  
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