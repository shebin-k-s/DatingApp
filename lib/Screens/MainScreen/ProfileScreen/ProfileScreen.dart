import 'dart:ffi';

import 'package:datingapp/Screens/AuthScreen/AuthScreen.dart';
import 'package:datingapp/Screens/MainScreen/ProfileScreen/AccountScreen.dart';
import 'package:datingapp/Screens/OnboardingScreen/OnboardingScreen.dart';
import 'package:datingapp/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ValueNotifier<bool> _locationEnabledNotifier = ValueNotifier(true);

  final ValueNotifier<bool> _notificationsEnabledNotifier = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: ListView(
        children: [
          ListTile(
            title: const Text(
              'Account',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: const Icon(
              Icons.person_outline,
              size: 28,
              color: kColor,
            ),
            onTap: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AccountSettingsScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text(
              'Privacy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: const Icon(
              Icons.lock_outline,
              size: 28,
              color: kColor,
            ),
            onTap: () {
              // Navigate to privacy settings
            },
          ),
          ValueListenableBuilder(
            valueListenable: _notificationsEnabledNotifier,
            builder: (context, notificationEnabled, child) {
              return SwitchListTile(
                title: Row(
                  children: [
                    Icon(
                      notificationEnabled
                          ? Icons.notifications_on_outlined
                          : Icons.notifications_off_outlined,
                      size: 28,
                      color: kColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Enable Notifications',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                value: notificationEnabled,
                onChanged: (bool value) {
                  _notificationsEnabledNotifier.value = value;
                },
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: _locationEnabledNotifier,
            builder: (context, locationEnabled, child) {
              return SwitchListTile(
                title: Row(
                  children: [
                    Icon(
                      locationEnabled
                          ? Icons.location_on_outlined
                          : Icons.location_off_outlined,
                      size: 28,
                      color: kColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Enable Location',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                value: locationEnabled,
                onChanged: (bool value) {
                  _locationEnabledNotifier.value = value;
                },
              );
            },
          ),
          ListTile(
            title: const Text(
              'Help & Support',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: const Icon(
              Icons.help_outline,
              size: 28,
              color: kColor,
            ),
            onTap: () {},
          ),
          ListTile(
            title: const Text(
              'About',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: const Icon(
              Icons.info_outline,
              size: 28,
              color: kColor,
            ),
            onTap: () {},
          ),
          ListTile(
            title: const Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: const Icon(
              Icons.exit_to_app,
              size: 28,
              color: kColor,
            ),
            onTap: () async {
              final sharedPref = await SharedPreferences.getInstance();
              sharedPref.clear();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (ctx) => Onboardingscreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
