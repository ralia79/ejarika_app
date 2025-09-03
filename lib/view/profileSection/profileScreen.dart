import 'package:ejarika_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLogined = false;
  String? userData;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('user_data');
    if (data != null) {
      setState(() {
        isLogined = true;
        userData = data;
      });
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    setState(() {
      isLogined = false;
      userData = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('با موفقیت از حساب کاربری خودتون خارج شدین'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleNavigation(BuildContext context, String routeName) {
    if (!isLogined) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('برای استفاده از این قابلیت ابتدا وارد حساب کاربری شوید'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    Navigator.pushNamed(context, routeName);
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اجاریکا من', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              children: [
                if (isLogined)
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('خروج از حساب کاربری'),
                    onTap: logout,
                  )
                else
                  ListTile(
                    leading: Icon(Icons.login),
                    title: Text(
                        'برای استفاده از تمامی قابلیت‌های اجاریکا وارد شوید'),
                    onTap: () => Navigator.pushNamed(context, '/sign-in'),
                  ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
                  child: Divider(color: Colors.grey),
                ),
                ListTile(
                  leading: Icon(Icons.bookmark),
                  title: Text('علاقه‌مندی‌ها'),
                  onTap: () => _handleNavigation(context, '/favorites'),
                ),
                ListTile(
                  leading: Icon(Icons.sell),
                  title: Text('آگهی های من'),
                  onTap: () => _handleNavigation(context, '/own-ad'),
                ),
                ListTile(
                  leading: Icon(Icons.support),
                  title: Text('پشتیبانی'),
                  onTap: () => _showSnackbar(
                      "برای پشتیبانی لطفا با support@ejarika.ir ارتباط بگیرید ."),
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('درباره ما'),
                  onTap: () => _launchURL('https://ejarika.ir'),
                ),
              ],
            ),
          ),
          Text('Version 1.0.0'),
          Text('Made with ❤️ in Iran'),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
