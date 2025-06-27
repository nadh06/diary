import 'package:flutter/material.dart';
import '../utils/database_helper.dart';
import '../utils/export_pdf.dart'; // if you're still exporting

class DiaryListScreen extends StatefulWidget {
  const DiaryListScreen({super.key});

  @override
  DiaryListScreenState createState() => DiaryListScreenState();
}

class DiaryListScreenState extends State<DiaryListScreen> {
  List<Map<String, dynamic>> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final data = await DatabaseHelper.instance.getAllEntries();
    setState(() {
      _entries = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Diary Entries'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () {
              exportDiaryToPdf(_entries); // Exports actual entries
            },
          ),
        ],
      ),
      body: _entries.isEmpty
          ? Center(child: Text('No entries yet. Add one!'))
          : ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: ListTile(
                    leading: Text(entry['mood'] ?? '🙂', style: TextStyle(fontSize: 24)),
                    title: Text(entry['title'] ?? 'No Title'),
                    subtitle: Text(entry['date'] ?? ''),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await DatabaseHelper.instance.deleteEntry(entry['id']);
                        _loadEntries(); // Refresh after delete
                      },
                    ),
                    onTap: () {
                      // Optionally, show full content in a dialog or new screen
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(entry['title']),
                          content: Text(entry['content']),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
