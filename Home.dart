import 'package:flutter/material.dart';
import 'package:omni/Splash_Screen.dart';
import 'package:omni/Srceen/Map.dart';
import 'package:omni/Srceen/Profile.dart';
import 'package:omni/Srceen/Accident_Report.dart';
import 'package:omni/Srceen/ChatList.dart';
import 'package:omni/Srceen/News.dart';
import 'package:omni/Srceen/Present.dart';
import 'package:omni/Srceen/Report.dart';
import 'package:omni/Srceen/Setting.dart';

class HomePage extends StatefulWidget {
  final String userName;
  final int userId;
  final String userType;
  final Map<String, dynamic> agencyData;

  HomePage({
    required this.userName,
    required this.userId,
    required this.userType,
    required this.agencyData,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomeScreen(),
      NewsPage(),
      ChatListPage(),
      SettingsPage(),
      ProfilePage(
        userId: widget.userId,
        userType: widget.userType,
        agencyData: widget.agencyData,  // Pass agencyData to ProfilePage
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              showMenuDialog(context);
            },
            child: Image.asset('images/Acc.png'), // Ensure the image file exists in the correct folder
          ),
        ),
        title: Text('Omni Alarm, ${widget.userName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality here
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'ข่าวสาร',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'ข้อความ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'แจ้งเตือน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'โปรไฟล์',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  void showMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: Container(
            width: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                  ),
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Text(
                    'เมนู',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'A',
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        leading: Icon(Icons.home),
                        title: Text('หน้าหลัก'),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _selectedIndex = 0;
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('โปรไฟล์'),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _selectedIndex = 4;
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.map),
                        title: Text('แผนที่'),
                        onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapSample()),
                        );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.notifications),
                        title: Text('การแจ้งเตือน'),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _selectedIndex = 3;
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.percent),
                        title: Text('Present'),
                        onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PresentPage()),
                        );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.bookmark_add_outlined),
                        title: Text('Accident_Report'),
                        onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AccidentReportPage()),
                        );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.report_off),
                        title: Text('Report'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                userName: widget.userName,
                                userId: widget.userId,
                                userType: widget.userType,
                                agencyData: widget.agencyData,
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.contact_mail),
                        title: Text('ติดต่อเรา'),
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            _selectedIndex = 2;
                          });
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('การตั้งค่า'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                userName: widget.userName,
                                userId: widget.userId,
                                userType: widget.userType,
                                agencyData: widget.agencyData,
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('ออกจากระบบ'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SplashScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            WeatherWidget(),
            SizedBox(height: 16),
            AlertButton(),
            SizedBox(height: 16),
            NewsWidget(),
            SizedBox(height: 16),
            IncidentStats(),
          ],
        ),
      ),
    );
  }
}

class WeatherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text('มหาสารคาม -> กันทรวิชัย'),
                Text('25 °C'),
                Text('20°    35°'),
              ],
            ),
            Column(
              children: [
                Text('PM 2.5'),
                Text('41°'),
                Text('PM2.5 10 μg/m3'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AlertButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AccidentReportPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text('แจ้งเตือนอุบัติเหตุทั้งหมด'),
      ),
    );
  }
}

class NewsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Image.network('https://via.placeholder.com/400x200'), // Replace with your image URL
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'รถยนต์ประสบอุบัติเหตุ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'A',
                  ),
                ),
                Text('รถเก๋งหักไปชนตรงประสานงากัน'),
                Text('8m ago'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IncidentStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StatsCard(
          icon: Icons.train,
          color: Colors.orange,
          label: 'รถไฟ',
          percentage: 53,
        ),
        StatsCard(
          icon: Icons.directions_car,
          color: Colors.red,
          label: 'รถยนต์',
          percentage: 53,
        ),
        StatsCard(
          icon: Icons.motorcycle,
          color: Colors.blue,
          label: 'รถจักรยานยนต์',
          percentage: 53,
        ),
      ],
    );
  }
}

class StatsCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final int percentage;

  StatsCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 40),
            SizedBox(height: 8),
            Text('$percentage%', style: TextStyle(fontSize: 24)),
            SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
