import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_model/main.dart';
import 'package:hive_model/task_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Box<TaskModel>? boxTask;
  final taskTitle = TextEditingController();
  final taskContent = TextEditingController();
  @override
  void initState() {
    boxTask = Hive.box<TaskModel>(taskName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Column(
                  children: [
                    const Text("Add Task"),
                    TextFormField(
                      controller: taskTitle,
                      decoration:
                          const InputDecoration(hintText: "Enter a Task"),
                    ),
                    TextFormField(
                      controller: taskContent,
                      decoration:
                          const InputDecoration(hintText: "Enter a Task"),
                    )
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("No")),
                  TextButton(
                      onPressed: () {
                        final String title = taskTitle.text;
                        final String content = taskContent.text;

                        TaskModel modelTask =
                            TaskModel(title: title, content: content);
                        boxTask!.add(modelTask);
                        taskContent.clear();
                        taskTitle.clear();
                        Navigator.pop(context);
                      },
                      child: const Text("Add")),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: boxTask!.listenable(),
        builder: (BuildContext context, Box<TaskModel> task, _) {
          return ListView.builder(
            itemCount: task.length,
            itemBuilder: (context, index) {
              final key = task.keys.toList()[index];
              final value = boxTask!.get(key);
              return ListTile(
                title: Text("${value!.title}"),
                subtitle: Text("${value.content}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Column(
                                children: [
                                  const Text("Update Task"),
                                  TextFormField(
                                    controller: taskTitle,
                                    decoration: const InputDecoration(
                                        hintText: "Enter a Task"),
                                  ),
                                  TextFormField(
                                    controller: taskContent,
                                    decoration: const InputDecoration(
                                        hintText: "Enter a Task"),
                                  )
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No")),
                                TextButton(
                                    onPressed: () {
                                      final String title = taskTitle.text;
                                      final String content = taskContent.text;

                                      TaskModel modelTask = TaskModel(
                                          title: title, content: content);
                                      boxTask!.put(key, modelTask);
                                      taskContent.clear();
                                      taskTitle.clear();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Update")),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Do You Want to Delete it?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("No")),
                                  TextButton(
                                      onPressed: () {
                                        boxTask!.delete(key);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Yes"))
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.delete))
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
