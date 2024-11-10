import 'package:flutter/material.dart';
import 'package:todolist_app/persistence/db/sql_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List <Map<String,dynamic>>  _tarefas=[]; 
  bool _isLoading=true;

  final TextEditingController _tittleController=TextEditingController();
  final TextEditingController _description_Controlller=TextEditingController();

  void _obterTarefas() async {
      final data=await SqlHelper.getItems();

      setState(() {
        _tarefas=data;
        _isLoading=false;
      });
  }

  void initState(){
    super.initState();
    _obterTarefas();
    print("o bd atualmente tem ${_tarefas.length} items!");
  }

   Future<void> _addItem()  async{
      await SqlHelper.createItem(_tittleController.text, _description_Controlller.text);
      _obterTarefas();
   }
   Future<void> _updateItem(int id)  async{
      await SqlHelper.updateItem(id, _tittleController.text, _description_Controlller.text);
      _obterTarefas();
   }

  void _showForm(int? id) async{
      if(id!=null){
          final tarefaExistente=_tarefas.firstWhere((element)=>element['id']==id);
          _tittleController.text=tarefaExistente['title'];
          _description_Controlller.text=tarefaExistente['description'];

      }

      showModalBottomSheet(context: context, 
      elevation: 5,
      isScrollControlled: true,
      builder: (_)=>
        Container(
          padding: EdgeInsets.only(top: 15,left: 15,right: 15 ,bottom: 15),
         child: 
         Column(
          mainAxisSize: MainAxisSize.min,
          
         crossAxisAlignment: CrossAxisAlignment.start ,
         mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: _tittleController,
                decoration: const InputDecoration(hintText: 'Titulo'),
              ),
              SizedBox(height: 10,)
              ,
               TextField(
                controller: _description_Controlller,
                decoration: const InputDecoration(hintText: 'Descricao'),
              ),
              SizedBox(height: 10,),

              ElevatedButton(onPressed:() async{
                  if(id==null){
                     await _addItem();
                  }
                  if(id!=null){
                     await _updateItem(id);
                  }

                  _tittleController.text="";
                  _description_Controlller.text="";

                  Navigator.of(context).pop();
              }, child: Text(id==null ? "Criar nova":"Atualizar" ,style: TextStyle())

                      )
            ],
         ),
        )
      );
  }



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
    
        title: Text('Agenda'),
      ),
      body: Center(
   
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showForm(null);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  
 
}
