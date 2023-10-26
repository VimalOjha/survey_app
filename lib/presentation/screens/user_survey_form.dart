import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:survey_app/data/models/question.dart';
import 'package:survey_app/presentation/widgets/custom_scorll_physics.dart';

class SurveyFormScreen extends StatefulWidget {
  final List<Question> questions;
  final String title;
  final String formId;
  const SurveyFormScreen({super.key, required this.formId, required this.title, required this.questions});

  @override
  _SurveyFormScreenState createState() => _SurveyFormScreenState();
}

class _SurveyFormScreenState extends State<SurveyFormScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;
  Map<String,dynamic> dynamicUserInputMap = {};
  List<String> selectedMultiOptions = [];
  String selectedSingleChoice ='';
  var textAnswerEditController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    textAnswerEditController.dispose();
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool isValid(){
    if (widget.questions[currentIndex].type == 'text')
    {
      if(textAnswerEditController.text.trim().isEmpty){
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Enter Your Answer',  style: TextStyle(
              color: Theme.of(context).colorScheme.error
          ),),
        ));
        return false;
      }
    }

    if (widget.questions[currentIndex].type == 'radio'){
      if(selectedSingleChoice.isEmpty){
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
          content: Text('Please select one of the given options!', style: TextStyle(
              color: Theme.of(context).colorScheme.error
          ),),
        ));
        return false;
      }
    }

    if (widget.questions[currentIndex].type == 'multiselect'){
      if(selectedMultiOptions.isEmpty){
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(  SnackBar(
          content: Text('Please select one of the given options!', style: TextStyle(
              color: Theme.of(context).colorScheme.error
          ),),
        ));
        return false;
      }
    }
    return true;
  }
  void setDefaultValues(int index){
    if (dynamicUserInputMap.containsKey('text_answer_$index')) {
      textAnswerEditController =
      dynamicUserInputMap['text_answer_$index'];
    } else {
      textAnswerEditController = TextEditingController();
    }
    if (dynamicUserInputMap
        .containsKey('radio_answer_$index')) {
      selectedSingleChoice =
      dynamicUserInputMap['radio_answer_$index'];
    } else {
      selectedSingleChoice = '';
    }
    if (dynamicUserInputMap
        .containsKey('multichoice_answer_$index')) {
      setState(() {
        selectedMultiOptions = dynamicUserInputMap['multichoice_answer_$index'];
      });
    } else {
      selectedMultiOptions = [];
    }
  }

  void saveUserInputs() async {
    if (widget.questions[currentIndex].type == 'text') {
      dynamicUserInputMap['text_answer_$currentIndex'] = textAnswerEditController;
    }

    if (widget.questions[currentIndex].type == 'radio') {
      dynamicUserInputMap['radio_answer_$currentIndex'] = selectedSingleChoice;
    }

    if (widget.questions[currentIndex].type == 'multiselect') {
      dynamicUserInputMap['multichoice_answer_$currentIndex'] = selectedMultiOptions;
    }
  }

  void _submitForm() async{

    Map<String, dynamic> formData = {
      'title': widget.title,
      'createdAt': Timestamp.now(),

      'questions': widget.questions
          .asMap()
          .entries
          .map((entry) {
        int index = entry.key;
        Question question = entry.value;
        return {
          'question': question.questionText,
          'type': question.type,
          'label': question.questionLabel,
          'options': question.options,
          'selected_options': question.type == 'radio' ? dynamicUserInputMap['radio_answer_$index'] :
          question.type == 'multiselect' ? dynamicUserInputMap['multichoice_answer_$index'] : null,
          'answer': question.type == 'text' ? (dynamicUserInputMap['text_answer_$index'] as TextEditingController).text : null,
        };
      }).toList()
    };

    final currentUser  = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('submitted_forms')
        .doc(widget.formId)
        .set(formData);
    print('Your Response Submitted Successfully!!');

    if(!context.mounted) return;
    Navigator.of(context).pop(widget.formId);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: widget.questions.length,
              controller: _pageController,
              physics: const CustomPageScrollPhysics(parent: AlwaysScrollableScrollPhysics(),allowScroll: false),
              onPageChanged: (int index) {
                if (index > currentIndex) {
                  if (!isValid()) {
                    _pageController.animateToPage(index - 1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease);
                  } else {
                    saveUserInputs();
                    setDefaultValues(index);
                    setState(() {
                      currentIndex = index;
                    });
                  }
                } else{
                  setDefaultValues(index);
                  setState(() {
                    currentIndex = index;
                  });
                }
              },
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.all(30),
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      if (widget.questions[index].type == 'text')
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(widget.questions[index].questionText,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 24),
                                textAlign: TextAlign.center),
                            const SizedBox(height: 30),
                            TextField(
                              decoration: InputDecoration(
                                  labelText:
                                  'Write your answer here..',
                                labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.onBackground,
                                  fontWeight: FontWeight.normal
                                )
                              ),
                              style:Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                              focusNode: _focusNode,
                              controller: textAnswerEditController,
                            ),
                          ],
                        ),
                      if (widget.questions[index].type == 'radio')
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(widget.questions[index].questionText,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 24),
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 30),
                              Column(
                                children: widget.questions[index].options!
                                    .map((option) {
                                  return RadioListTile(
                                    title: Text(option),
                                    value: option,
                                    groupValue: selectedSingleChoice,
                                    // Add logic for radio questions,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedSingleChoice = value!;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ]),
                      if (widget.questions[index].type == 'multiselect')
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(widget.questions[index].questionText,
                                style:Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.onBackground,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 24
                                ),
                                textAlign: TextAlign.center),
                            const SizedBox(height: 30),
                            Column(
                              children:
                                  widget.questions[index].options!.map((option) {
                                return CheckboxListTile(
                                  title: Text(option),
                                  value: selectedMultiOptions.contains(option),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value != null && value) {
                                        selectedMultiOptions.add(option);
                                      } else {
                                        selectedMultiOptions.remove(option);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            // Add similar logic for other question types
                          ],
                        ),
                    ]));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  ElevatedButton(
                    onPressed: currentIndex <= 0 ? null : () {
                      _focusNode.unfocus();
                      setState(() {
                        currentIndex --;
                      });
                      _pageController.animateToPage(currentIndex, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                    },
                    child:  Text('Previous',
                      style:Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.normal,
                      ),),
                  ),
                const Spacer(),
                Text('Question ${currentIndex + 1} of ${widget.questions.length}',
                  style:Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.normal,
                  ),),
                const Spacer(),
                if (currentIndex <= widget.questions.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      _focusNode.unfocus();
                      if(currentIndex == widget.questions.length -1){
                        if(!isValid()) {
                          return;
                        }
                        saveUserInputs();
                        _submitForm();
                      }
                      else {
                        if(!isValid()) {
                          return;
                        }
                        saveUserInputs();
                        setState(() {
                          currentIndex ++;
                        });
                        _pageController.animateToPage(currentIndex, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                      }
                    },
                    child: Text(currentIndex < widget.questions.length - 1 ? 'Next' : 'Submit',
                      style:Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.normal,
                      ),),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


