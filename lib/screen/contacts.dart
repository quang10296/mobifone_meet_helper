import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import '../main.dart';
import '../model/contact_user_model.dart';
import '../model/user_model.dart';
import 'calling.dart';
import 'waiting.dart';
import '../helper/socket_helper.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobifone_meet/mbf_meet.dart';
import '../config/globals.dart';

var socket = Singleton().socket;

class ContactScreen extends StatelessWidget {
  var arrUserContacts = [
    ContactUserModel(
        ottUserId: "31affff1-7eff-4743-a294-64efcd97c81a",
        username: "hao",
        phoneNumber: "1111111111",
        displayName: "hao"),
    ContactUserModel(
        ottUserId: "31affff1-7eff-4743-a294-64efcd97c81a",
        username: "hao",
        phoneNumber: "1111111111",
        displayName: "hao"),
    ContactUserModel(
        ottUserId: "31affff1-7eff-4743-a294-64efcd97c81a",
        username: "hao",
        phoneNumber: "1111111111",
        displayName: "hao"),
    ContactUserModel(
        ottUserId: "31affff1-7eff-4743-a294-64efcd97c81a",
        username: "hao",
        phoneNumber: "1111111111",
        displayName: "hao"),
    ContactUserModel(
        ottUserId: "31affff1-7eff-4743-a294-64efcd97c81a",
        username: "hao",
        phoneNumber: "1111111111",
        displayName: "hao"),
    ContactUserModel(
        ottUserId: "31affff1-7eff-4743-a294-64efcd97c81a",
        username: "hao",
        phoneNumber: "1111111111",
        displayName: "hao"),
  ];

  @override
  Widget build(BuildContext context) {
    const title = 'Contacts cua Thanh';
    Singleton().connectServer(context);
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: 2 > 0
            ? ListView.separated(
                itemCount: arrUserContacts.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(' ${arrUserContacts[index].displayName} '),
                    onTap: () {
                      print(index);
                      socket.emit('NewRoom', {
                        "toUserId": '${arrUserContacts[index].ottUserId}',
                        "call_type": "video",
                        "name": "${arrUserContacts[index].displayName}",
                      });
                      pushToWaitingScreen(context);
                    }, // Handle your onTap here.
                  );
                },
              )
            : const Center(child: Text('No items')),
      ),
    );
  }
}

