import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


void main() => runApp(PlushedApp());

class PlushedApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plushed',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        backgroundColor: Colors.black,
      ),
      home: CameraPage(title: 'Plushed'),
    );
  }
}

class CameraPage extends StatefulWidget {
  CameraPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController _controller;
  Future<void> _initCameraFuture;

  Future<void> initCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    _controller = CameraController(cameras.first, ResolutionPreset.veryHigh);
    await _controller.initialize();
  }

  @override
  void initState() {
    super.initState();
    _initCameraFuture = initCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<void>(
        future: _initCameraFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
