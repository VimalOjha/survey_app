
import 'package:json_annotation/json_annotation.dart';
import 'package:survey_app/configs/utilities/constants/enums/questions_enum.dart';
part 'question.g.dart';

@JsonSerializable(explicitToJson: true)
class Question{
  @JsonKey(name: 'question')
  final String questionText;
  @JsonKey(name: 'label')
  String? questionLabel;
  final String type;
  List<String>? options;

  Question({this.questionLabel, required this.questionText, required this.type, this.options});

  bool isTypeText(){
    return type == Questions.text.name;
  }

  bool isTypeRadio(){
    return type == Questions.radio.name;
  }

  bool isTypeMultiSelect(){
    return type == Questions.multiselect.name;
  }

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  /*factory Question.fromJson(Map<String,dynamic> questionData){
    return Question(
      questionText: questionData['question'],
      type: questionData['type'],
      questionLabel: questionData['label'],
      options: questionData['options'] == null
          ? null
          : List<String>.from(questionData['options']),
    );
  }
*/
}