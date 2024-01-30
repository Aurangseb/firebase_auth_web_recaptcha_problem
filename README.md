# firebase_auth_web_recaptcha_problem

Example of the reCAPTCHA modal auth failure for Flutter Firebase Web Auth with Phone

## Get Started

To experience the problem, you need a real Firebase Instance. This issue does not show on the Firebase emulator.

1) Create a real Firebase project for testing purposes 
2) Enable Phone Authentication
3) Add a test phone number to Firebase Phone Auth
4) Copy/Paste the number into `testPhoneNumber` in `main.dart`
5) Run `flutterfire configure --platforms=web` to create `firebase_options.dart`
6) Deploy to hosting or run locally

## Run the App

1) Keep on clicking Login until you get a reCAPTCHA modal
2) You can try using a VPN provider and switching countries to get that CAPTCHA quicker
3) Click outside the modal
4) Enjoy the infinite hang

