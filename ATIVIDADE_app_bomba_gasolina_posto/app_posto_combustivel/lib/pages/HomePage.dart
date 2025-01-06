

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  int _counter = 0;

  double calculo=-1;
  String orientacao="";
  bool deveMostrarOsResultados=false;
  

  final TextEditingController _textEditeControllerGasolina = TextEditingController();
  final TextEditingController _textEditeControllerAlcool = TextEditingController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Gasolina X Alcool'),
        centerTitle: true,
      ),
      body:Column(
        children: [
          SizedBox(height: 30),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text(
                  'Gasolina X Alcool:',
                ),
              
            ],
           ),

           Row(
            mainAxisAlignment: MainAxisAlignment.center,
               children: [
                  Image.asset('assets/imagens/gasolina.png',width: 300,height: 300,)
               ],
           ),

           TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
              label: Text('Valor da gasolina'),
              labelStyle: TextStyle(fontSize: 20,color: Colors.black)
          ),
          controller: _textEditeControllerGasolina,
          onChanged: (String value){
            print(" valor da gasolina : ${_textEditeControllerGasolina.text}");
          },
          onSubmitted: (String valor) {
                // print('Valor' + _textEditeControllerGasolina.text);
          },
          ),
          SizedBox(height: 30,)
          ,
           TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
              label: Text('Valor do Alcool'),
              labelStyle: TextStyle(fontSize: 20,color: Colors.black)
          ),
          controller: _textEditeControllerAlcool,
          onChanged: (String value){
            print(" valor da gasolina : ${_textEditeControllerAlcool.text}");
          },
          onSubmitted: (String valor) {
                // print('Valor' + _textEditeControllerGasolina.text);
          },
          ),
          SizedBox(
            height: 50,
          ),

          Center(
            child: ElevatedButton(onPressed: (){
                   calculo=double.parse(_textEditeControllerAlcool.text)/double.parse(_textEditeControllerGasolina.text) * 100;
                   
                   setState(() {
                      calculo=calculo;
                      deveMostrarOsResultados=true;
                   });    
              
            }, 
            child: Text("Calcular")),
          )
         ,SizedBox(
            height: 50,
          ),
          Center(
            // child: Text(  (deveMostrarOsResultados==true && calculo>=0) ? "Resultado: ${calculo}":""),
            child: Visibility(
                visible: (deveMostrarOsResultados==true),
                child: Text("Resultado: ${calculo}"),
                replacement: Text(""),
              ),
            
          )
          ,
          Center(
            child: Text(" ${  deveMostrarOsResultados==true ?    (  calculo>=70 ?"Orientacao: Abasteça com Alcool":"Orientacao: Abasteça com Gasolina")   :  "  "}")
          )


        ],
      ) 
      ,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), 
    );
  }
}
