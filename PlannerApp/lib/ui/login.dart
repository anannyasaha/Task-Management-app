import 'package:PlannerApp/model/calendar_client.dart';
import 'package:PlannerApp/model/oauth_client.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis/calendar/v3.dart' as gCalendar;
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> login() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //get OAuth credentials
  var client = new ClientId(OAuthClient.ANDROID_CLIENT_ID, "");
  const scopes = const [gCalendar.CalendarApi.CalendarScope];
  await clientViaUserConsent(client, scopes, userPrompt).then((AuthClient auth) {
    CalendarClient.calendar = gCalendar.CalendarApi(auth);
  });

  //run app after login
  //runApp(Main())
}

//login to Google Account
void userPrompt(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw "Could not launch url $url";
  }
}