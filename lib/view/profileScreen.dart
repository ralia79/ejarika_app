import 'package:Ejarika/utils/colors.dart';
import 'package:flutter/material.dart';

class Profilescreen extends StatelessWidget {
  final bool isLogined = false;
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
                    leading: Icon(Icons.account_circle),
                    title: Text('حساب کاربری'),
                    subtitle: Text('کاربر فعلی: 09123456789'),
                  )
                else
                  ListTile(
                    leading: Icon(Icons.login),
                    title: Text(
                        'برای استفاده از تمامی قابلیت‌های اجاریکا وارد شوید'),
                  ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Divider(color: Colors.grey),
                ),
                ListTile(
                  leading: Icon(Icons.bookmark),
                  title: Text('علاقه‌مندی‌ها'),
                ),
                ListTile(
                  leading: Icon(Icons.sell),
                  title: Text('آگهی های من'),
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
          Text(
            'Version 1.0.0',
          ),
          Text(
            'Made with ❤️ in Ejarika',
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
