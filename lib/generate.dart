import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';

class GenerateScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GenerateScreenState();
}

class GenerateScreenState extends State<GenerateScreen> {
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  GlobalKey globalKey = new GlobalKey();
  String _dataString = "Hello from this QR";
  List<String> _data = new List();
  String _inputErrorText;
    final TextEditingController _textController = TextEditingController();
    final TextEditingController _textController1 = TextEditingController();
    final TextEditingController _textController2 = TextEditingController();
    final TextEditingController _textController3 = TextEditingController();
    final TextEditingController _textController4 = TextEditingController();
    final TextEditingController _textController5 = TextEditingController();


   bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _captureAndSharePng,
          ),
           IconButton(
            icon: Icon(Icons.save),
            onPressed: () {_save(context);},
          )
        ],
      ),
      body: _contentWidget(),
    );
  }

  Future<void> _captureAndSharePng() async {
    try {
   
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      final channel = const MethodChannel('channel:me.alfian.share/share');
      channel.invokeMethod('shareFile', 'image.png');
      
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _save(BuildContext context) async{
  try {
       Map<PermissionGroup, PermissionStatus> permission = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      if(permission[PermissionGroup.storage].value == 2){
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      //final result = await ImageGallerySaver.save(pngBytes);
      }
    } catch (e) {
      print(e.toString());
    }
  }
List<String> yourList = ["20", "3005", "2"];

//  void _showToast(BuildContext context , String text) {
//     final scaffold = Scaffold.of(context,nullOk:false);
//     scaffold.showSnackBar(
//       SnackBar(
//         content:  Text(text),
//         action: SnackBarAction(
//             label: 'Ok', onPressed: scaffold.hideCurrentSnackBar),
//       ),
//     );
//   }
  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: <Widget>[
          
                      TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: "Enter Place name",
                        errorText: _inputErrorText,
                      ),
                    ),
                    
                      TextField(
                      controller: _textController1,
                      decoration: InputDecoration(
                        hintText: "Enter image url",
                        errorText: _inputErrorText,
                      ),
                    ),
                    TextField(
                      controller: _textController2,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter room number",
                        errorText: _inputErrorText,
                      ),),
                      TextField(
                      controller: _textController3,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Enter table number",
                        errorText: _inputErrorText,
                      ),),
                      TextField(
                      controller: _textController4,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Enter id ",
                        errorText: _validate ? 'no spaces allowed' : null,
                      ),),TextField(
                      controller: _textController5,
                      decoration: InputDecoration(
                        hintText: "Enter a custom message",
                        errorText: _inputErrorText,
                      ),
                    ),
                  
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: FlatButton(
                      child: Text("SUBMIT"),
                      onPressed: () {
                        setState(() {
                            _textController4.text.contains(" ") ? _validate = true : _validate = false;
                       
                        _data = [_textController.text,_textController1.text,_textController2.text,_textController3.text,_textController4.text,_textController5.text];
                         _dataString = _data.join(',') ;
                       print(_dataString);
                          //print(_data);
                         // print(_dataString);
                          _inputErrorText = null;
                        });
                      },
                    ),
                  ),Center(
              child: RepaintBoundary(
                  key: globalKey,
                  child: Container(
                    color: Colors.white,
                    child: QrImage(
                      data: _dataString,
                      size: 0.25 * bodyHeight,
                      onError: (ex) {
                        print("[QR] ERROR - $ex");
                        setState(() {
                          _inputErrorText =
                              "Error! Maybe your input value is too long?";
                        });
                      },
                    ),
                  )),
            ),
                      

                    ],
                  ),
                  
            
          
          
      
    );
  }
}
