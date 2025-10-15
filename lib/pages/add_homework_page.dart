import 'package:flutter/material.dart';
import '../models/homework.dart';

class AddHomeworkPage extends StatefulWidget {
  const AddHomeworkPage({super.key});

  @override
  State<AddHomeworkPage> createState() => _AddHomeworkPageState();
}

class _AddHomeworkPageState extends State<AddHomeworkPage> {
  final _subjectController = TextEditingController();
  final _titleController = TextEditingController();
  DateTime? _selectedDate;

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveHomework() {
    if (_subjectController.text.isEmpty ||
        _titleController.text.isEmpty ||
        _selectedDate == null) return;

    final hw = Homework(
      subject: _subjectController.text,
      title: _titleController.text,
      deadline: _selectedDate!,
    );
    Navigator.pop(context, hw);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add new Homework')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(_selectedDate == null
                      ? 'No date chosen yet'
                      : 'Due: ${_selectedDate!.toLocal().toString().split(' ')[0]}'),
                ),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Pick date'),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveHomework,
              child: const Text('Save '),
            )
          ],
        ),
      ),
    );
  }
}
