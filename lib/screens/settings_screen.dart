import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart'; // Make sure this points to the correct location of your plugin initialization

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _scheduleDailyReminder() async {
    // Android-specific notification configuration
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_reminder', // Channel ID
      'Daily Reminder', // Channel name
      channelDescription: 'Daily prompt to write in diary',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    // Schedule notification (this will only show once, not daily)
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Time to Reflect 🌙',
      'Don’t forget to write in your diary today!',
      notificationDetails,
    );

   
    // android_alarm_manager or a background service to trigger this method daily.

    // Feedback to user
    debugPrint('Daily reminder scheduled for 8:00 PM.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _scheduleDailyReminder,
          icon: Icon(Icons.alarm),
          label: Text('Enable Daily Reminder'),
        ),
      ),
    );
  }
}
