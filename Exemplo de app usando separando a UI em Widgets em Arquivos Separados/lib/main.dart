import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'telas/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  build(BuildContext context) {
    return MaterialApp(title: "Material UI", home: HomePage());
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   build(BuildContext context) {
//     return MaterialApp(
//         title: "Material UI",
//         home: Scaffold(
//           appBar: AppBar(
//             title: new Text('App menu'),
//           ),
//           body: new Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               new Row(
//                 children: [
//                   Text("filho 1 "),
//                   Expanded(child: Text("filho 2")),
//                   Text("filho 3")
//                 ],
//               ),
//               new Row(children: [
//                 Text("filho 4"),
//                 Text("filho 5"),
//                 Text("filho 6")
//               ]),
//               new Row(
//                 children: [Text("filho 7"), Text("filho 8"), Text("filho 9")],
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.yellow, width: 4),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: new Row(
//                   children: [Text("Davi")],
//                 ),
//               )
//             ],
//           ),
//           backgroundColor: Colors.lightBlue,
//         ));


/* 
void main() {
  runApp(MyApp());
 }


 class MyApp extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hello World App'),
        ),
         body: Center(
          child: Text(
            'Hello, World!',
            style: TextStyle(fontSize: 24),
          ),
         ),
       ),
     );
   }
 }

*/



// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Hello world IOS<<<<<<<<<<<<<<<<


// import 'package:flutter/cupertino.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoApp(
//       home: CupertinoPageScaffold(
//         navigationBar: CupertinoNavigationBar(
//           middle: Text('Hello World'),
//         ),
//         child: Center(
//           child: Text('Hello, World!'),
//         ),
//       ),
//     );
//   }
// }
