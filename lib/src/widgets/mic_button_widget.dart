import 'dart:math';

import 'package:tallercall/src/providers/info.dart';
import 'package:tallercall/src/services/tts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/v2/dialogflow_v2.dart';

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tallercall/src/providers/dialogflow_provider.dart';

import '../../constants.dart';

class MicWidget extends StatefulWidget {
  final Info info;

  MicWidget({@required this.info});

  @override
  _MicWidgetState createState() => _MicWidgetState();
}

class _MicWidgetState extends State<MicWidget> {

  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  SpeechToText speech = SpeechToText();
  String _currentLocaleId = 'es_US';
  bool _hasSpeech = false;
  String intent = '';
  SpeechRecognitionResult result;
  final dialogflow = DialogflowProvider(fileJson: "assets/taller-call-ddd1a997ca47.json");
  bool oneTime = false;

  @override
  void initState()  {
    initSpeech();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return FloatingActionButton(
      child: Icon(Icons.call,color: speech.isListening ? Colors.redAccent : Colors.white,),
      backgroundColor: Colors.red,
      onPressed: ()  {
        if(!_hasSpeech || !speech.isListening){
          oneTime = true;
        startListening();}
        },
    );
  }


  Future<void> initSpeech() async {
    bool hasSpeech = await speech.initialize( onStatus: statusListener, onError: errorListener );
    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
  }


  void errorListener(SpeechRecognitionError error) {

    lastError = "${error.errorMsg} - ${error.permanent}";
  }

  void statusListener(String status) {

    lastStatus = "$status";

  }

  void resultListener(SpeechRecognitionResult result) async {
    if (result.finalResult) {
      setState(() {
        lastWords = result.recognizedWords.toLowerCase();
      });
      if(oneTime) {
        widget.info.sstText = result.recognizedWords.toLowerCase();
        QueryResult query = await dialogflow.response(lastWords);
        if (!kIntentExclusion.contains(query.intent.displayName)) speak(
            query.fulfillmentText);
        widget.info.intent = query.intent.displayName;
        widget.info.queryResult = query;
        oneTime = false;
      }
    }
  }

  startListening()  {
     speech.listen(
        onResult: resultListener,
        localeId: _currentLocaleId,
        pauseFor: Duration(seconds: 3),
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: true,
        onDevice: true,
        listenMode: ListenMode.confirmation);

  }

  soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel,level);
    maxSoundLevel = max(maxSoundLevel,level);
  }
}
