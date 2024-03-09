import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';


class Driver extends StatefulWidget {
  late String driver;
  late String dcds;
  Driver(this.driver, this.dcds);
  @override
  State<Driver> createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.driver),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: _messages.isNotEmpty
            ? _MessagesListView(
          messages: _messages,
        )
            : Center(
          child: Text(
            'No messages to show.\n Tap refresh button...',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var permission = await Permission.sms.status;
          if (permission.isGranted) {
            final messages = await _query.querySms(
              address: '+254748708055',
              count: 10,
            );
            debugPrint('sms inbox messages: ${messages.length}');

            setState(() => _messages = messages);
          } else {

            await Permission.sms.request();
          }


  },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class _MessagesListView extends StatelessWidget {
  const _MessagesListView({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final List<SmsMessage> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int i) {
        var message = messages[i];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color:Colors.lime,
            child: ListTile(
              title: Text('${message.sender} [${message.date}]'),
              subtitle: Text('${message.body}',
              style: TextStyle(
                color:Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              ),
            ),
          ),
        );
      },
    );
  }
}
