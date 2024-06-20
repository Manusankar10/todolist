import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/todo.dart';
import 'package:flutter_application_1/providers/todo_providers.dart';
import 'package:provider/provider.dart';

class EditTodoScreen extends StatefulWidget {
  final int index;
  final Todo todo;

  const EditTodoScreen({required this.index, required this.todo, super.key});

  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController = TextEditingController(text: widget.todo.description);
    _selectedDate = widget.todo.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTodo() {
    if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
      final updatedTodo = Todo(
        title: _titleController.text,
        description: _descriptionController.text,
        isCompleted: widget.todo.isCompleted,
        date: _selectedDate,
      );
      Provider.of<TodoProvider>(context, listen: false).updateTodo(widget.index, updatedTodo);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit To-Do'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTodo,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      'Date:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != _selectedDate) {
                          setState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${_selectedDate.toLocal()}'.split(' ')[0],
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveTodo,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
