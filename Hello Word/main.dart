import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
