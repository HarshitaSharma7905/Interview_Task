import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'DBHelper.dart';




class Task extends StatefulWidget {
  const Task({Key? key}) : super(key: key);

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  TextEditingController FirstNameController=TextEditingController();
  TextEditingController LastNameController=TextEditingController();
  TextEditingController EmailController=TextEditingController();

  String fname='';
  String lname='';
  String email='';
  String avatar='';
  int userid=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page'),centerTitle: true,actions: [GestureDetector(onTap: () {
        insertData();
        setState(() {

        });
      },child: Icon(Icons.refresh))]),
      body: Column(
        children: [
          Container(
            height: 100,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: DBHelper.instance.fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No data available.');
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int index = 0; index < snapshot.data!.length; index++)
                          Container(
                            margin: EdgeInsets.all(10),
                            child: ElevatedButton(
                              onPressed: () async {
                                int id = snapshot.data![index]['id'];
                                Map<String, dynamic> user =
                                await DBHelper.instance.getUserById(id);
                                setState(() {
                                  userid=user['id'];
                                  fname = user['firstName'];
                                  lname = user['lastName'];
                                  email = user['email'];
                                  avatar = user['avatar'];


                                });
                              },
                              child: Text(snapshot.data![index]['firstName']),
                            ),
                          ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          Divider(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(width: 200,height: 50,child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [ElevatedButton(onPressed: () {
                  String firstname=FirstNameController.text.toString();
                  String lastName=LastNameController.text.toString();
                  String email=EmailController.text.toString();
                  Map<String,dynamic> row={'id':userid,'firstName':firstname,'lastName':lastName,'email':email};
                  DBHelper.instance.update(row);
                  setState(() {

                  });
                }, child: Text('Update')),
                  ElevatedButton(onPressed: () {
                    print(userid.toString());
                    DBHelper.instance.delete(userid);
                    setState(() {

                    });
                  }, child: Text('Delete'))],
              )),
              Container( width: 100,height: 100,decoration: BoxDecoration(shape: BoxShape.circle),child: Image.network(avatar,scale: 2),)
            ],),
          Divider(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 100,
                  child: Text('First Name:')),
              Container(
                  width: 200,
                  child: TextField(controller: FirstNameController,decoration: InputDecoration(hintText: fname),)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 100,
                  child: Text('Last Name:')),
              Container(
                  width: 200,
                  child: TextField(controller: LastNameController,decoration: InputDecoration(hintText: lname),)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 100,
                  child: Text('Email:')),
              Container(
                  width: 200,
                  child: TextField(controller:EmailController,decoration: InputDecoration(hintText: email),)),
            ],
          ),






        ],
      ),
    );


  }

  //to insert data
  Future<void> insertData() async{
    final response = await http.get(Uri.parse('https://reqres.in/api/users?page=1'));
    final responseData = jsonDecode(response.body);
    for (var userData in responseData['data']) {
      Map<String,dynamic> user = {
        'email': userData['email'],
        'firstName': userData['first_name'],
        'lastName': userData['last_name'],
        'avatar': userData['avatar'],
      };
      print(
          await DBHelper.instance.insert(user));
    }
  }

}


