import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File? _image;
  final picker = ImagePicker();
  String resultText = "Fetching Response...";

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    }
    setState(() {
      _image = File(image.path);
      _loading = false;
    });
  }

  pickgalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    setState(() {
      _image = File(image.path);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                'Caption  Generator',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
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
                height: MediaQuery.of(context).size.height - 250,
                padding: EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  // color: Colors.white,
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
                              width: 500,
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
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        // GestureDetector(
                                        //   onTap: () {},
                                        //   child: Container(
                                        //     // width: MediaQuery.of(context).size.width -
                                        //     //     300,
                                        //
                                        //     alignment: Alignment.center,
                                        //     padding: EdgeInsets.symmetric(
                                        //         horizontal: 24, vertical: 17),
                                        //     decoration: BoxDecoration(
                                        //       color: Color(0xFF093A3E),
                                        //       borderRadius:
                                        //           BorderRadius.circular(6),
                                        //     ),
                                        //     child: Text(
                                        //       'Live Camera',
                                        //       style: TextStyle(
                                        //         color: Colors.white,
                                        //         fontSize: 18,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: pickgalleryImage,
                                          child: Container(
                                            // width: MediaQuery.of(context).size.width -
                                            //     300,

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
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: pickImage,
                                          child: Container(
                                            // width: MediaQuery.of(context).size.width -
                                            //     300,

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
                                    height: 200,
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
                                    height: 20,
                                  ),
                                  Container(
                                    child: Text(
                                      resultText,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
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
