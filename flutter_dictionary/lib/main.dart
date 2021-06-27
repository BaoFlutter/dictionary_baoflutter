import 'package:flutter/material.dart';
import 'package:flutter_dictionary/resources/strings.dart';
import 'package:flutter_dictionary/resources/widgets/space_widgets.dart';
import 'package:flutter_dictionary/sqflite_process/outside_db.dart';


import 'pages/dictionary_page.dart';
import 'resources/utils/check_first_install.dart';
import 'resources/theme.dart';
import 'resources/utils/dismiss_keyboard.dart';
import 'sqflite_process/word_model.dart';
import 'sqflite_process/word_result.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  final db = OutsideDatabase();
  Future<List<WordModel>>? searchResultsFuture;
  int hintWordsLength = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dictionary"),
          centerTitle: true,
        ),


        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,

            child: Stack(
              children: <Widget>[
                listItems(),
                (searchResultsFuture != null && searchResultsFuture != 0) ?
                Container(
                  margin: EdgeInsets.only(top: 120, right: 20, left: 20),
                  //padding: EdgeInsets.only(bottom: 10),
                  height: hintWordsLength * 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey.withOpacity(0.4),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: buildSearchResult(),
                ) : Container(),
                //createDatabase(),
              ],
            ),

          ),

        )

    );
  }

  // list items
  listItems()
  {
    return ListView(
      children: [
        _searchWordItem(),
        spaceVertical30(),
        Container(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: AppTheme.grey.withOpacity(0.4),
                      offset: Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Image.asset("assets/images/dictionary.png")
            ),
          ),
        )

      ],
    );
  }

  // search word
  _searchWordItem() {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 5),
            //margin: EdgeInsets.only(left: 20, right: 20),
            child: TextFormField(
              textAlign: TextAlign.start,
              controller: searchController,
              decoration: InputDecoration(
                hintText: hint_text,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),

                prefixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>
                            DictionaryPage(wordModel: WordModel(word_id: null,
                                word: searchController.text,
                                pronounce: null,
                                meaning: null),)
                        )
                    );
                  },
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: clearSearch,
                ),


              ),
              onChanged: handlesearch,
              onFieldSubmitted: handleSearchOnSubmitted,
              // onFieldSubmitted: handlesearch,

            ),
          ),


        ],
      ),
    );
  }

  handlesearch(String searchWord) async
  {
    Future<List<WordModel>> words = db.searchEnglishResults(searchWord);
    List<WordModel> list = await words;

    setState(() {
      if (list.length > 0) {
        searchResultsFuture = words;
        hintWordsLength = list.length;
      }

      if (searchController.text.isEmpty) {
        searchResultsFuture = null;
        hintWordsLength = 0;
      }
    });
  }

  //
  handleSearchOnSubmitted(String searchWord) async
  {
    KeyBoard().off(context);
    Future<List<WordModel>> words = db.searchEnglishResults(searchWord);
    List<WordModel> list = await words;

    setState(() {
      if (list.length > 0) {
        searchResultsFuture = words;
        hintWordsLength = list.length;
      }
      hintWordsLength = 0;
      searchResultsFuture = null;
    });
    searchController.clear();

    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) =>
            DictionaryPage(wordModel: WordModel(word_id: null,
                word: searchWord, pronounce: null, meaning: null),)
        )
    );
  }

  ////
  buildSearchResult() {
    return FutureBuilder<List<WordModel>>(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        List<WordResult> searchWords = [];
        snapshot?.data?.forEach(
                (word) {
              WordResult searchResult = WordResult(word: word);
              searchWords.add(searchResult);
            }
        );

        return ListView(
          children:
          searchWords,
        );
      },
    );
  }

  clearSearch() {
    searchController.clear();
    setState(() {
      searchResultsFuture = null;
      hintWordsLength = 0;
    });
    KeyBoard().off(context);
  }
  // show loading request



}

