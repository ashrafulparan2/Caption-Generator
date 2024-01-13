import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File? _image;
  final picker = ImagePicker();
  String resultText = "Fetching Response...";
  FlutterTts flutterTts = FlutterTts();

  Future<Map<String, dynamic>> queryImageCaption(File image) async {
    const String apiURL =
        "https://api-inference.huggingface.co/models/Salesforce/blip-image-captioning-large";
    const String apiToken = "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";

    Uri uri = Uri.parse(apiURL);
    Map<String, String> headers = {"Authorization": "Bearer $apiToken"};

    try {
      List<int> data = await image.readAsBytes();
      var response = await http.post(uri, headers: headers, body: data);

      if (response.statusCode == 200) {
        dynamic jsonResponse = json.decode(response.body);

        if (jsonResponse is List<dynamic>) {
          String x = json.encode(jsonResponse[0]);
          String y = "";
          for (int i = 19; i < x.length - 2; i++) {
            y += x[i];
          }
          return {'caption': jsonResponse.isNotEmpty ? y : 'No caption'};
        } else if (jsonResponse is Map<String, dynamic>) {
          return jsonResponse;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return {'error': 'Failed to load data'};
    }
  }

  Future<void> pickImage(ImageSource source) async {
    var pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _image = File(pickedImage.path);
      _loading = false;
    });

    Map<String, dynamic> output = await queryImageCaption(_image!);

    setState(() {
      resultText = output['error'] != null
          ? 'Error: ${output['error']}'
          : 'Caption: ${output['caption']}';
    });
  }

  Future<void> pickGalleryImage(ImageSource source) async {
    var pickedImage = await picker.pickImage(source: source);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      _image = File(pickedImage.path);
      _loading = false;
    });

    Map<String, dynamic> output = await queryImageCaption(_image!);

    setState(() {
      resultText = output['error'] != null
          ? 'Error: ${output['error']}'
          : 'Caption: ${output['caption']}';
    });
  }

  Future<void> _speakCaption() async {
    if (resultText != null && resultText.isNotEmpty) {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(resultText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Caption  Generator',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.004, 1],
            colors: [Color(0x11232526), Color(0xFF232526)],
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),

              Text(
                'Image to Text Generator',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: MediaQuery.of(context).size.height - 200,
                padding: EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFA),
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Center(
                      child: _loading
                          ? Container(
                        width: 600,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              width: 100,
                              child: Image.asset('images/notepad.png'),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width:
                              MediaQuery.of(context).size.width,
                              child: Column(
                                children: [],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width:
                              MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await pickGalleryImage(
                                          ImageSource.gallery);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 17),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF7C7287),
                                        borderRadius:
                                        BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'From Gallery',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width:
                              MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await pickGalleryImage(
                                          ImageSource.camera);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 17),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF202A25),
                                        borderRadius:
                                        BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'Take Photo',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                          : Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: 350,
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _loading = true;
                                          resultText =
                                          "Fetching response...";
                                        });
                                      },
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width -
                                        205,
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      child: Image.file(
                                        _image!,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: EdgeInsets.all(16.0),
                              margin: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.blue, Colors.indigo],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    resultText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'Pacifico',
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  FaIcon(
                                    FontAwesomeIcons.fistRaised,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () => _speakCaption(),
                                    child: Text('Read Caption'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
