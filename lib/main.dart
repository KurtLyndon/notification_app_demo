// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notification_app_v2/model/notification_badge.dart';
import 'package:notification_app_v2/model/pushNotification_model.dart';
import 'package:overlay_support/overlay_support.dart';

void main() 
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget 
{
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) 
  {
    return OverlaySupport
    (
      child: MaterialApp
      (
        title: 'Flutter Demo',
        theme: ThemeData
        (
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget 
{
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> 
{
  //init
  late final FirebaseMessaging _messaging;
  late int _totalNotificationCounter;

  //model
  PushNotification? _notificationInfo;

  //register notification for pushing notification in foreground state
  void registerNotification() async
  {
    await Firebase.initializeApp();
    // create instance for firebase messaging
    _messaging = FirebaseMessaging.instance;
    // three type of state in notification
    // not determined (null), granted (true) and decline (false)
    NotificationSettings settings = await _messaging.requestPermission
    (
      alert: true,
      badge: true,
      provisional: false,
      sound: true
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized)
    {
      print("User granted the permission");

      FirebaseMessaging.onMessage.listen((RemoteMessage message) 
      { 
        PushNotification notification = PushNotification
        (
          title:  message.notification!.title,
          body: message.notification!.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() 
        {
          _totalNotificationCounter++;
          _notificationInfo = notification;
        });

        if(notification != null)
        {
          showSimpleNotification
          (
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(totalNotification: _totalNotificationCounter),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2)
          );
        }
      });
    }
    else
    {
      print("Permission declined by user");
    }

  }
  
  //check for notification for pushing notification in terminated state
  void checkForInitialMessage() async
  {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null)
    {
      PushNotification notification = PushNotification
        (
          title:  initialMessage.notification!.title,
          body: initialMessage.notification!.body,
          dataTitle: initialMessage.data['title'],
          dataBody: initialMessage.data['body'],
        );

      setState(() 
      {
        _totalNotificationCounter++;
        _notificationInfo = notification;
      });
    }
  }

  @override
  void initState()
  {
    //when app is in background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message)
    {
      PushNotification notification = PushNotification
        (
          title:  message.notification!.title,
          body: message.notification!.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() 
        {
          _totalNotificationCounter++;
          _notificationInfo = notification;
        });
    });

    //when app is in foreground state
    registerNotification();

    //when app is in terminated state
    checkForInitialMessage();

    _totalNotificationCounter = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar:  AppBar( title: const Text("Push Notification"),),
      body: Center
      (
        child: Column
        (
          mainAxisAlignment:  MainAxisAlignment.center,
          children: 
          [
            Text
            (
              "Flutter Push Notification",
              textAlign: TextAlign.center,
              style: TextStyle
              (
                color:  Colors.black,
                fontSize: 20,
              ),
            ),
            //Show notification badge count the total notification received
            NotificationBadge(totalNotification: _totalNotificationCounter),
            SizedBox(height: 30),
            //when notificationInfo is not null
            _notificationInfo != null
            ? Column
            (
              crossAxisAlignment: CrossAxisAlignment.center,
              children: 
              [
                Text
                (
                  "TITLE: ${_notificationInfo!.dataTitle ?? _notificationInfo!.title}",
                  style: TextStyle
                  (
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 9,),
                Text
                (
                  "BODY: ${_notificationInfo!.dataBody ?? _notificationInfo!.body}",
                  style: TextStyle
                  (
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            )
            : Container
            (

            ),
          ],
        ),
      ),
    );
  }
}
