import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/mainScreen/views/home_module/bottom_nav_bar.dart';
import 'package:flutter_login/mainScreen/views/home_module/matches_screen.dart';

class ChatScreen extends StatefulWidget {
  final String? userName;
  final String? userImage;

  ChatScreen({this.userName, this.userImage, Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<String> messages = [];
  TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.userImage ?? ""),
                  radius: 20,
                ),
                SizedBox(width: 8),
                Text(
                  widget.userName ?? "Chat Screen",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.only(right: 20, top: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          messages[index],
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    hintText: "Type a message...",
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send, color: Colors.black87),
                      onPressed: () {
                        setState(() {
                          if (_textController.text.trim().isNotEmpty) {
                            messages.insert(0, _textController.text.trim());
                            _textController.clear();
                          }
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
