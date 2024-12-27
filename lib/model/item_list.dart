import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latihan5_firebase/model/todo.dart';// Adjust the import according to your project structure

class ItemList extends StatefulWidget {
  final String transaksiDocId;
  final Todo todo;

  const ItemList({Key? key, required this.todo, required this.transaksiDocId}) : super(key: key);

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController = TextEditingController(text: widget.todo.description);
  }

  Future<void> deleteTodo() async {
    await _firestore.collection('Todos').doc(widget.transaksiDocId).delete();
  }

  Future<void> updateTodo() async {
    await _firestore.collection('Todos').doc(widget.transaksiDocId).update({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'isComplete': widget.todo.isComplete,
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference todoCollection = _firestore.collection('Todos');

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Update Todo'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Description',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Batalkan'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('Update'),
                onPressed: () {
                  updateTodo();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.todo.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.todo.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: Icon(
                widget.todo.isComplete
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: widget.todo.isComplete ? Colors.blue : Colors.grey,
              ),
              onPressed: () {
                todoCollection.doc(widget.transaksiDocId).update({
                  'isComplete': !widget.todo.isComplete,
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                deleteTodo();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}