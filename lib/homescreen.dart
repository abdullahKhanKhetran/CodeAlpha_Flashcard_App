import 'package:flutter/material.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<String> questions = [];
  List<String> answers = [];
  String currentText = "";
  TextEditingController qTC = TextEditingController();
  TextEditingController aTC = TextEditingController();
  List<Widget> flashcards =[Text("No flashcards to show"),];
  void clear(){flashcards.clear();
  flashcards.add(Text("No flashcards to show"));
  setState(() {
    _counter=0;
  });}
  // Widget currentWidget(String ct){
  //   if(Questions.isEmpty && Answers.isEmpty){return Text("No FlashCards to show");}
  //   else{
  //   return SizedBox(
  //     child: Card(
  //       child: Column(
  //         children: [
  //           Text(ct,),
  //           Row(children: [
  //             Align(alignment: Alignment.bottomLeft,child:
  //             ElevatedButton(onPressed: (){setState(() {
  //
  //             });_counter++;}, child: Text("Prev"))),
  //             Align(alignment: Alignment.bottomCenter,child:
  //             ElevatedButton(onPressed: (){_counter++;}, child: Text("Answer"))),
  //             Align( alignment: Alignment.bottomRight,child:
  //             ElevatedButton(onPressed: (){}, child: Text("Next"))),
  //           ],)
  //         ],
  //       ),
  //     ),
  // );
  //     }}
  void addFlashcard(String q,a){
    questions.add(q);
    answers.add(a);
    flashcards.add(
      SizedBox(
        height: 300,width: 300,
        child: Card(
          child: Padding(padding: EdgeInsets.fromLTRB(5, 15, 5, 5) ,child:Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(q,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Align(alignment: Alignment.bottomLeft,child: 
                ElevatedButton(onPressed: (){if(_counter!=1){setState(() {
                  _counter-=2;
                });}}, child: Text("Prev"))),
                Align(alignment: Alignment.bottomCenter,child:
                ElevatedButton(onPressed: (){setState(() {
                  _counter++;
                });}, child: Text("Answer"))),
                Align( alignment: Alignment.bottomRight,child: 
                ElevatedButton(onPressed: (){
                  try{if(_counter+2>(flashcards.length-1)){
                    throw Exception("This was the last flashcard");
                  }
                  else{
                    setState(() {
                  _counter+=2;});
                  }
                  }
                  catch(e){showDialog(context: context, builder: (BuildContext context){
                    return AlertDialog(title: Text("Error"),
                      content: Text(e.toString()),
                      actions: [
                        TextButton(
                            onPressed: ()=> Navigator.of(context).pop(),
                            child: Text("ok")
                        )
                      ],
                    );
                  });
                  }
                  }, child: Text("Next"))),
              ],)
            ],
          ),
        ),)
      )
    );
    flashcards.add(
        SizedBox(height: 300,width: 300,
          child: Card(
            child: Padding(padding: EdgeInsets.fromLTRB(5,15,5,5) ,
              child : Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(a,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Align(alignment: Alignment.bottomLeft,child:
                  ElevatedButton(onPressed: (){if(_counter!=0&&_counter!=2){setState(() {
                    _counter-=3;
                  });}}, child: Text("Prev"))),
                  Align(alignment: Alignment.bottomCenter,child:
                  ElevatedButton(onPressed: (){setState(() {
                    _counter--;
                  });}, child: Text("Question"))),
                  Align( alignment: Alignment.bottomRight,child:
                  ElevatedButton(onPressed: (){setState(() {
                    try{if(_counter+1>(flashcards.length-1)){
                      throw Exception("This was the last flashcard");
                    }
                    else{
                      setState(() {
                        _counter+=1;});
                    }
                    }
                    catch(e){showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text(e.toString()),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          ),
                        ],
                      );
                    });
                    }
                  });}, child: Text("Next"))),
                ],)
              ],
            ),
          ),
          )
        )
    );
    if(_counter==0){setState(() {
      _counter++;
    });}
    }
  TextField dialogTextField(String hint,TextEditingController tec){
    return TextField(
      controller: tec,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  width: 1
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  width: 1
              )
          ),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                  width: 1
              )
          ),
          border: InputBorder.none,
          hintText: hint
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: ListView(children: [
        ListTile(
          onTap: (){
            Navigator.push(context, route)
          } ,
          leading: Icon(Icons.line_weight_sharp),
          title: Text("Edit cards"),
          subtitle: Text("edit or delete your cards"),
        )],
    ),),
      appBar: AppBar(
        actions: [IconButton(onPressed:clear,icon: Icon(Icons.clear))],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
         child:  Align(child: flashcards[_counter])
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(context: context, builder: (BuildContext context)
          {
            return Dialog(
              child: Container(
                padding: EdgeInsets.all(8),
                  height: 400,width: 50,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                        color : Colors.white,
                      ),
                    child:
                    Column(mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         dialogTextField("Question",qTC),
                         SizedBox(height: 20,),
                         dialogTextField("Answer",aTC),
                         SizedBox(height: 20,),
                         TextButton(onPressed: (){
                           addFlashcard(qTC.text.trim(),aTC.text.trim());
                           qTC.clear();aTC.clear();Navigator.of(context).pop();}, child: Text("Submit"))
                        ],
                    ),
              )
          );
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
class manageCardsState extends State<MyHomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Manage Cards",),),
      body: List,
    );
  }
}