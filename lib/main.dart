import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:gal/gal.dart';


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
  Uint8List? _outImage;


  Future<void> _selectImage() async{
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery,);
  
    if(image==null){
      return;
    }

    setState((){
      _inImage =image;
      _outImage = null;
      });
    await _getImage();
  }

  Future<void> _getImage()async{
    if(_inImage==null)return;

    final bytesBox = await File(_inImage!.path).readAsBytes();
    final img.Image? imageO = img.decodeImage(bytesBox);
    
    if(imageO==null)return;
    
    for(int i=0;i<imageO.height;i++){
      for(int j=0; j<imageO.width~/2;j++){
        final p =imageO.getPixel(j, i);
        imageO.setPixel(imageO.width-1-j,i,p);
          
      }
    }
      
    setState((){_outImage = img.encodeJpg(imageO);});
  }

  Future<void> _saveImage()async{
    if(_outImage==null){
      return;
    }

    await Gal.putImageBytes(_outImage!,name: 'symmetry.jpg');


    if(!mounted)return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("保存しました"),
      )
    );



  }

@override
Widget build(BuildContext context){
  return Scaffold(appBar: AppBar(title: const Text('画像選択'),),
    body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
      if(_inImage==null)
        const Text('画像を選択してください')

      else if(_outImage==null)
        const Text('画像を加工中です')
        
      else
        Image.memory(_outImage!),
        
        //if,elseここまで




      
      ElevatedButton(
        onPressed: _selectImage,
        child: const Text('画像選択'),
      ),  

      if(_outImage != null)
        ElevatedButton(
          onPressed: _saveImage,
          child: const Text('保存'),
        )

      
      
    ],

    ),
    ),
    );
}
}