import 'dart:async';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

List<TextData> textList = new List<TextData>();

class TextStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return new File('$path/texts.txt');
  }

  Future<void> readText() async {
    try {
      final file = await _localFile;

      // Read the file
      List<String> contents = await file.readAsLines();
      int counter = 0;
      do {
        TextData tempStorage = new TextData();
        tempStorage.name = contents[counter];
        tempStorage.phoneNumber = contents[counter + 1];
        tempStorage.message = contents[counter + 2];
        tempStorage.trueDateTime = DateTime.parse(contents[counter + 3]);
        textList.add(tempStorage);
        counter += 4;
      } while (counter < contents.length);
    } catch (e) {
      return 0;
    }
  }

  Future<File> writeText() async {
    final file = await _localFile;
    int indexer = 0;
    String content = "";
    do{
      content += '${textList[indexer].name}\n${textList[indexer].phoneNumber}\n${textList[indexer].message}\n${textList[indexer].trueDateTime}\n';
      indexer ++;
 } while (indexer < textList.length);
    return file.writeAsStringSync(content);
  }
}

class DelayText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Delayed Texter',
      theme: new ThemeData(
        primaryColor: Colors.blue,
      ),
      home: new DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: new AppBar(
            bottom: new TabBar(
              tabs: [
                new Tab(text: 'New Message'),
                new Tab(text: 'Saved Messages'),
              ],
            ),
            title: new Text('Delayed Text'),
          ),
          body: new TabBarView(
            children: [
              new DTextMessage(storage: new TextStorage()),
              new SavedMessage(),
            ],
          ),
        ),
      ),
    );
  }
}

class TextData {
  String name = '';
  String phoneNumber = '';
  String message = '';
  DateTime dateTime = new DateTime.now();
  TimeOfDay timeOfDay = new TimeOfDay.now();
  DateTime trueDateTime = new DateTime.now();
  Duration difference;

  void setTrueDateTime() {
    trueDateTime = dateTime.add(new Duration(hours: timeOfDay.hour));
    difference = trueDateTime.difference(new DateTime.now());
  }
}

class SavedMessage extends StatefulWidget {
  SavedMessage({Key key}) : super(key: key);

  @override
  SavedMessageState createState() => new SavedMessageState();
}

class SavedMessageState extends State<SavedMessage> {
  @override
  Widget build(BuildContext context) {
    if (textList.length == 0) {
      return new Center(
        child: new Text("No saved Messages"),
      );
    }

    return new ListView.builder(
      itemCount: textList.length,
      itemBuilder: (context, index) {
        return new ListTile(
          title: new Text('Message to ${textList[index].name}'),
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) =>
                    new TextInfoScreen(textData: textList[index]),
              ),
            );
          },
        );
      },
    );
  }
}

class TextInfoScreen extends StatelessWidget {
  final TextData textData;

  TextInfoScreen({Key key, @required this.textData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Message to ${textData.name}"),
      ),
      body: new Padding(
        padding: new EdgeInsets.all(16.0),
        child: new Text(
            'Message: ${textData.message}\nMessage to be sent on ${textData.trueDateTime.toString()}'),
      ),
    );
  }
}

class DTextMessage extends StatefulWidget {
  final TextStorage storage;
  DTextMessage({Key key, @required this.storage}) : super(key: key);

  @override
  DTextMessageState createState() => new DTextMessageState();
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker(
      {Key key,
      this.labelText,
      this.selectedDate,
      this.selectedTime,
      this.selectDate,
      this.selectTime})
      : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(2015, 8),
        lastDate: new DateTime(2101));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          flex: 4,
          child: new _InputDropdown(
            labelText: labelText,
            valueText: new DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        new Expanded(
          flex: 3,
          child: new _InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}

class DTextMessageState extends State<DTextMessage> {
  DateTime tempDate = new DateTime.now();
  TimeOfDay tempTime = new TimeOfDay.now();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  TextData text = new TextData();

  static const platform = const MethodChannel('sendSms');

  void sendSms() async {
    print("SendSMS");
    try {
      final String result = await platform.invokeMethod(
          'send', <String, dynamic>{
        "phone": "${text.phoneNumber}",
        "msg": '${text.message}'
      }); //Replace a 'X' with 10 digit phone number
      showInSnackBar(result);
    } on PlatformException catch (e) {
      showInSnackBar(e.toString());
    }
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(
          new SnackBar(content: new Text(value)),
        );
  }

  void _handleSubmitted() async {
    final FormState form = _formKey.currentState;
    form.save();
    text.setTrueDateTime();
    textList.add(text);
    widget.storage.writeText();

    await AndroidAlarmManager.periodic(
        text.difference, textList.length, sendSms);
  }

  @override
  void initState() {
    super.initState();
    widget.storage.readText();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return new SafeArea(
      top: false,
      bottom: false,
      child: new Form(
        key: _formKey,
        child: new SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 24.0),
              new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    filled: true,
                    icon: const Icon(Icons.person),
                    hintText: 'Who to Call?',
                    labelText: 'Name',
                  ),
                  onSaved: (String value) {
                    text.name = value;
                  }),
              // Text Message
              const SizedBox(height: 24.0),
              new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    filled: true,
                    icon: const Icon(Icons.phone),
                    hintText: 'Number to Call?',
                    labelText: 'Phone Number',
                  ),
                  keyboardType: TextInputType.phone,
                  onSaved: (String value) {
                    text.phoneNumber = value;
                  }),
              // Text Message
              const SizedBox(height: 24.0),
              new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    filled: true,
                    icon: const Icon(Icons.message),
                    hintText: 'What Would you like to send?',
                    labelText: 'Text Message',
                  ),
                  onSaved: (String value) {
                    text.message = value;
                  }),

              new _DateTimePicker(
                labelText: 'When To send',
                selectedDate: tempDate,
                selectedTime: tempTime,
                selectDate: (DateTime date) {
                  setState(() {
                    tempDate = date;
                    text.dateTime = date;
                  });
                },
                selectTime: (TimeOfDay time) {
                  setState(() {
                    tempTime = time;
                    text.timeOfDay = time;
                  });
                },
              ),

              const SizedBox(height: 24.0),
              new Center(
                child: new RaisedButton(
                  onPressed: _handleSubmitted,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}