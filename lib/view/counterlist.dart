import 'dart:async';

import 'package:countdowntimerlist/widget/appfont.dart';
import 'package:countdowntimerlist/widget/custom_color.dart';
import 'package:countdowntimerlist/widget/duration.dart';
import 'package:countdowntimerlist/widget/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CounterListpage extends StatefulWidget {
  const CounterListpage({Key? key}) : super(key: key);

  @override
  State<CounterListpage> createState() => _CounterListpageState();
}

class _CounterListpageState extends State<CounterListpage> {
  double? scrWidth, scrHeight;

  //  Scrolling Controller
  ScrollController _controller = ScrollController();

  // TextEditing Controller
  List<TextEditingController> _controllers = [];
  List<TextField> _fields = [];

  List<String> _text = [];
  List<Text> _textbutton = [];

  List<Timer> _timer = [];
  List<String> counterStatus = [];

  List<int> remainingtime = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    scrWidth = MediaQuery.of(context).size.width;
    scrHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: CustomColor.greenfaint,
            title: const Text("CountDownTimerApp"),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: scrHeight! * 0.02,
              ),
              addTimer(),
              Expanded(child: counterListView()),
            ],
          )),
    );
  }


  // add timer widget
  Widget addTimer() {
    return Container(
      height: scrHeight! * 0.07,
      margin: EdgeInsets.symmetric(
        horizontal: scrWidth! * 0.023,
      ),
      width: scrWidth! * 0.5,
      decoration: BoxDecoration(
          color: CustomColor.greenfaint,
          border: Border.all(color: Colors.grey)),
      child: ListTile(
        title: Row(
          children: [
            const Icon(
              Icons.add,
              color: Colors.white,
            ),
            Text(
              ' Add Timer',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: scrWidth! * 0.05,
                  fontFamily: AppFont.robotoBold),
            ),
          ],
        ),
        onTap: () {

          // Assigned initial value
          final controller = TextEditingController();
          const _textvalue = "00:00:00";
          final _textbuttonvalue = const Text("Start");
          final counterstatusvalue = "Start";
          final remainingtimevalue = 0;
          final timervalue = Timer(
            const Duration(seconds: 0),
            () {},
          );

          final field = TextField(
            textAlign: TextAlign.center,
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: CustomColor.grey),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black12,
                ),
              ),
              contentPadding: const EdgeInsets.only(
                top: 2,
              ),
              hintText: '00',
              hintStyle: TextStyle(
                color: CustomColor.greylight,
                fontSize: scrWidth! * 0.04,
                fontFamily: AppFont.robotoRegular,
                fontWeight: FontWeight.w500,
              ),
            ),
          );

          setState(() {

            // added to list
            _controllers.add(controller);
            _fields.add(field);
            _text.add(_textvalue);
            _textbutton.add(_textbuttonvalue);
            _timer.add(timervalue);
            counterStatus.add(counterstatusvalue);
            remainingtime.add(remainingtimevalue);
          });
        },
      ),
    );
  }


  // Counter listview widget
  Widget counterListView() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _controller,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: _fields.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(
              horizontal: scrWidth! * 0.02, vertical: scrHeight! * 0.024),
          decoration: BoxDecoration(
            border: Border.all(color: CustomColor.blue),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: scrWidth! * 0.023, vertical: scrHeight! * 0.02),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Container(height: scrHeight! * 0.05, child: _fields[index]),
                    SizedBox(
                      height: scrHeight! * 0.01,
                    ),
                    Text(
                      'Times in seconds',
                      maxLines: 3,
                      style: TextStyle(
                          color: CustomColor.greydark,
                          fontSize: scrWidth! * 0.032,
                          fontFamily: AppFont.robotoMedium),
                    ),
                    SizedBox(
                      height: scrHeight! * 0.02,
                    ),
                  ],
                )),
                SizedBox(
                  width: scrWidth! * 0.02,
                ),
                Expanded(
                    child: Column(
                  children: [
                    Container(
                        height: scrHeight! * 0.05,
                        decoration: BoxDecoration(
                            color: CustomColor.white,
                            border: Border.all(color: Colors.grey)),
                        child: Center(child: Text(_text[index]))),
                    SizedBox(
                      height: scrHeight! * 0.01,
                    ),
                    Text(
                      'Seconds converted to HH:mm:ss',
                      maxLines: 3,
                      style: TextStyle(
                          color: CustomColor.greydark,
                          fontSize: scrWidth! * 0.032,
                          fontFamily: AppFont.robotoMedium),
                    ),
                  ],
                )),
                SizedBox(
                  width: scrWidth! * 0.02,
                ),
                Expanded(
                    child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {

                          // Pause timer option
                          if (counterStatus[index] == "Pause") {
                            setState(() {
                              _textbutton[index] = const Text("Resume");
                              counterStatus[index] = "Resume";
                            });
                            _timer![index].cancel();
                          }

                          // Resume timer Option
                          else if (counterStatus[index] == "Resume") {
                            setState(() {
                              int totaltime = remainingtime[index];
                              _timer![index] = Timer.periodic(
                                  const Duration(seconds: 1), (timer) {
                                setState(() {
                                  if (totaltime > 0) {
                                    _text![index] = intToTimeLeft(totaltime);
                                    totaltime--;
                                    _text![index] = intToTimeLeft(totaltime);
                                    _textbutton[index] = const Text("Pause");
                                    counterStatus[index] = "Pause";
                                    remainingtime[index] = totaltime;
                                    print(_textbutton[index].toString());
                                  } else {
                                    setState(() {
                                      counterStatus[index] = "Start";
                                      _textbutton[index] = const Text("Start");
                                    });
                                    _timer![index].cancel();
                                  }
                                });
                              });
                            });
                          }

                          // Start timer option
                          else {
                            setState(() {
                              int totaltime =
                                  int.parse(_controllers[index].text);
                              _timer![index] = Timer.periodic(
                                  const Duration(seconds: 1), (timer) {
                                setState(() {
                                  if (totaltime > 0) {
                                    _text![index] = intToTimeLeft(totaltime);
                                    totaltime--;
                                    _text![index] = intToTimeLeft(totaltime);
                                    print("hh:mm:ss ${_text[index]}");
                                    _textbutton[index] = const Text("Pause");
                                    counterStatus[index] = "Pause";
                                    remainingtime[index] = totaltime;
                                    print(_textbutton[index].toString());
                                  } else {
                                    setState(() {
                                      counterStatus[index] = "Start";
                                      _textbutton[index] = const Text("Start");
                                    });
                                    _timer![index].cancel();
                                  }
                                });
                              });
                            });
                          }
                        });
                      },
                      child: Container(
                          height: scrHeight! * 0.05,
                          decoration: BoxDecoration(
                              color: CustomColor.white,
                              border: Border.all(color: Colors.grey)),
                          child: Center(child: _textbutton[index])),
                    ),
                    SizedBox(
                      height: scrHeight! * 0.01,
                    ),
                    Text(
                      'Intially: Start, Pause, Resume',
                      maxLines: 3,
                      style: TextStyle(
                          color: CustomColor.greydark,
                          fontSize: scrWidth! * 0.032,
                          fontFamily: AppFont.robotoMedium),
                    ),
                  ],
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}
