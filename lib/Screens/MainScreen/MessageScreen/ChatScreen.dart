import 'package:datingapp/api/models/chat_model/conversation.dart';
import 'package:datingapp/widgets/MessageStatusIcon.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:datingapp/api/data/profiles.dart';
import 'package:datingapp/api/models/chat_model/chat_model.dart';
import 'package:datingapp/api/models/chat_model/message.dart';
import 'package:datingapp/api/Url.dart';
import 'package:datingapp/main.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String username;
  final String profilePic;
  final String profileId;

  const ChatScreen({
    Key? key,
    required this.username,
    required this.profilePic,
    required this.profileId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatModel messages = ChatModel(conversation: []);
  late IO.Socket socket;
  final TextEditingController msgController = TextEditingController();
  bool hasText = false;

  @override
  void initState() {
    super.initState();
    fetchMessages();
    connectSocket();
  }

  @override
  void dispose() {
    socket.disconnect();
    msgController.dispose();
    super.dispose();
  }

  void fetchMessages() async {
    try {
      const maxRetries = 3;
      int retryCount = 0;
      bool retry = true;
      while (retry && retryCount < maxRetries) {
        retry = false;
        try {
          final result = await ProfileDB().getChats(widget.profileId);

          setState(() {
            messages = result;
          });
          print('Fetched messages: ${messages.conversation}');
        } catch (e) {
          print('Error fetching messages: $e');
          retry = true;
          retryCount++;
          await Future.delayed(Duration(seconds: retryCount));
        }
      }
    } catch (e) {
      print('Error fetching messages: $e');
    } finally {}
  }

  void connectSocket() async {
    final sharedPref = await SharedPreferences.getInstance();
    final authorization = sharedPref.getString('TOKEN');
    print(authorization);

    socket = IO.io(
      Url().baseUrl,
      IO.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
          {'authorization': authorization}).build(),
    );
    socket.connect();

    socket.on('ready', (_) {
      print('Socket is ready');
      socket.emit('messageSeen', widget.profileId);
    });

    socket.on('newMessage', (data) {
      setState(() {
        _addMessageToChatModel(Message.fromJson(data));
      });
    });
  }

  void sendMessage() async {
    if (msgController.text.trim().isNotEmpty) {
      try {
        final msg = msgController.text;
        final tempId = DateTime.now().millisecondsSinceEpoch.toString();
        print(DateTime.now());
        setState(() {
          _addMessageToChatModel(Message(
            id: tempId,
            message: msg,
            receiver: widget.profileId,
            sendAt: DateTime.now(),
          ));
        });
        msgController.clear();
        hasText = false;
        bool retry = true;
        while (retry) {
          retry = false;
          try {
            final chat = await ProfileDB().sendMessage(widget.profileId, msg);
            await Future.delayed(const Duration(milliseconds: 5000));
            setState(() {
              _updateOrReplaceMessage(tempId, chat);
            });
          } catch (e) {
            print('Error sending message: $e');
            retry = true;
            await Future.delayed(const Duration(seconds: 2));
          }
        }
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }

  void _updateOrReplaceMessage(String oldId, Message newMessage) {
    for (var conv in messages.conversation!) {
      for (int i = 0; i < conv.messages!.length; i++) {
        if (conv.messages![i].id == oldId) {
          conv.messages![i] = newMessage;
          return;
        }
      }
    }
  }

  void _addMessageToChatModel(Message newMessage) {
    final DateTime localDateTime = newMessage.sendAt!.toLocal();
    final String messageDate = localDateTime.toIso8601String().split('T').first;
    bool dateExists = false;
    for (var conv in messages.conversation!) {
      if (conv.date == messageDate) {
        print('sss ${conv.date}');
        conv.messages!.add(newMessage);
        dateExists = true;
        break;
      }
    }
    if (!dateExists) {
      messages.conversation!.insert(
        0,
        Conversation(
          date: messageDate,
          messages: [newMessage],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Icon(
                Icons.chevron_left,
                color: kColor,
                size: 32,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage('${Url().baseUrl}${widget.profilePic}'),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.username,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: kColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: messages.conversation!.length,
              itemBuilder: (context, index) {
                final conversation = messages.conversation![index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        conversation.date ?? '',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: conversation.messages!.length,
                      itemBuilder: (context, msgIndex) {
                        final message = conversation.messages![msgIndex];
                        final date = message.sendAt!.toString();
                        DateTime dateTime = DateTime.parse(date).toLocal();
                        String formattedTime =
                            DateFormat('h:mm a').format(dateTime);
                        return MessageBubble(
                          message: message.message!,
                          isMe: message.sender != widget.profileId,
                          status: message.status ?? '',
                          time: formattedTime,
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            height: 90,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msgController,
                    minLines: 1,
                    maxLines: 20,
                    onChanged: (text) {
                      setState(() {
                        hasText = text.trim().isNotEmpty;
                      });
                    },
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Your message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                hasText
                    ? IconButton(
                        icon: const Icon(
                          Icons.send,
                          size: 28,
                        ),
                        onPressed: sendMessage,
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.mic,
                          size: 28,
                        ),
                        onPressed: () {},
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;
  final String status;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.time,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.7;

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 100,
            maxWidth: maxWidth,
          ),
          child: IntrinsicWidth(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFFFFE8E8) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          time,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 101, 100, 100),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      if (isMe) MessageStatusIcon(status, 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
