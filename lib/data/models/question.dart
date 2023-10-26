
class Question{

  final String questionText;
  String? questionLabel;
  final String type;
  List<String>? options;

  Question({this.questionLabel, required this.questionText, required this.type, this.options});
}