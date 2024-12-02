import "package:flutter/material.dart";
import 'package:testando_widgets/screens/AvaliacoesPage.dart';

import 'screens/HomePage.dart';
void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _indiceDeNavegacaoDeTelas = 0;
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Text("Menu"),
              backgroundColor: Colors.blue,
            ),

            drawer: Drawer(
              child: 
                    Column(
                      children: [
                        Text("Home"),
                        Divider(),
                         Text("Configurações"),
                        Divider(),
                         Text("Sobre"),
                        Divider()

                      ],
                    ),

            ),
            body: 
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text("Filho 1"),
            //     Text("Filho 2"),
            //     Text("Filho 3")
            //   ],
            // ),
            // Row(
            //   children: [
            //     Align(
            //       alignment: Alignment.topCenter,
            //       child: Text("Hello word"),
            //     )
            //   ],
            // )

            // Row(
            //   children: [
            //       ConstrainedBox(
            //         constraints: BoxConstraints(
            //           minWidth: 200.0,
            //           minHeight: 200.0
            //         ) ,
            //         child: 
            //               Container(
            //                 alignment: Alignment.center,
            //                 decoration: BoxDecoration( color: Colors.blue, border: Border.all( color: Colors.red, ) ),
            //                 child: Text("hello"),
            //               )
            //         ),
                    
            //   ],
    
            // )


            Row(
              children: [
                Container(
                    width: 200,
                    height: 200,
                    child: Card(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          RotatedBox(quarterTurns: 3,child: Text("Nome do usuario"),)
                            
                        ],
                    ),
                ),

                )
                ,

                Container(
                  decoration: BoxDecoration(color: Colors.blue),
                  child:  SizedBox(
                  width: 200,
                  height: 300,
                  child: Text("filho do widget sizedbox"),
                ),
                )
               
                
              ],
            )


           
            ,
            bottomNavigationBar: 
                BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(icon: Icon(Icons.home),label:"home"),
                    BottomNavigationBarItem(icon: Icon(Icons.check_box_rounded),label:"avaliações"),
                  
                  
                ]
                ,
                currentIndex: _indiceDeNavegacaoDeTelas
                ,
                onTap: (int index){
                    setState(() {
                     _indiceDeNavegacaoDeTelas= index; 
                     });


                    if(index==0){
                      // Navigator.pop(context);
                        // Navigator.pushNamed(context, "/home");


                     Navigator.push( context, MaterialPageRoute(builder: (context) => HomePage()), );
                    }
                    if(index==1){
                      // Navigator.pop(context);
                        // Navigator.pushNamed(context, "/avaliacoes");
                      // Navigator.pushReplacementNamed(context, "/avaliacoes");
                      Navigator.push( context, MaterialPageRoute(builder: (context) => AvaliacoesPage()));


                    }
                    
                },
                ),
                
                
          ),
          

          routes: <String, WidgetBuilder>{
               "/home": (BuildContext bc) =>
                   HomePage()
               ,
                
              "/avaliacoes": (BuildContext bc) => AvaliacoesPage(),

              "/avaliar_local": (BuildContext bc) => Scaffold(
                appBar: AppBar(
                  title: Text("Avaliações"),
                ),
                body: Center(
                  child: Text("Aqui é feita a a avaliação"),
                ),
              ),
               "/login": (BuildContext bc) => Scaffold(
                appBar: AppBar(
                  title: Text("login"),
                ),
                body: Center(
                  child: Text("Aqui ocorre o login"),
                ),
              ),
              "/cadrastrar_usuario": (BuildContext bc) => Scaffold(
                appBar: AppBar(
                  title: Text("cadrastro"),
                ),
                body: Center(
                  child: Text("Aqui é feito o cadrastro"),
                ),
              ),


        }, // Corrigi a vírgula e fechei o map

    );
  }
}
