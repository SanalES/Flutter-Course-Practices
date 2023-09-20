import 'package:flutter/material.dart';
import 'package:project_june1/mediaquery/Size%20Test.dart';

void main(){
  runApp(MyApp());
}
class homee extends StatelessWidget {
  final data;
  const homee({Key? key,required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var name  = data[0]['name'];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Welcome $name"),
      ),
      body: Center(

        child: Text('Success'),
      ),
    );
  }
}