import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mygymlog/widgets/currentlogactivites.dart';
import 'package:mygymlog/widgets/currentlogdays.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AddWorkout extends StatefulWidget {
  const AddWorkout({Key? key}) : super(key: key);

  @override
  State<AddWorkout> createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  String _timeString = '';
  String _convertedTimeString = '';
  String _dateString = ' ';
  final _adddayformKey = GlobalKey<FormState>();
  final _addactivityformKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _adddaytext = TextEditingController();
   TextEditingController _addactivitytext = TextEditingController();
 var carMake, carMakeModel;
  var setDefaultMake = true, setDefaultMakeModel = true;
  @override
  void initState() {
    _timeString =
        "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    _dateString =
        "${DateTime.now().month} : ${DateTime.now().day} :${DateTime.now().year}";
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      getTime(String time) {
        TimeOfDay _startTime = TimeOfDay(
            hour: int.parse(time.split(":")[0]),
            minute: int.parse(time.split(":")[1]));
        return "${_startTime.hourOfPeriod.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')} ${_startTime.period == DayPeriod.pm ? "PM" : "AM"}";
      }

      if (mounted) {
        setState(() {
          _timeString =
              "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
          _convertedTimeString = getTime(_timeString);
        });
      }
    });
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      String getMonth(int currentMonthIndex) {
        return DateFormat('MMM')
            .format(DateTime(0, currentMonthIndex))
            .toString();
      }

      if (mounted) {
        setState(() {
          _dateString =
              "${getMonth(int.parse(DateTime.now().month.toString()))} ${DateTime.now().day} , ${DateTime.now().year}";
        });
      }
    });

    super.initState();
  }

  Widget progressBar() {
    return CircularPercentIndicator(
      radius: 120.0,
      lineWidth: 13.0,
      animation: true,
      percent: 0.7,
      animationDuration: 2000,
      center: new Text(
        "80.0%",
        style: new TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      footer: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: new Text(
          "Please wait we are saving the provided information.",
          style: new TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17.0),
        ),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Log'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            "Current Time",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            "Today's Date",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _convertedTimeString,
                            style: const TextStyle(fontSize: 20),
                          ),
                          Text(
                            _dateString,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 8,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text("Add Day")],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                width: MediaQuery.of(context).size.width,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CurrentLogDays()));
                                  },
                                  child: Card(
                                    color: Colors.grey.withOpacity(0.2),
                                    elevation: 8,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("See Curuntly Logged Days")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                width: MediaQuery.of(context).size.width,
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: const Text('Add New Day'),
                                              content: SizedBox(
                                                height: 150,
                                                child: Form(
                                                  key: _adddayformKey,
                                                  child: Column(
                                                    children: [
                                                      const Text(
                                                          'You can now enter a new day to record your fitness.'),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      TextFormField(
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please enter something.';
                                                          }
                                                          return null;
                                                        },
                                                        controller: _adddaytext,
                                                        autofocus: false,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        decoration:
                                                            const InputDecoration(
                                                                suffixIcon: Icon(
                                                                    Icons
                                                                        .edit_note_outlined),
                                                                border:
                                                                    OutlineInputBorder(),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width:
                                                                          2.0),
                                                                ),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width:
                                                                          2.0),
                                                                ),
                                                                labelText:
                                                                    'Enter Day',
                                                                labelStyle: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              actions: <Widget>[
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child: const Text(
                                                        'Cancle',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: Colors
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.3)),
                                                    ),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        // Obtain shared preferences.
                                                        // final prefs =
                                                        //     await SharedPreferences
                                                        //         .getInstance();
                                                        setState(() {
                                                          isLoading = true;
                                                        });
                                                        if (_adddayformKey
                                                            .currentState!
                                                            .validate()) {
                                                          showDialog(
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                backgroundColor:
                                                                    Colors.blueGrey[
                                                                        900],
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10.0))),
                                                                content:
                                                                    progressBar(),
                                                              );
                                                            },
                                                          );
                                                          await Future.delayed(
                                                              Duration(
                                                                  seconds: 5));
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'days')
                                                              .add({
                                                            'new_day':
                                                                _adddaytext.text
                                                                    .toString(),
                                                          }).whenComplete(
                                                                  () async {
                                                            setState(() {
                                                              isLoading = false;
                                                            });
                                                            // Save an String value to 'guestname' key.
                                                            // await prefs.setString(
                                                            //     'guestname',
                                                            //     _guestname.text
                                                            //         .toString());
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false);
                                                            _adddaytext.clear();
                                                            // Navigator.pushAndRemoveUntil(
                                                            //     context,
                                                            //     MaterialPageRoute(
                                                            //         builder: (context) =>
                                                            //             GuestScreens()),
                                                            //     (route) =>
                                                            //         false).whenComplete(
                                                            //     () =>
                                                            //         _guestname.clear());
                                                          });

                                                          Navigator.of(context)
                                                              .pop(false);
                                                        } else {
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                        }
                                                      },
                                                      child: const Text(
                                                        'Submit',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: Colors
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.3)),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ));
                                  },
                                  child: Card(
                                    color: Colors.grey.withOpacity(0.2),
                                    elevation: 8,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [Text("Add New Day")],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [
                            //     IconButton(
                            //       onPressed: () {},
                            //       icon: Icon(Icons.add_circle_outline),
                            //     )
                            //   ],
                            // )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 8,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text("Add Activity")],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                width: MediaQuery.of(context).size.width,
                                child: GestureDetector(
                                  onTap: (){
                                     Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CurrentLogActivites()));
                                  },
                                  child: Card(
                                    color: Colors.grey.withOpacity(0.2),
                                    elevation: 8,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("See Curuntly Logged Activities")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.10,
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: Card(
                                      color: Colors.grey.withOpacity(0.2),
                                      elevation: 8,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            
                                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('days')
                                  .orderBy('new_day')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                   
                                // Safety check to ensure that snapshot contains data
                                // without this safety check, StreamBuilder dirty state warnings will be thrown
                                if (!snapshot.hasData) return Container();
                                // Set this value for default,
                                // setDefault will change if an item was selected
                                // First item from the List will be displayed
                                if (setDefaultMake) {
                                  carMake = snapshot.data!.docs[0].get('new_day');
                                  //debugPrint('setDefault make: $carMake');
                                }
                                return DropdownButton(
                                  isExpanded: false,
                                  value: carMake,
                                  items: snapshot.data!.docs.map((value) {
                                    return DropdownMenuItem(
                                      value: value.get('new_day'),
                                      child: Text('${value.get('new_day')}'),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    debugPrint('selected onchange: $value');
                                    setState(
                                      () {
                                        debugPrint('make selected: $value');
                                        // Selected value will be stored
                                        carMake = value;
                                        // Default dropdown value won't be displayed anymore
                                        setDefaultMake = false;
                                        
                                        // Set makeModel to true to display first car from list
                                        setDefaultMakeModel = true;
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            
                            
                            
                            ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.10,
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: GestureDetector(
                                      onTap: (){
                                          showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: const Text('Add New Activity'),
                                              content: SizedBox(
                                                height: 150,
                                                child: Form(
                                                  key: _addactivityformKey,
                                                  child: Column(
                                                    children: [
                                                      const Text(
                                                          'You can now enter a new activity to record your fitness.'),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      TextFormField(
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please enter something.';
                                                          }
                                                          return null;
                                                        },
                                                        controller: _addactivitytext,
                                                        autofocus: false,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        decoration:
                                                            const InputDecoration(
                                                                suffixIcon: Icon(
                                                                    Icons
                                                                        .edit_note_outlined),
                                                                border:
                                                                    OutlineInputBorder(),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width:
                                                                          2.0),
                                                                ),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width:
                                                                          2.0),
                                                                ),
                                                                labelText:
                                                                    'Enter Activity',
                                                                labelStyle: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              actions: <Widget>[
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child: const Text(
                                                        'Cancle',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: Colors
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.3)),
                                                    ),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        // Obtain shared preferences.
                                                        // final prefs =
                                                        //     await SharedPreferences
                                                        //         .getInstance();
                                                        setState(() {
                                                          isLoading = true;
                                                        });
                                                        if (_addactivityformKey
                                                            .currentState!
                                                            .validate()) {
                                                          showDialog(
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                backgroundColor:
                                                                    Colors.blueGrey[
                                                                        900],
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10.0))),
                                                                content:
                                                                    progressBar(),
                                                              );
                                                            },
                                                          );
                                                          await Future.delayed(
                                                              Duration(
                                                                  seconds: 5));
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'activities')
                                                              .add({
                                                            'new_activity':
                                                                _addactivitytext.text
                                                                    .toString(),
                                                            'selected_day': carMake.toString()
                                                          }).whenComplete(
                                                                  () async {
                                                            setState(() {
                                                              isLoading = false;
                                                            });
                                                            // Save an String value to 'guestname' key.
                                                            // await prefs.setString(
                                                            //     'guestname',
                                                            //     _guestname.text
                                                            //         .toString());
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false);
                                                            _adddaytext.clear();
                                                            // Navigator.pushAndRemoveUntil(
                                                            //     context,
                                                            //     MaterialPageRoute(
                                                            //         builder: (context) =>
                                                            //             GuestScreens()),
                                                            //     (route) =>
                                                            //         false).whenComplete(
                                                            //     () =>
                                                            //         _guestname.clear());
                                                          });

                                                          Navigator.of(context)
                                                              .pop(false);
                                                        } else {
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                        }
                                                      },
                                                      child: const Text(
                                                        'Submit',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: Colors
                                                                  .grey
                                                                  .withOpacity(
                                                                      0.3)),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ));
                                  
                                      },
                                      child: Card(
                                        color: Colors.grey.withOpacity(0.2),
                                        elevation: 8,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [Text("Add New Activity")],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: [
                            //     IconButton(
                            //       onPressed: () {},
                            //       icon: Icon(Icons.add_circle_outline),
                            //     )
                            //   ],
                            // )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _getCurrentTime() {
    getTime(String time) {
      TimeOfDay _startTime = TimeOfDay(
          hour: int.parse(time.split(":")[0]),
          minute: int.parse(time.split(":")[1]));
      return "${_startTime.hourOfPeriod}:${_startTime.minute} ${_startTime.period == DayPeriod.pm ? "P.M" : "A.M"}";
    }

    setState(() {
      _timeString =
          "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
      _convertedTimeString = getTime(_timeString);
    });
  }

  void _getCurrentDate() {
    String getMonth(int currentMonthIndex) {
      return DateFormat('MMM')
          .format(DateTime(0, currentMonthIndex))
          .toString();
    }

    setState(() {
      _dateString =
          "${getMonth(int.parse(DateTime.now().month.toString()))} ${DateTime.now().day} , ${DateTime.now().year}";
    });
  }
}
