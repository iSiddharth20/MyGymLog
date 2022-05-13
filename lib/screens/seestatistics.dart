import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class SeeStatistics extends StatefulWidget {
  const SeeStatistics({Key? key}) : super(key: key);

  @override
  State<SeeStatistics> createState() => _SeeStatisticsState();
}

class _SeeStatisticsState extends State<SeeStatistics> {
  String _timeString = '';
  String _convertedTimeString = '';
  String _dateString = ' ';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Log'),
      ),
      body: Column(
        children: 
          [
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
                      StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('workoutlog')
                                  .orderBy('activity')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                   
                                // Safety check to ensure that snapshot contains data
                                // without this safety check, StreamBuilder dirty state warnings will be thrown
                                if (!snapshot.hasData) return Container();
                                // Set this value for default,
                                // setDefault will change if an item was selected
                                // First item from the List will be displayed
                                // if (setDefaultMake) {
                                //   carMake = snapshot.data!.docs[0].get('new_day');
                                //   //debugPrint('setDefault make: $carMake');
                                // }
                                return Container(
                                  height: MediaQuery.of(context).size.height,
                                  child: ListView.builder(
                               
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];
              return new                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 8,
                        child: Column(
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.2,
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                    color: Colors.grey.withOpacity(0.2),
                                    elevation: 8,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [Text(ds["activity"])],
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            
                child: SfSparkLineChart(
                  //Enable the trackball
                    trackball: SparkChartTrackball(
                        activationMode: SparkChartActivationMode.tap),
                    //Enable marker
                    marker: SparkChartMarker(
                        displayMode: SparkChartMarkerDisplayMode.all),
                    //Enable data label
                    labelDisplayMode: SparkChartLabelDisplayMode.all,
                    data: <double>[
                      double.parse(ds["weight"])
                     //70, 67, 69, 72, 66,70,72,75,71
                    ],
                )
                      )
                                        ],
                                      ),
                                    ),
                                  ),
                              ),
                            ),
                              
                          ],
                        ),
                      ),
                    );
            }

),
                                );
                   
                                // DropdownButton(
                                //   isExpanded: false,
                                //   value: carMake,
                                //   items: snapshot.data!.docs.map((value) {
                                //     return DropdownMenuItem(
                                //       value: value.get('new_day'),
                                //       child: Text('${value.get('new_day')}'),
                                //     );
                                //   }).toList(),
                                //   onChanged: (value) {
                                //     debugPrint('selected onchange: $value');
                                //     setState(
                                //       () {
                                //         debugPrint('make selected: $value');
                                //         // Selected value will be stored
                                //         carMake = value;
                                //         // Default dropdown value won't be displayed anymore
                                //         setDefaultMake = false;
                                        
                                //         // Set makeModel to true to display first car from list
                                //         setDefaultMakeModel = true;
                                //       },
                                //     );
                                //   },
                                // );
                              },
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
