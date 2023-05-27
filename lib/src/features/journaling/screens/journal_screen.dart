import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noorbot_app/src/constants/text_strings.dart';
import 'package:noorbot_app/src/features/journaling/controllers/journals_controller.dart';

import '../../../constants/colors.dart';
import '../../../repository/authentication_repository/authentication_repository.dart';
import '../models/journal_model.dart';


class TextEditorScreen extends StatefulWidget {
  const TextEditorScreen(
      {super.key, required this.createdAt, required this.editEnabled});

  final Timestamp createdAt;
  final bool editEnabled;

  @override
  State createState() => _TextEditorScreenState();
}

class _TextEditorScreenState extends State<TextEditorScreen> {
  late TextEditingController _titleEditingController;
  late TextEditingController _textEditingController;
  late JournalsController _journalsController;
  final _authRepo = AuthenticationRepository.instance;
  late JournalModel _journal;
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    _titleEditingController = TextEditingController();
    _textEditingController = TextEditingController();
    _journalsController = Get.put(JournalsController());
    isLoading = true;
    _journalsController.todayJournalExists().then((result) {
      if (result) {
        _journalsController
            .getUserSpecificJournalData(widget.createdAt.toDate())
            .then((result) {
          _journal = result;
          setState(() {
            isLoading = false;
            _titleEditingController.text = result.title;
            _textEditingController.text = result.text;
          });
        });
      } else {
        _journal = JournalModel(
            user: _authRepo.getUserEmail,
            text: "",
            title: "Today's Journal",
            createdAt: Timestamp.now());
        _journalsController.createJournal(_journal);
        setState(() {
          isLoading = false;
          _textEditingController.text = _journal.text;
          _titleEditingController.text = _journal.title;
        });
      }
    });
    _journal = JournalModel(
        user: "",
        text: "",
        title: "Loading Journal...",
        createdAt: Timestamp.now());
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  _saveText() async {
    // Perform save operation here
    String text = _textEditingController.text;
    String title = _titleEditingController.text;
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(tSavingJournal),
          duration: Duration(seconds: 2),
        ),
      );
      title = _journal.title;
    }

    try {
      await _journalsController.updateRecord(text, title);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error saving, check your internet connection"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(tJournalAlertTitle),
          content: const Text(tJournalAlertConfirm),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                await _journalsController.deleteTodaysJournal();
                Get.back();
              },
              child: const Text(tJournalAlertYes),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text(tJournalAlertNo),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return WillPopScope(
        onWillPop: () async {
          // Call your function here
          if (widget.editEnabled) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Please Wait, Saving Journal..."),
                duration: Duration(seconds: 1),
              ),
            );

            await _saveText();
          }

          // Return true to allow the back navigation or false to prevent it
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: TextField(
                enabled: widget.editEnabled,
                controller: _titleEditingController,
                maxLines: 1,
                decoration: const InputDecoration(
                    border: InputBorder.none, focusedBorder: InputBorder.none),
                style: Theme.of(context).textTheme.headlineMedium),
            actions: [
              Visibility(
                visible: widget.editEnabled,
                child: IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _saveText,
                ),
              )
            ],
          ),
          body: Container(
              color: isDark ? tSecondaryColor : tCardBgColor,
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(children: [
                    Visibility(
                        visible: !isLoading,
                        child: TextField(
                          enabled: widget.editEnabled,
                          controller: _textEditingController,
                          maxLines: null,
                          decoration: const InputDecoration(
                              hintText: 'Enter your text...',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none),
                        )),
                    Visibility(
                        visible: isLoading, child: const CircularProgressIndicator())
                  ]))),
          floatingActionButton: Visibility(
              visible: widget.editEnabled,
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 210, 0, 0),
                onPressed: _showConfirmationDialog,
                child: const Icon(Icons.delete),
              )),
        ));
  }
}
