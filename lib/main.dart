import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


void main(){
  runApp(const GetImage());
}

class GetImage extends StatelessWidget{
  const GetImage({super.key});
  
  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      home:GetPage(),
    );
  }
}

class GetPage extends StatefulWidget{
  const GetPage({super.key});

  @override
  State<GetPage> createState() => _GetPageState();
}

class _GetPageState extends State<GetPage>{
  XFile? _inImage;
  final ImagePicker _picker = ImagePicker();


  Future<void> _selectImage() async{
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery,);
  
    if(image==null){
      return;
    }

    setState((){
      _inImage =image;});
  }

@override
Widget build(BuildContext context){
  return Scaffold(appBar: AppBar(title: const Text('画像選択'),),
    body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
      if(_inImage==null)
        const Text('画像を選択してください')
      else
        Image.file(File(_inImage!.path),),
      
      ElevatedButton(
        onPressed: _selectImage,
        child: const Text('画像選択'),
      ),  
    ],

    ),
    ),
    );
}
}