import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

//
// TODO:
//
// This test only works with a REAL firebase project instance!
// The firebase-emulator will never show a recaptcha.
//
// In order to test this issue, you need to configure access to your own instance with:
//
// flutterfire configure --platforms=web
//
// This will generate firebase_options.dart
//
// ALSO setup your instance to accept Phone authentication and setup a testing phone number.,

import 'firebase_options.dart';

const testPhoneNumber = 'configure-in-firebase-auth-and-hardcode-here';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'reCAPTCHA fail',
      home: Scaffold(
        body: CaptchaFail(),
      ),
    );
  }
}

class CaptchaFail extends StatefulWidget {
  const CaptchaFail({super.key});

  @override
  State<CaptchaFail> createState() => _CaptchaFailState();
}

class _CaptchaFailState extends State<CaptchaFail> {
  bool _firebaseReady = false;
  bool _calling = false;
  final log = Logger('log');
  List<LogRecord> logEntries = [];

  @override
  void initState() {
    super.initState();
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) => setState(() => logEntries.add(record)));
    log.info('Initializing Firebase...');
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((onValue) {
      setState(() {
        _firebaseReady = true;
        log.info('Firebase initialized');
      });
    }).catchError((err) {
      log.shout('Firebase initialization failed', err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _firebaseReady ? const Center() : const CircularProgressIndicator(),
        const SizedBox(height: 30, child: Text('Test number: $testPhoneNumber')),
        _calling
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () async {
                  try {
                    setState(() => _calling = true);
                    log.info('signInWithPhoneNumber called for $testPhoneNumber...');
                    var confirmation = await FirebaseAuth.instance.signInWithPhoneNumber(testPhoneNumber);
                    log.info('returned from signInWithPhoneNumber: ${confirmation.toString()}');
                  } catch (err, stack) {
                    log.shout('signInWithPhoneNumber failed', err, stack);
                  } finally {
                    setState(() => _calling = false);
                  }
                },
                child: const Text('Login with Phone'),
              ),
        const SizedBox(
          height: 40,
          child: Center(
            child: Text(
                'Keep on clicking login until you get a reCAPTCHA modal and click outside the modal to see the infinite wait '),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: logEntries.length,
                  itemBuilder: (context, index) => ListTile(title: Text(logEntries[index].toString())),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
