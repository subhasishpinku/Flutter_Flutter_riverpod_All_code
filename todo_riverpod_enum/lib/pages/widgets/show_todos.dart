import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod_enum/services/todo_service.dart';

import '../../models/todo_model.dart';
import '../providers/todo_filter/todo_filter_provider.dart';
import '../providers/todo_item/todo_item_provider.dart';
import '../providers/todo_list/todo_list_provider.dart';
import '../providers/todo_list/todo_list_state.dart';
import '../providers/todo_search/todo_search_provider.dart';
import 'todo_item.dart';

class ShowTodos extends ConsumerStatefulWidget {
  const ShowTodos({super.key});

  @override
  ConsumerState<ShowTodos> createState() => _ShowTodosState();
}

class _ShowTodosState extends ConsumerState<ShowTodos> {
  Widget prevTodosWidget = const SizedBox.shrink();
 final TodoService _todoService = TodoService();
  List<Todo> _todos = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      ref.read(todoListProvider.notifier).getTodos();
      // _fetchTodos();
    });
    
  }
  Future<void> _fetchTodos() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final todos = await _todoService.getTodos();
      setState(() {
        _todos = todos;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addTodo() async {
    final desc = await _showTodoDialog();
    if (desc != null && desc.isNotEmpty) {
      final newTodo = Todo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        desc: desc,
        completed: false,
      );
      await _todoService.addTodo(newTodo);
      _fetchTodos();
    }
  }

  void _editTodo(Todo todo) async {
    final desc = await _showTodoDialog(initialDesc: todo.desc);
    if (desc != null && desc.isNotEmpty) {
      await _todoService.editTodo(todo.id, desc);
      _fetchTodos();
    }
  }

  void _toggleTodoCompletion(Todo todo) async {
    await _todoService.toggleTodo(todo.id);
    _fetchTodos();
  }

  void _removeTodo(Todo todo) async {
    await _todoService.removeTodo(todo.id);
    _fetchTodos();
  }
   Future<String?> _showTodoDialog({String? initialDesc}) {
    final TextEditingController _controller =
        TextEditingController(text: initialDesc);
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(initialDesc == null ? 'Add Todo' : 'Edit Todo'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Description'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(_controller.text);
              },
            ),
          ],
        );
      },
    );
  }
  List<Todo> filterTodos(List<Todo> allTodos) {
    final filter = ref.watch(todoFilterProvider);
    final search = ref.watch(todoSearchProvider);

    List<Todo> tempTodos;

    tempTodos = switch (filter) {
      Filter.active => allTodos.where((todo) => !todo.completed).toList(),
      Filter.completed => allTodos.where((todo) => todo.completed).toList(),
      Filter.all => allTodos,
    };

    if (search.isNotEmpty) {
      tempTodos = tempTodos
          .where(
              (todo) => todo.desc.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    return tempTodos;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<TodoListState>(todoListProvider, (previous, next) {
      if (next.status == TodoListStatus.failure) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                'Error',
                textAlign: TextAlign.center,
              ),
              content: Text(
                next.error,
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      }
    });

    final todoListState = ref.watch(todoListProvider);

    switch (todoListState.status) {
      case TodoListStatus.initial:
        return const SizedBox.shrink();

      case TodoListStatus.loading:
        return prevTodosWidget;

      case TodoListStatus.failure when prevTodosWidget is SizedBox:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                todoListState.error,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  ref.read(todoListProvider.notifier).getTodos();
                },
                child: const Text(
                  'Please Retry!',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        );

      case TodoListStatus.failure:
        return prevTodosWidget;

      case TodoListStatus.success:
        final filteredTodos = filterTodos(todoListState.todos);

        prevTodosWidget = ListView.separated(
          itemCount: filteredTodos.length,
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(color: Colors.grey);
          },
          itemBuilder: (BuildContext context, int index) {
            final todo = filteredTodos[index];
            return ProviderScope(
              overrides: [
                todoItemProvider.overrideWithValue(todo),
              ],
              child: const TodoItem(),
            );
          },
        );
        return prevTodosWidget;
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:todo_riverpod_enum/pages/providers/todo_item/todo_item_provider.dart';
// import 'package:todo_riverpod_enum/services/todo_service.dart';

// import '../../models/todo_model.dart';
// import 'todo_item.dart';

// class ShowTodos extends ConsumerStatefulWidget {
//   const ShowTodos({super.key});

//   @override
//   ConsumerState<ShowTodos> createState() => _ShowTodosState();
// }

// class _ShowTodosState extends ConsumerState<ShowTodos> {
//   Widget prevTodosWidget = const SizedBox.shrink();
//   final TodoService _todoService = TodoService();
//   List<Todo> _todos = [];
//   bool _isLoading = true;
//   String _error = '';

//   @override
//   void initState() {
//     super.initState();
//     _fetchTodos();
//   }

//   Future<void> _fetchTodos() async {
//     setState(() {
//       _isLoading = true;
//       _error = '';
//     });
//     try {
//       final todos = await _todoService.getTodos();
//       setState(() {
//         _todos = todos;
//       });
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   List<Todo> filterTodos(List<Todo> allTodos) {
//     // Dummy filter and search implementation
//     // Replace these with actual providers if needed
//     final Filter filter = Filter.all; // Assume a filter value
//     final String search = ''; // Assume a search value

//     List<Todo> tempTodos;

//     tempTodos = switch (filter) {
//       Filter.active => allTodos.where((todo) => !todo.completed).toList(),
//       Filter.completed => allTodos.where((todo) => todo.completed).toList(),
//       Filter.all => allTodos,
//     };

//     if (search.isNotEmpty) {
//       tempTodos = tempTodos
//           .where(
//               (todo) => todo.desc.toLowerCase().contains(search.toLowerCase()))
//           .toList();
//     }

//     return tempTodos;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return prevTodosWidget;
//     }

//     if (_error.isNotEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               _error,
//               style: const TextStyle(fontSize: 20),
//             ),
//             const SizedBox(height: 20),
//             OutlinedButton(
//               onPressed: _fetchTodos,
//               child: const Text(
//                 'Please Retry!',
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     final filteredTodos = filterTodos(_todos);

//     prevTodosWidget = ListView.separated(
//       itemCount: filteredTodos.length,
//       separatorBuilder: (BuildContext context, int index) {
//         return const Divider(color: Colors.grey);
//       },
//       itemBuilder: (BuildContext context, int index) {
//         final todo = filteredTodos[index];
//         return ProviderScope(
//           overrides: [
//             todoItemProvider.overrideWithValue(todo),
//           ],
//           child: const TodoItem(),
//         );
//       },
//     );

//     return prevTodosWidget;
//   }
// }
