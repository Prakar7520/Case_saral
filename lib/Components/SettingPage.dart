import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ver2/Components/SplashScreen.dart';
import 'NotificationPlugin.dart';

Future<void> _launchURLMail() async {
  const url =
      'mailto:dio-edt@nic.in';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class SettingPage extends StatefulWidget {
  static String id = "SettingPage";

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool lockInBackground = true;
  bool enableNotification = false;
  bool notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    getToogleData().whenComplete(() async => null);
    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    // notificationPlugin.setOnNotificationClick(onNotificationClick);
    }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future getToogleData() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getBool('notificationToogle');
    setState(() {
      toogleData = obtainedEmail;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: buildSettingsList(),
    );
  }

  Widget buildSettingsList() {

    return SettingsList(
      sections: [
        SettingsSection(
          title: 'Common',
          tiles: [
            SettingsTile(
              title: 'Language',
              subtitle: 'English',
              leading: Icon(Icons.language),
              onPressed: (context) {},
            ),

          ],
        ),
        SettingsSection(
          title: 'Our Contact',
          tiles: [
            SettingsTile(title: 'Phone number: 9910788993', leading: Icon(Icons.phone),onPressed: (context){
              _makePhoneCall("tel: 9910788993");
            },),
            SettingsTile(title: 'Email:   dio-edt@nic.in', leading: Icon(Icons.email),onTap: (){_launchURLMail();},),
            SettingsTile(title: 'Sign out', leading: Icon(Icons.exit_to_app)),
          ],
        ),
        SettingsSection(
          title: 'Security',
          tiles: [
            SettingsTile.switchTile(
              title: 'Enable/Disable Security',
              leading: Icon(Icons.phonelink_lock),
              switchValue: lockInBackground,
              onToggle: (bool value) {
                setState(() {
                  lockInBackground = value;
                  notificationsEnabled = value;
                });
              },
            ),

            SettingsTile.switchTile(

              title: 'Enable Notifications',
              leading: Icon(Icons.notifications_active),
              switchValue: toogleData == null ? false : toogleData,
              enabled: notificationsEnabled,
              onToggle: (bool value) async{
                final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.setBool('notificationToogle', value);
                sharedPreferences.getBool('notificationToogle');

                setState(() {
                  toogleData = sharedPreferences.getBool('notificationToogle');
                  enableNotification = toogleData;
                });
                if(enableNotification == notificationsEnabled) {

                  await notificationPlugin.showDailyMorningAtTime();
                }
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'Build',
          tiles: [
            SettingsTile(
                title: 'Terms of Service', leading: Icon(Icons.description)),
            SettingsTile(
                title: 'Open source licenses',
                leading: Icon(Icons.collections_bookmark)),
          ],
        ),
        CustomSection(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 22, bottom: 8),
                child: Image.asset(
                  'assets/settings.png',
                  height: 50,
                  width: 50,
                  color: Color(0xFF777777),
                ),
              ),
              Text(
                'Version: 2.4.0 (287)',
                style: TextStyle(color: Color(0xFF777777)),
              ),
            ],
          ),
        ),
      ],
    );
  }
  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {
    Navigator.pushNamed(context, SplashScreen.id);
  }
}