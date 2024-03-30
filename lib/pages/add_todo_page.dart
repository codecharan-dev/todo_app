import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({Key? key, this.todo}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  // Defining controllers for text form field to change the state.

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    final todo = widget.todo;
    super.initState();
    if (todo != null) {
      isEdit = true;
      final title = todo["title"];
      final description = todo["description"];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade300,
        title: Text(
          isEdit ? 'Edit Todo ' : "Add Todo",
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: Colors.deepOrange.shade100,
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(left: 8.w, right: 8.w, top: 25.h),
              height: 45.h,
              width: 300.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: TextFormField(
                controller: titleController,
                cursorHeight: 25,
                cursorColor: Colors.orange.withOpacity(0.7),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(8.w, 16.h, 10.w, 10.h),
                  border: const OutlineInputBorder(),
                  hintText: "Enter Todo Title",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepOrange.shade600),
                  ),
                ),
                keyboardType: TextInputType.multiline,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 8.w, right: 8.w, top: 20.h),
              height: 150.h,
              width: 300.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: TextFormField(
                controller: descriptionController,
                cursorColor: Colors.orange.withOpacity(0.9),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  border: const OutlineInputBorder(),
                  hintText: "Enter Todo Description",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepOrange.shade600),
                  ),
                ),
                minLines: 8,
                maxLines: 20,
                keyboardType: TextInputType.multiline,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 50.w, right: 50.w, top: 30.h),
              height: 45.h,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: isEdit ? updateData : submitData,
                child: Center(
                  child: Text(
                    isEdit ? "Update" : "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      // print("You cannot call update without todo data");
      return;
    }

    final id = todo["_id"];
    // Get the data from the form

    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    // updated data to the form

    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    // Show success or fail message based on status

    if (response.statusCode == 200) {
      

      // Show Success message
      showSnackBar(message: "Updation Success", bgColor: Colors.green);
    } else {
      // Show failure message
      showSnackBar(message: "Updation Failure", bgColor: Colors.red);
    }
    
  }

  Future<void> submitData() async {
    // Get the data from the form

    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    // Submit data to the form

    const url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    // Show success or fail message based on status

    if (response.statusCode == 201) {
      // Makes text disappear after tapped submit button
      titleController.clear();
      descriptionController.clear();

      // Show Success message
      showSnackBar(message: "Creation Success", bgColor: Colors.green);
    } else {
      // Show failure message
      showSnackBar(message: "Creation Failure", bgColor: Colors.red);
    }
  }

  // Creating snack bar to show creation success or failure
  void showSnackBar({required String message, required Color bgColor}) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(
        message,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: bgColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
