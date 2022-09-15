import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SendDataToServer extends StatefulWidget {
  const SendDataToServer({Key? key}) : super(key: key);
  final String _title = 'Web Socket';
  @override
  State<SendDataToServer> createState() => _SendDataToServerState();
}

class _SendDataToServerState extends State<SendDataToServer> {
  final _channel =
      WebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void _send() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Message can\'t be empty';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Message',
                  label: Text('Message'),
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) => Text(snapshot.hasData
                  ? '${snapshot.data}'
                  : 'No Message Came yet'),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _send();
          }
        },
        tooltip: 'Send Message',
        splashColor: Colors.deepOrange,
        child: const Icon(Icons.send),
      ),
    );
  }
}
