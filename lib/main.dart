import 'dart:async';
import 'dart:math';

import 'package:emojirain/emoji_fly_animation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Homer()));
}

class Homer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: View(
        numberOfItems: 20,
      ),
    );
  }
}

class View extends StatefulWidget {
  final int numberOfItems;

  const View({required this.numberOfItems});

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  String strHaha = 'assets/images/haha.png';
  String strwow = 'assets/images/wow.png';
  String strlove = 'assets/images/love.png';
  String strangry = 'assets/images/angry.png';
  String strsad = 'assets/images/sad.png';

  int _animationsRunning = 0;
  List<Widget> animatedEmojis = [];
  Timer? emojiCollectorTimer;
  Timer? _timer;
  bool _isButtonPressed = false;
  final emojiHahaKey = GlobalKey();
  final emojiWowKey = GlobalKey();
  final emojiLoveKey = GlobalKey();
  final emojiAngryKey = GlobalKey();
  final emojiSadKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Scaffold(
              appBar: AppBar(
                title: Text("Emoji Example Rain"),
              ),
              body: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 600, bottom: 600),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        customGestureDetector(
                          emojiUrl: strHaha,
                          selectedKey: emojiHahaKey,
                          child: Container(
                            key: emojiHahaKey,
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, image: DecorationImage(image: ExactAssetImage(strHaha))),
                            // RaisedButton(
                            //
                            //   child: Text("T"),
                            //   onPressed: (){
                            //     makeItems(strHaha);
                            //   },
                            // ),
                          ),
                        ),
                        customGestureDetector(
                          emojiUrl: strwow,
                          selectedKey: emojiWowKey,
                          child: Container(
                            key: emojiWowKey,
                            height: 50,
                            width: 50,
                            decoration:
                                BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: AssetImage(strwow))),
                          ),
                        ),
                        customGestureDetector(
                          emojiUrl: strsad,
                          selectedKey: emojiSadKey,
                          child: Container(
                            key: emojiSadKey,
                            height: 50,
                            width: 50,
                            decoration:
                            BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: AssetImage(strsad))),
                          ),
                        ),
                        customGestureDetector(
                          emojiUrl: strangry,
                          selectedKey: emojiAngryKey,
                          child: Container(
                            key: emojiAngryKey,
                            height: 50,
                            width: 50,
                            decoration:
                                BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: AssetImage(strangry))),
                            // RaisedButton(
                            //
                            //   child: Text("T"),
                            //   onPressed: (){
                            //     makeItems(strHaha);
                            //   },
                            // ),
                          ),
                        ),
                        customGestureDetector(
                          emojiUrl: strlove,
                          selectedKey: emojiLoveKey,
                          child: Container(
                            key: emojiLoveKey,
                            height: 50,
                            width: 50,
                            decoration:
                                BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: AssetImage(strlove))),
                            // RaisedButton(
                            //
                            //   child: Text("T"),
                            //   onPressed: (){
                            //     makeItems(strHaha);
                            //   },
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ...animatedEmojis,
          ],
        ),
      ),
    );
  }

  Widget customGestureDetector({required Widget child, required String emojiUrl, required GlobalKey selectedKey}){
    return GestureDetector(
      onTapDown: (_) {
        final renderBox = selectedKey.currentContext?.findRenderObject() as RenderBox?;
        final position = renderBox?.localToGlobal(Offset.zero);
        setState(() {
          _isButtonPressed = true;
          _startTimer(emojiUrl,position);
        });
      },
      onTapUp: (_) {
        setState(() {
          _isButtonPressed = false;
          _cancelTimer();
        });
      },
      onTapCancel: () {
        setState(() {
          _isButtonPressed = false;
          _cancelTimer();
        });
      },
      onTap: () {
        final renderBox = selectedKey.currentContext?.findRenderObject() as RenderBox?;
        final position = renderBox?.localToGlobal(Offset.zero);
        onEmojiTap(emojiUrl,position);
      },
      child: child,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void onEmojiTap(String url, Offset? position) {
    setState(() {
      animatedEmojis.add(EmojiFlyAnimation(assetUrl: url, endedCallback: animationEnded, position: position,));
      _animationsRunning++;
    });
  }

  void animationEnded() {
    _animationsRunning--;
    if (_animationsRunning == 0) {
      setState(() {
        animatedEmojis = [];
      });
      print('all animations completed - removing widget from stack (now has ${animatedEmojis.length} elements)');
    }
  }

  void _startTimer(String url, Offset? position) {
    _timer = Timer.periodic(Duration(milliseconds: 150), (_) {
      if (_isButtonPressed) {
        onEmojiTap(url, position);
      }
    });
  }

  // Cancel the timer when the button is released.
  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
