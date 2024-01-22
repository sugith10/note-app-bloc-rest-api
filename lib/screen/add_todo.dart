import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_note/util/msg.dart';

class AddToDoScrn extends StatefulWidget {
  final Map? todo;
  const AddToDoScrn({super.key, this.todo});

  @override
  State<AddToDoScrn> createState() => _AddToDoScrnState();
}

class _AddToDoScrnState extends State<AddToDoScrn> {
  TextEditingController titleCntrl = TextEditingController();
  TextEditingController contentCntrl = TextEditingController();
  bool isEdit = false;
  


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.todo != null) {
      isEdit = true;
      titleCntrl.text = widget.todo!['title'];
      contentCntrl.text = widget.todo!['description'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(isEdit ? 'Edit Todo' : 'Add ToDo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          TextField(
            controller: titleCntrl,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: contentCntrl,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Content',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              print(isEdit);
              isEdit ? updateTodo(widget.todo!['_id']) : submitData(context);
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(30, 50),
            ),
            child: Text(isEdit ? 'Update' : 'Submit'),
          )
        ],
      ),
    );
  }

  Future<void> submitData(BuildContext context) async {
    final title = titleCntrl.text;
    final content = contentCntrl.text;
    final body = {
      "title": title,
      "description": content,
      "is_completed": false
    };

    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      Navigator.pop(context);
      print('Creation Success');
      Message().showSuccessMessage('Creation Success', context);
    } else {
      print('Creation Failed');
      Message().showSuccessMessage('Creation Failed', context);
      print(response.body);
    }

    
  }

  Future<void> updateTodo(String id) async {
    final title = titleCntrl.text;
    final content = contentCntrl.text;
    final body = {
      "title": title,
      "description": content,
      "is_completed": false
    };

    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

   if (response.statusCode == 200) {
      Navigator.pop(context);
      print('Update Success');
      Message().showSuccessMessage('Update Success', context);
    } else {
      print('Update Failed');
      Message().showSuccessMessage('Update Failed', context);
      print(response.body);
    }
  }
  
}
