import 'package:Ejarika/utils/colors.dart';
import 'package:flutter/material.dart';

class Profilescreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اجاریکا من', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('حساب کاربری'),
                  subtitle: Text('کاربر فعلی: 09123456789'),
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
