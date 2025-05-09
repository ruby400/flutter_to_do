import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> todoList = [];
  List<bool> isCheckedList = [];

  void _showAddTodoSheet() {
    TextEditingController controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '새 메모 추가',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: controller,
                decoration: InputDecoration(hintText: '할 일을 입력하세요'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  String text = controller.text.trim();
                  if (text.isNotEmpty) {
                    setState(() {
                      todoList.add(text);
                      isCheckedList.add(false); // 동기화 유지
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text('추가'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6A5ACD),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditTodoSheet(int index) {
    if (index < 0 || index >= todoList.length) return;

    TextEditingController controller = TextEditingController(
      text: todoList[index],
    );

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '메모 수정',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: controller,
                decoration: InputDecoration(hintText: '수정할 내용을 입력하세요'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  String newText = controller.text.trim();
                  if (newText.isNotEmpty) {
                    setState(() {
                      todoList[index] = newText;
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text('저장'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6A5ACD),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteTodo(int index) {
    if (index < 0 || index >= todoList.length) return;

    setState(() {
      todoList.removeAt(index);
      if (index < isCheckedList.length) {
        isCheckedList.removeAt(index);
      }
    });
  }

  void _toggleCheck(int index, bool? value) {
    if (index < 0 || index >= isCheckedList.length) return;

    setState(() {
      isCheckedList[index] = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To Do list'), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Divider(color: Colors.grey, thickness: 1),
          SizedBox(height: 10),

          for (int i = 0; i < todoList.length && i < isCheckedList.length; i++)
            Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF6A5ACD),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: isCheckedList[i],
                        onChanged: (value) => _toggleCheck(i, value),
                        activeColor: Colors.white,
                        checkColor: Color(0xFF6A5ACD),
                      ),
                      Text(
                        todoList[i],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration:
                              isCheckedList[i]
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => _showEditTodoSheet(i),
                        child: Text(
                          '수정',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _deleteTodo(i),
                        child: Text(
                          '삭제',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoSheet,
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF6A5ACD),
        shape: CircleBorder(),
        tooltip: '새 메모 추가',
      ),
    );
  }
}
