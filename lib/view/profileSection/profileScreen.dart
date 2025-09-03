import 'package:ejarika_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    print("removed");
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
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Divider(color: Colors.grey),
                ),
                ListTile(
                  leading: Icon(Icons.bookmark),
                  title: Text('علاقه‌مندی‌ها'),
                  onTap: () => Navigator.pushNamed(context, '/favorites'),
                ),
                ListTile(
                  leading: Icon(Icons.sell),
                  title: Text('آگهی های من'),
                  onTap: () => Navigator.pushNamed(context, '/own-ad'),
                ),
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text('دعوت از دوستان'),
                ),
                ListTile(
                  leading: Icon(Icons.support),
                  title: Text('پشتیبانی'),
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('درباره ما'),
                ),
              ],
            ),
          ),
          Text('Version 1.0.0'),
          Text('Made with ❤️ in Ejarika'),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
