import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/widgets.dart';

class MusbxPrivacyPolicy extends StatelessWidget {
  const MusbxPrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize =
        WindowSize.fromSize(MediaQuery.sizeOf(context));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TitleButton(
          onPressed: () {
            context.go("/musbx");
          },
          child: Text("Musician's Toolbox"),
        ),
      ),
      body: Padding(
        padding: windowSize.padding,
        child: Column(
          children: [
            Text(
                """This app, Musician's Toolbox, offers a set of tools for musicians, including but not limited to a Metronome, a Tuner and a Music player (for transcribing songs).

As an avid Android user myself, I take privacy very seriously. I know how irritating it is when apps collect your data without your knowledge.

I hereby state, to the best of my knowledge and belief, that I have not programmed this app to collect any personally identifiable information. All data (app preferences, uploaded files, etc.) created by you (the user) is either stored on your device only or cannot be connected to you. All data that is stored on your device can be erased by simply clearing the app's data or uninstalling it.

If you find any security vulnerability that has been inadvertently caused by me, or have any question regarding how the app protectes your privacy, please send me an email at bemain.dev@gmail.com.

Yours sincerly,
Benjamin Agardh
Rydebäck, Sweden"""),
          ],
        ),
      ),
    );
  }
}
