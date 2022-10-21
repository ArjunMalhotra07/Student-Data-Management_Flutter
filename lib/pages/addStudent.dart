import 'dart:async';
import 'dart:convert';
import 'package:api_test_app/utils/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddStudent extends StatefulWidget {
  AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  TextEditingController idController = TextEditingController();
  TextEditingController fnController = TextEditingController();
  TextEditingController mnController = TextEditingController();
  TextEditingController snController = TextEditingController();
  TextEditingController cgController = TextEditingController();
  TextEditingController ctController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var _timer;
    const box = SizedBox(
      height: 50,
    );
    Future<String> addStudent() async {
      final jsonbody = jsonEncode(<String, dynamic>{
        "StudentId": int.parse(idController.text),
        "StudentName": snController.text,
        "FatherName": fnController.text,
        "MotherName": mnController.text,
        "Cgpa": double.parse(cgController.text),
        "City": ctController.text
      });
      print(jsonbody);
      // final responseofAPI = await http.post(
      //     Uri.parse('http://192.168.1.19:8081/everyStudent'),
      //     headers: {'Content-Type': 'application/json'},
      //     body: jsonbody);
      final responseofAPI = await http.post(
          Uri.parse('http://192.168.33.98:8081/everyStudent'),
          headers: {'Content-Type': 'application/json'},
          body: jsonbody);
      print("Code -----> ${responseofAPI.statusCode}");

      print(jsonDecode(responseofAPI.body));
      print(responseofAPI.body);
      return jsonDecode(responseofAPI.body);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 50, 50, 10),
          child: SingleChildScrollView(
            child: Column(children: [
              CustomField(hintText: "ID", controller: idController),
              box,
              CustomField(hintText: "Student's Name", controller: snController),
              box,
              CustomField(hintText: "Father's Name", controller: fnController),
              box,
              CustomField(hintText: "Mother's Name", controller: mnController),
              box,
              CustomField(hintText: "CGPA", controller: cgController),
              box,
              CustomField(hintText: "City", controller: ctController),
              box,
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.purple),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ))),
                child: const Text(
                  "Add Student",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
                onPressed: () async {
                  String response = await addStudent();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        _timer = Timer(const Duration(seconds: 3), () {
                          Navigator.of(context).pop();
                        });
                        return AlertDialog(
                          content: Text(response),
                        );
                      }).then((value) {
                    if (_timer.isActive) {
                      _timer.cancel();
                    }
                    setState(() {
                      idController.clear();
                      fnController.clear();
                      mnController.clear();
                      snController.clear();
                      cgController.clear();
                      ctController.clear();
                    });
                  });
                },
              )
            ]),
          ),
        ),
      ),
    );
  }
}
