import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todolist/data.dart';
import 'package:todolist/main.dart';

class EditTextScreen extends StatefulWidget {
  EditTextScreen({super.key, required this.tastDataEdit});
  final Task tastDataEdit;

  @override
  State<EditTextScreen> createState() => _EditTextScreenState();
}

class _EditTextScreenState extends State<EditTextScreen> {
  late TextEditingController textEditingController =
      TextEditingController(text: widget.tastDataEdit.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('text edit'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        onPressed: () {
          widget.tastDataEdit.name = textEditingController.text;
          widget.tastDataEdit.priority = widget.tastDataEdit.priority;
          if (widget.tastDataEdit.isInBox) {
            widget.tastDataEdit.save();
          } else {
            final box = Hive.box<Task>(taskNameBox);
            box.add(widget.tastDataEdit);
          }
          Navigator.of(context).pop();
        },
        label: const Text('save changes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  flex: 1,
                  child: BoxEdit(
                    labeC: 'High',
                    colorC: Colors.orange,
                    isSelected: widget.tastDataEdit.priority == Priority.high,
                    onTap: () {
                      setState(() {
                        widget.tastDataEdit.priority = Priority.high;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  flex: 1,
                  child: BoxEdit(
                    labeC: 'Normal',
                    colorC: Colors.blueAccent,
                    isSelected: widget.tastDataEdit.priority == Priority.normal,
                    onTap: () {
                      setState(() {
                        widget.tastDataEdit.priority = Priority.normal;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                  flex: 1,
                  child: BoxEdit(
                    labeC: 'low',
                    colorC: Colors.green,
                    isSelected: widget.tastDataEdit.priority == Priority.low,
                    onTap: () {
                      setState(() {
                        widget.tastDataEdit.priority = Priority.low;
                      });
                    },
                  ),
                ),
              ],
            ),
            TextField(
              controller: textEditingController,
              decoration: const InputDecoration(
                label: Text('Add a task for today...'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoxEdit extends StatelessWidget {
  const BoxEdit({
    super.key,
    required this.labeC,
    required this.colorC,
    required this.isSelected,
    required this.onTap,
  });
  final String labeC;
  final Color colorC;
  final bool isSelected;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(labeC),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              child: Center(
                child: CheckBoxEdit(value: isSelected, colorC: colorC),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckBoxEdit extends StatelessWidget {
  final bool value;
  final Color colorC;

  const CheckBoxEdit({
    super.key,
    required this.value,
    required this.colorC,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: colorC,
        ),
        child: value
            ? const Icon(
                CupertinoIcons.check_mark,
                size: 12,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}
