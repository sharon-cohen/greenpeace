import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:greenpeace/global.dart' as globals;
import 'package:greenpeace/evants/add_event.dart';
import 'package:flutter/material.dart';
import 'package:greenpeace/Footer/footer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:greenpeace/MessToOnePersonFromMenager/SendMessFromMenager.dart';
final _firestore = Firestore.instance;

class userStream extends StatelessWidget {
  userStream({this.width_page, this.height_page});
  final height_page;
  final width_page;

  @override
  Widget build(BuildContext context){
    return  StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("users").snapshots(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final users = snapshot.data.documents;

        List<userContainer> usersContainers = [];
        for (var user in users) {
          if (user.data['role'] != "menager") {
            final name = user.data['name'];
            final role=user.data['role'];
            final Id = user.documentID;

            //print( reportModel.getReportfromMess(messId).text.toString());
            final userContainerVar = userContainer(

              User: globals.user(
                name: name,
                role: role,
                id: Id,
              ),
              height_page: height_page,
              width_page: width_page,
            );
            usersContainers.add(userContainerVar);
            //  reports.sort((a, b) => b.time.compareTo(a.time));
          }
        }
        return Material(
          child: Column(

            children: usersContainers,
          ),
        );
      },
    );
  }
}

class userContainer extends StatelessWidget {
  final globals.user User;
  var height_page;
  var width_page;
  userContainer(
      {
        this.User,
        this.height_page,
        this.width_page,
      });


  @override
  Widget build(BuildContext context) {
    return ListTile(

      leading: Container(

        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Icon(Icons.receipt, color: Colors.black),
      ),
      title: Text(
        User.name,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 10),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Row(

        children: <Widget>[
          Flexible(
            child: Text(User.role),
          ),

        ],
      ),
      trailing: FlatButton(
        child:
        Icon(Icons.keyboard_arrow_left, color: Colors.black, size: 30.0),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SendOneUser(
                    User:User,
                  )));

        },
      ),
    );
  }
}