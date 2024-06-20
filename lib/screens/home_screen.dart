import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/todo_providers.dart';
import 'package:flutter_application_1/screens/add_todo_screen.dart';
import 'package:flutter_application_1/screens/edit_todo_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/notification_screen.dart';
import 'package:flutter_application_1/screens/profile_screen.dart';
import 'package:flutter_application_1/screens/search_screen.dart'; // Import the SearchScreen
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Future<String?> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String?>(
          future: _getUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Welcome');
            } else {
              final username = snapshot.data ?? 'User';
              return Text(
                'Welcome, ${username.substring(0, 4)}',
              );
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todoProvider.todos.length,
        itemBuilder: (ctx, index) {
          final todo = todoProvider.todos[index];

          return ListTile(
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.description,
                ),
                Text(
                  todo.isCompleted
                      ? 'Completed'
                      : "Due Date: ${todo.date.toLocal()}".split(' ')[0],
                  style: TextStyle(
                    color: todo.isCompleted ? Colors.green : Colors.black,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: todo.isCompleted,
                  onChanged: (_) {
                    todoProvider.toggleTodoStatus(index);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    todoProvider.deleteTodo(index);
                  },
                ),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditTodoScreen(
                    index: index,
                    todo: todo,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddTodoScreen(),
            ),
          );
        },
        backgroundColor: const Color.fromRGBO(251, 49, 49, 1),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerDocked, // Add this line to position FAB in the center
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => _onItemTapped(0),
              color: _selectedIndex == 0
                  ? const Color.fromRGBO(251, 49, 49, 1)
                  : Colors.grey,
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              color: _selectedIndex == 1
                  ? const Color.fromRGBO(251, 49, 49, 1)
                  : Colors.grey,
            ),
            const SizedBox(width: 48.0), // Empty space for the center FAB
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              ),
              color: _selectedIndex == 2
                  ? const Color.fromRGBO(251, 49, 49, 1)
                  : Colors.grey,
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              ),
              color: _selectedIndex == 3
                  ? const Color.fromRGBO(251, 49, 49, 1)
                  : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
