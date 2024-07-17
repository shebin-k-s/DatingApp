import 'package:datingapp/Screens/MainScreen/MessageScreen/ChatScreen.dart';
import 'package:datingapp/api/Url.dart';
import 'package:datingapp/api/data/profiles.dart';
import 'package:datingapp/api/models/messaged_profiles/messaged_profiles.dart';
import 'package:datingapp/main.dart';
import 'package:datingapp/utils/timeAgo.dart';
import 'package:datingapp/widgets/MessageStatusIcon.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  MessageScreen({super.key});
  bool isLoading = true;

  final ValueNotifier<MessagedProfiles> messagedProfilesNotifier =
      ValueNotifier(MessagedProfiles());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchMessagedProfiles();
    });
    return RefreshIndicator(
      onRefresh: () => _fetchMessagedProfiles(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Messages',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: messagedProfilesNotifier,
              builder: (context, value, child) {
                if (value.messagedProfiles != null &&
                    value.messagedProfiles!.isNotEmpty) {
                  return ListView.separated(
                    itemCount: value.messagedProfiles!.length,
                    itemBuilder: (context, index) {
                      final messagedProfile = value.messagedProfiles![index];
                      final time =
                          timeAgo(messagedProfile.latestMessageSendAt!);
                      return _buildMessageTile(
                          messagedProfile.profile!.username ?? 'username',
                          messagedProfile.profile!.profilePic ?? '',
                          messagedProfile.latestMessage ?? 'message',
                          messagedProfile.messageStatus ?? '',
                          time,
                          messagedProfile.unreadCount ?? 0, () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => ChatScreen(
                              profileId: messagedProfile.profile!.id ?? '',
                              profilePic:
                                  messagedProfile.profile!.profilePic ?? '',
                              username: messagedProfile.profile!.username ??
                                  'Username',
                            ),
                          ),
                        );
                        _fetchMessagedProfiles();
                      });
                    },
                    separatorBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.only(left: 26, right: 26),
                        child: Divider(),
                      );
                    },
                  );
                } else if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'Start a new chat...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kColor,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchMessagedProfiles() async {
    try {
      isLoading = true;
      const maxRetries = 3;
      int retryCount = 0;
      bool retry = true;
      while (retry && retryCount < maxRetries) {
        retry = false;
        try {
          final result = await ProfileDB().getMessagedProfiles();
          messagedProfilesNotifier.value = result;
        } catch (e) {
          print('Error fetching profiles: $e');
          retry = true;
          retryCount++;
          await Future.delayed(Duration(seconds: retryCount));
        }
      }
    } catch (e) {
      print('Error fetching profiles: $e');
    } finally {
      isLoading = false;
    }
  }

  Widget _buildMessageTile(
    String name,
    String profilePic,
    String message,
    String messageStatus,
    String time,
    int unreadCount,
    Function onClick,
  ) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
            '${Url().baseUrl}$profilePic',
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onClick(),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              title: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      MessageStatusIcon(messageStatus, 18),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          message,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => onClick(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              if (unreadCount > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
