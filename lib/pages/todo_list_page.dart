import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/pages/add_todo_page.dart';
import 'package:todo_app/services/todo_services.dart';
import 'package:todo_app/utilities/show_snack_bar.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade300,
        title: Text(
          'Todo List',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Colors.yellow.shade100,
        child: Visibility(
          visible: isLoading,
          replacement: RefreshIndicator(
            color: Colors.blueAccent,
            onRefresh: fetchTodo,
            child: Visibility(
              visible: items.isNotEmpty,
              replacement: Center(
                  child: Text(
                "No todos available!🤯",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              )),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item["_id"] as String;
                  return Card(
                    margin: const EdgeInsets.all(8),
                    color: Colors.yellow.shade300,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        item["title"],
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        item["description"],
                        style: TextStyle(fontSize: 15.sp, color: Colors.black),
                      ),
                      trailing: PopupMenuButton(
                        iconColor: Colors.black,
                        onSelected: (value) {
                          if (value == "edit") {
                            // Open the edit page
                            navigateToEditTodoPage(item: item);
                          } else if (value == "delete") {
                            // Delete and remove the item
                            deleteById(id: id);
                          }
                        },
                        color: Colors.black,
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: "edit",
                              child: Text("Edit",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            const PopupMenuItem(
                              value: "delete",
                              child: Text("Delete",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ];
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        onPressed: navigateToAddTodoPage,
        label: const Text(
          "Add Todo",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> navigateToAddTodoPage() async {
    final route = MaterialPageRoute(
      builder: (context) {
        return const AddTodoPage();
      },
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToEditTodoPage({required Map item}) async {
    final route = MaterialPageRoute(
      builder: (context) {
        return AddTodoPage(todo: item);
      },
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById({required String id}) async {
    final isSuccess = await TodoService.deleteById(id: id);

    if (isSuccess) {
      // Remove the item from the list
      final filtered = items.where((element) => element["_id"] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      // Show Error
      if (context.mounted) {
        showSnackBar(context,
            message: "Unable To Delete The Item", bgColor: Colors.red);
      }
    }
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodos();

    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      if (context.mounted) {
        showSnackBar(context,
            message: "Something went wrong", bgColor: Colors.red);
      }
    }
    setState(
      () {
        isLoading = false;
      },
    );
  }
}
