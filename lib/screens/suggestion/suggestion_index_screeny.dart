import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harkat_app/providers/auth_proivder.dart';
import 'package:harkat_app/screens/suggestion/suggestion_chat_screen.dart';
import 'package:harkat_app/screens/suggestion/suggestion_create_screen.dart';
import 'package:harkat_app/size_config.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class SuggestionScreen extends StatefulWidget {
  // UI Variables
  @override
  _SuggestionScreenState createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  // UI variables
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Complaint(s)/Suggustion(s)"),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: getUiWidth(10),
          vertical: getUiHeight(10),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('complaint_suggestion')
              .where('user', isEqualTo: _user.uid)
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data.docs.length == 0) {
              return Center(child: Text("0 Items"));
            }
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(
                      snapshot.data.docs[index].data()['category'],
                    ),
                    subtitle: Text(
                      snapshot.data.docs[index].data()['content'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing:
                        Text(snapshot.data.docs[index].data()['status'] ?? ""),
                    onTap: () => Get.to(
                      SuggestionChatScreen(doc: snapshot.data.docs[index]),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(SuggestionCreateScreen()),
        child: Icon(Icons.add),
      ),
    );
  }
}
