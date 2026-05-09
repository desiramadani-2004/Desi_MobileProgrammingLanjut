import 'package:flutter/material.dart';
import 'package:utd_advanced_app/features/todo/domain/todo_model.dart';
import 'package:utd_advanced_app/features/todo/data/isar_service.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final IsarService _isarService = IsarService();
  final TextEditingController _textController = TextEditingController();

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Catatan Baru"),
        content: TextField(
          controller: _textController,
          decoration: const InputDecoration(hintText: "Mau ngerjain apa hari ini?"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                final newTodo = Todo()
                  ..title = _textController.text
                  ..isCompleted = false
                  ..prioritas = "Tinggi"; // Data tambahan dari Tugas Mandiri
                
                _isarService.saveTodo(newTodo);
                _textController.clear();
              }
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offline-First Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      // Keajaiban terjadi di sini! KITA TIDAK PERLU SETSTATE SAMA SEKALI!
      body: StreamBuilder<List<Todo>>(
        stream: _isarService.listenToTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final todos = snapshot.data ?? [];
          if (todos.isEmpty) {
            return const Center(child: Text("Belum ada catatan."));
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Card(
                child: ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text("Prioritas: ${todo.prioritas ?? 'Normal'}"), // Tampil di UI
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (value) {
                      _isarService.updateTodoStatus(todo.id, value!);
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _isarService.deleteTodo(todo.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}