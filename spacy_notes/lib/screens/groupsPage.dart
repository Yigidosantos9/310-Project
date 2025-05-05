import 'package:flutter/material.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/screens/coursesPage.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  List<String> groups = [];

  void _addGroup() {
    int nextNumber = groups.length + 1;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Add New Group"),
            content: const Text(
              "Do you want to set a custom name for this group?",
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    groups.add("Group $nextNumber");
                  });
                  Navigator.pop(context);
                },
                child: const Text("No", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _askCustomName(nextNumber);
                },
                child: const Text("Yes", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  void _askCustomName(int groupNumber) {
    String customName = '';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Custom Group Name"),
            content: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "Group name",
                hintText: "e.g. My Study Team",
              ),
              onChanged: (value) {
                customName = value.trim();
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    groups.add(
                      customName.isEmpty ? "Group $groupNumber" : customName,
                    );
                  });
                  Navigator.pop(context);
                },
                child: const Text("Add", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: 'GROUPS',
        onPressed: () => Navigator.pushReplacementNamed(context, '/profile'),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: groups.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildTile("You", Colors.orange, Colors.pink[100]!, index);
          } else {
            return _buildTile(
              groups[index - 1],
              Colors.purple,
              Colors.purple[200]!,
              index,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: _addGroup,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTile(String name, Color tileColor, Color boxColor, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, '/courses');
        },
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: boxColor,
            border: Border.all(color: Colors.black),
            boxShadow: const [
              BoxShadow(color: Colors.black38, offset: Offset(2, 2)),
            ],
          ),
        ),
        title: CustomText(
          text: name,
          fontWeight: FontWeight.bold,
          color: AppColors.unselectedTaskColor,
        ),
        trailing:
            index == 0
                ? null
                : IconButton(
                  icon: const Icon(Icons.delete, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      groups.removeAt(index - 1);
                    });
                  },
                ),
      ),
    );
  }
}
