import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static int _counter = 0;
  static List<String> questions = [];
  static List<String> answers = [];
  static String currentText = "";
  TextEditingController qTC = TextEditingController();
  TextEditingController aTC = TextEditingController();
  bool noFlashCards = true;
  bool showAnswer = true;
  static bool isQuestion = true;
  Color textcolor = Colors.blue;
  void clear() {
    questions.clear();
    answers.clear();
    setState(() {
      noFlashCards = true;
      _counter = 0;
      isQuestion = true;
      currentText = "";
    });
  }

  void addFlashcard(String q, String a) {
    questions.add(q);
    answers.add(a);
    setState(() {
      noFlashCards = false;
      _counter = 0;
      isQuestion = true;
      currentText = questions[_counter];
    });
  }

  void nextCard() {
    setState(() {
      if (_counter + 1 < questions.length) {
        _counter++;
        isQuestion = true;
        currentText = questions[_counter];
        textcolor=Colors.blue;
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('End'),
            content: Text('This was the last flashcard.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  void prevCard() {
    setState(() {
      if (_counter > 0) {
        _counter--;
        isQuestion = true;
        currentText = questions[_counter];
        textcolor=Colors.blue;
      }
    });
  }

  void toggleQuestionAnswer() {
    setState(() {
      if (isQuestion) {
        currentText = answers[_counter];
        isQuestion = false;
        textcolor = Colors.green;
      } else {
        currentText = questions[_counter];
        isQuestion = true;
        textcolor = Colors.blue;
      }
    });
  }

  TextField dialogTextField(String hint, TextEditingController tec) {
    return TextField(
      controller: tec,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(width: 1),
        ),
        border: InputBorder.none,
        hintText: hint,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              onTap: () async {
                await Navigator.push(
                  context,
                   MaterialPageRoute(builder: (context) => ManageCardsScreen()),
                );
                setState(() {});
              },
              leading: Icon(Icons.line_weight_sharp),
              title: Text("Edit cards"),
              subtitle: Text("edit or delete your cards"),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              (noFlashCards)
                  ? null
                  : showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            height: 200,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Are you sure you want to clear all cards?",
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        clear();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Clear"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
            },
            icon: const Icon(Icons.clear_all),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue,Colors.purple]),),
        child: Center(
          child: noFlashCards
              ? Text("No Flashcards to show")
              : SizedBox(
                  height: 300,
                  width: 300,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (questions.length == 1) {
                                  noFlashCards = true;
                                }
                                questions.removeAt(_counter);
                                answers.removeAt(_counter);
                                _counter--;
                              });
                            },
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                          ),
                          Text(
                            currentText,
                            style: TextStyle(fontSize: 20, color: textcolor),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: ElevatedButton(
                                  onPressed: (_counter == 0) ? null : prevCard,
                                  child: Text("Prev"),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: ElevatedButton(
                                  onPressed: toggleQuestionAnswer,
                                  child: Text(
                                    isQuestion ? "Answer" : "Question",
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  onPressed: (_counter == questions.length - 1)
                                      ? null
                                      : nextCard,
                                  child: Text("Next"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Container(
                  padding: EdgeInsets.all(8),
                  height: 400,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      dialogTextField("Question", qTC),
                      SizedBox(height: 20),
                      dialogTextField("Answer", aTC),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          addFlashcard(qTC.text.trim(), aTC.text.trim());
                          qTC.clear();
                          aTC.clear();
                          Navigator.of(context).pop();
                        },
                        child: Text("Submit"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        tooltip: 'Add a flashcard',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ManageCardsScreen extends StatefulWidget {
  const ManageCardsScreen({super.key});

  @override
  ManageCardsState createState() => ManageCardsState();
}

class ManageCardsState extends State<ManageCardsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Cards")),
      body: ListView.builder(
        itemCount: MyHomePageState.questions.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: IconButton(
              onPressed: () {
                // Create fresh controllers for this specific index
                TextEditingController qFC = TextEditingController(
                  text: MyHomePageState.questions[index],
                );
                TextEditingController aFC = TextEditingController(
                  text: MyHomePageState.answers[index],
                );

                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      height: 220,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: qFC,
                            decoration: InputDecoration(
                              labelText: "Question",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: aFC,
                            decoration: InputDecoration(
                              labelText: "Answer",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                MyHomePageState.questions[index] = qFC.text.trim();
                                MyHomePageState.answers[index] = aFC.text.trim();

                                // update the current text if viewing this card
                                if (MyHomePageState._counter == index) {
                                  MyHomePageState.currentText =
                                  MyHomePageState.isQuestion
                                      ? MyHomePageState.questions[index]
                                      : MyHomePageState.answers[index];
                                }
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text("Save"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              icon: Icon(Icons.edit),
            ),
            title: Text(MyHomePageState.questions[index]),
          );
        },
      ),
    );
  }
}
