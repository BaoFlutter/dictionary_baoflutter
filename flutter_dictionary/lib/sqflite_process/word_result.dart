
import 'package:flutter/material.dart';
import 'package:flutter_dictionary/pages/dictionary_page.dart';
import 'package:flutter_dictionary/resources/widgets/line_widget.dart';
import 'package:flutter_dictionary/resources/widgets/space_widgets.dart';
import 'package:flutter_dictionary/resources/theme.dart';
import 'package:flutter_dictionary/sqflite_process/word_model.dart';

class WordResult extends StatelessWidget{
  final WordModel? word;

  WordResult({this.word}): assert(word != null);




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  GestureDetector(
        onTap: (){
         Navigator.of(context).push(
           MaterialPageRoute(builder: (context)
           => DictionaryPage(wordModel: word!)
           )
         );
        },
        child: Container(
         height: 40,
          margin: EdgeInsets.only(right: 20, left: 20),
          color: Colors.transparent,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(word!.word!, style: TextStyle(color: AppTheme.darkText,fontSize: 16, fontWeight: FontWeight.w500)),
              ),
              spaceVertical10(),

              horizontal_line(context),
            ],

          ),
        )
    );

  }
}