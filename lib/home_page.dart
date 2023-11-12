import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voxnest/openai_service.dart';
import 'pallete.dart';
import 'feature_box.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
  }

  Future<void>initSpeechToText() async{
  await speechToText.initialize();
  setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  void dispose(){
    super.dispose();
    speechToText.stop();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Allen'),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: Pallete.assistantCircleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  height: 123,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage('assets/images/virtualAssistant.png',
                    ),
                    ),
                  ),
                ),
              ],
            ),
            //chat bubble code
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                top: 30,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Pallete.borderColor,
                ),
                borderRadius: BorderRadius.circular(20).copyWith(
                  topLeft: Radius.zero,
                ),
              ),
              child: const Padding(padding: EdgeInsets.symmetric(
                vertical: 10.0
              ),
              child: Text(
                'Hello, what task can I do for you?',
                style: TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Pallete.mainFontColor,
                  fontSize: 20,
                ),
              ),),
            ),
            //little text
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 10 , left: 22),
              child: const Text(
                'Here are a few features',
                style: TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Pallete.mainFontColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //features List
           Column(
             children: const [
               FeatureBox(
                  color: Pallete.firstSuggestionBoxColor,
                 headerText: 'ChatGPT',
                 descriptionText: 'A smarter way to stay organized and informed with ChatGPT',
               ),
               FeatureBox(
                 color: Pallete.secondSuggestionBoxColor,
                 headerText: 'Dall-E',
                 descriptionText: 'Get inspired and stay creative with your personal assistant powered by Dall-E',
               ),
               FeatureBox(
                 color: Pallete.thirdSuggestionBoxColor,
                 headerText: 'Smart Voice Assistant',
                 descriptionText: 'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT',
               ),
             ],

           )
          ],
        ),

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.secondSuggestionBoxColor,
          onPressed: () async{
          if(await speechToText.hasPermission && speechToText.isNotListening){
           await startListening();
          }
          else if(speechToText.isListening){
          final speech =  await openAIService.isArtPromptAPI(lastWords);
          print(speech);
           await stopListening();
          }
          else{
            initSpeechToText();
          }
          },
        child: const Icon(Icons.mic),
      ) ,
    );
  }
}
