import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../screens/chat/chat_main_page.dart';


class NotificationController{
  static String userid = "";
  static BuildContext? savedContext;


  static void setSavedContext(BuildContext context) {
    savedContext = context;
  }

  static void navigateToChatPage() {
    if (savedContext != null) {
      Navigator.push(savedContext!, MaterialPageRoute(builder: (context) => ChatHomePageWidget()));
      savedContext = null;
    }
  }
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'high_importance_channel',
          channelGroupKey: 'high_importance_channel',
          channelName: "Notification",
          channelDescription: "Notification for project",
          importance: NotificationImportance.High,
          ledColor: Colors.deepOrange,
          defaultColor: Colors.purpleAccent,
          onlyAlertOnce: true,
          playSound: true,
          channelShowBadge: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(channelGroupKey: 'high_importance_channel_group', channelGroupName: "Group")
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
            (isAllowed) async {
              if(!isAllowed) {
                await AwesomeNotifications().requestPermissionToSendNotifications();
              }
            },
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
    );
  }

  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {

  }

  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {

  }

  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    if (receivedAction.buttonKeyPressed == 'ChatPage') {
      navigateToChatPage();
    }
  }
}