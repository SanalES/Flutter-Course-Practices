import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("to_do_Box");
  runApp(MaterialApp(
    home: HiveCrud(),
  ));
}

class HiveCrud extends StatefulWidget {
  @override
  State<HiveCrud> createState() => _HiveCrudState();
}

class _HiveCrudState extends State<HiveCrud> {
  List<Map<String, dynamic>> task = [];
  final myBox = Hive.box("to_do_Box");

  @override
  void initState() {
    loadOrReadTask();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo"),
      ),
      body: task.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
          itemCount: task.length,
          itemBuilder: (ctx, index) {
            final mytask = task[index];
            return Card(
              child: ListTile(
                title: Text(task[index]['taskname']),
                subtitle: Text(task[index]['taskcont']),
                trailing: Wrap(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showTask(context, null),
        label: const Text("Create Task"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  final taskController = TextEditingController();
  final contentController = TextEditingController();

  void showTask(BuildContext context, int? itemKey) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 120,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: taskController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Task Name"),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Task Content"),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (taskController.text != "" &&
                          contentController.text != "") {
                        if (itemKey != null) {
                          createTask({
                            "name": taskController.text.trim(),
                            "content": contentController.text.trim()
                          });
                        } else {
                          updateTask(itemKey, {
                            "name": taskController.text.trim(),
                            "content": contentController.text.trim()
                          });
                        }
                      }
                      contentController.text = "";
                      taskController.text = "";
                      Navigator.of(context).pop();
                    },
                    child: Text(itemKey == null ? "Create Task" : "Update Task"))
              ],
            ),
          );
        });
  }

  Future<void> createTask(Map<String, dynamic> task) async {
    await myBox.add(task);
    loadOrReadTask(); // Reload the tasks after adding a new one
  }

  void updateTask(int? itemKey, Map<String, dynamic> map) {
    // Implement your update logic here
  }

  void loadOrReadTask() {
    final taskFromHive = myBox.keys.map((key) {
      final value = myBox.get(key);
      return {
        'id': key,
        'taskname': value['name'],
        'taskcont': value['content']
      };
    }).toList();
    setState(() {
      task = taskFromHive.reversed.toList();
    });
  }
}
