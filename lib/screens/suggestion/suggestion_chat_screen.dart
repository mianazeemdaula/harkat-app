import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:harkat_app/constants.dart';
import 'package:harkat_app/size_config.dart';

class SuggestionChatScreen extends StatefulWidget {
  final DocumentSnapshot doc;
  final String suggestionId;
  const SuggestionChatScreen({Key key, this.doc, this.suggestionId})
      : super(key: key);
  @override
  _SuggestionChatScreenState createState() => _SuggestionChatScreenState();
}

class _SuggestionChatScreenState extends State<SuggestionChatScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool isAdminMsg;

  User _user = FirebaseAuth.instance.currentUser;

  DocumentSnapshot<Map<String, dynamic>> _document;

  @override
  void initState() {
    super.initState();
    if (widget.suggestionId != null && widget.doc == null) {
      FirebaseFirestore.instance
          .doc('complaint_suggestion/' + widget.suggestionId)
          .get()
          .then((value) {
        if (mounted) {
          setState(() {
            _document = value;
          });
        }
      });
    } else {
      _document = widget.doc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suggustion/Complaint"),
      ),
      backgroundColor: Colors.grey.shade200,
      body: _document == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text("${_document.data()['category']}",
                            style: Theme.of(context).textTheme.headline6),
                        Text("${_document.data()['date'].toDate()}"),
                        Text("${_document.data()['content']}"),
                      ],
                    ),
                  ),
                  SizedBox(height: getUiHeight(10)),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("complaint_suggestion")
                          .doc(_document.id)
                          .collection("messages")
                          .orderBy('time', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Something went wrong"));
                        }
                        return Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: ListView.builder(
                                  reverse: true,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, i) {
                                    isAdminMsg =
                                        snapshot.data.docs[i].data()['user'] ==
                                                _user.uid
                                            ? true
                                            : false;
                                    return Container(
                                      margin: EdgeInsets.only(
                                        bottom: 10,
                                        right: isAdminMsg
                                            ? 0
                                            : SizeConfig.screenWidth * 0.45,
                                        left: isAdminMsg
                                            ? SizeConfig.screenWidth * 0.45
                                            : 0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: isAdminMsg
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              color: isAdminMsg
                                                  ? kPrimaryColor
                                                      .withOpacity(0.5)
                                                  : kSecondaryColor
                                                      .withOpacity(0.5),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                    "${snapshot.data.docs[i].data()['content']}"),
                                                Text(
                                                  snapshot.data.docs[i]
                                                              .data()['time'] !=
                                                          null
                                                      ? "${snapshot.data.docs[i].data()['time'].toDate()}"
                                                      : "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .overline
                                                      .copyWith(fontSize: 8),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              child: FormBuilder(
                                key: _fbKey,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: FormBuilderTextField(
                                        name: 'message',
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                              context)
                                        ]),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed: sendMessage,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  sendMessage() async {
    try {
      if (_fbKey.currentState.saveAndValidate()) {
        Map<String, dynamic> _data = {
          'content': _fbKey.currentState.value['message'],
          'user': _user.uid,
          'time': FieldValue.serverTimestamp()
        };
        await FirebaseFirestore.instance
            .doc("complaint_suggestion/" + _document.id)
            .collection("messages")
            .doc()
            .set(_data);
        _fbKey.currentState.reset();
      }
    } catch (e) {
      Get.snackbar(
        "Exception!",
        "$e",
        backgroundColor: Colors.red.withOpacity(0.5),
      );
    }
  }
}
