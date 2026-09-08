import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:gal/gal.dart';

enum Side{
  left,
  right,
}


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
  Uint8List? _outImagel,_outImager;


  Future<void> _selectImage() async{
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery,);
  
    if(image==null){
      return;
    }

    setState((){
      _inImage =image;
      _outImagel = null;
      _outImager = null;
      });
    await _getImage();
  }

  Future<void> _getImage()async{
    if(_inImage==null)return;

    final bytesBox = await File(_inImage!.path).readAsBytes();
    final img.Image? imageO = img.decodeImage(bytesBox);
    
    if(imageO==null)return;
    
  final imageOl = img.Image.from(imageO);
  final imageOr = img.Image.from(imageO);
    for(int i=0;i<imageO.height;i++){
      for(int j=0; j<imageO.width~/2;j++){
        final tmpl =imageO.getPixel(j, i);
        imageOl.setPixel(imageO.width-1-j,i,tmpl);
        final tmpr =imageO.getPixel(imageO.width-1-j, i);
        imageOr.setPixel(j,i,tmpr);
          
      }
    }
      
    setState((){
      _outImagel = img.encodeJpg(imageOl);
      _outImager = img.encodeJpg(imageOr);
      });
  }

  Future<void> _saveImage(Side a)async{
    if (_outImagel == null && _outImager == null) {
      return;
    }

    if(_outImagel!=null && a==Side.left){
     await Gal.putImageBytes(_outImagel!,name: 'symmetryL.jpg');
    }

    if(_outImager !=null && a==Side.right){
      await Gal.putImageBytes(_outImager!,name: 'symmetryR.jpg');
    }

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
    body: SafeArea( child: 
    Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
      if(_inImage==null)
        const Text('画像を選択してください')

      else if(_outImager==null||_outImagel==null)
        const Text('画像を加工中です')
        
      else
        Expanded(
          child: Row(
            children:[
              Expanded(
                child: Column(
                  children:[
                    Expanded(child: Image.memory(
                      _outImagel!,
                      fit: BoxFit.contain,
                      ),),
                    Text("左反転画像"),
                    if(_outImagel !=null)
                      ElevatedButton(
                        onPressed: () => _saveImage(Side.left),
                        child: const Text('保存'),
                      ),
                  ]
                )
              ),

              Expanded(
                child: Column(
                  children:[
                    Expanded(child: Image.memory(
                      _outImager!,
                      fit: BoxFit.contain,
                      ),),
                    Text("右反転画像"),
                    if(_outImager !=null)
                      ElevatedButton(
                        onPressed: ()=> _saveImage(Side.right),
                        child: const Text('保存'),
                      ),
                ]
              )
            ),
          ]
        )),//
        
        
        //if,elseここまで




      
      ElevatedButton(
        onPressed: _selectImage,
        child: const Text('画像選択'),
      ),  

      const SizedBox(height: 40),

     

      
      
    ],

    ),
    ),
    )
    );
}
}