import 'package:expense_tracker/ui/mainScreen/details/detailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/floorDatabase/database/database.dart';
import 'package:expense_tracker/floorDatabase/entity/registerEntity.dart';
import 'package:expense_tracker/ui/authenticationScreen/login_register_tab_view.dart';
import 'package:expense_tracker/ui/mainScreen/dashboard/dashboardView.dart';
import 'package:expense_tracker/ui/mainScreen/profile/profileView.dart';
import 'package:expense_tracker/ui/mainScreen/setting/settings.dart';
import 'package:expense_tracker/ui/mainScreen/statistics/StatisticsScreen.dart';
import 'package:expense_tracker/utility/routeTransition.dart';
import 'package:expense_tracker/utility/textStyle.dart';
import 'package:expense_tracker/configs/palette.dart';
import 'package:expense_tracker/configs/dimension.dart';
import '../../supports/utils/sharedPreferenceManager.dart';
import '../userData/userDataService.dart';
import 'goal/goalScreen.dart';

class HomeScreen extends StatefulWidget {
  final AppDatabase appDatabase;

  const HomeScreen({super.key, required this.appDatabase});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool isLoading = true;
  RegisterEntity? user;
  late List<Widget> _widgetOptions;

  static const List<String> _titles = [
    'Expense Tracker',
    'Statistics',
    'Details',
    'Goal',
    'Setting',
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() => isLoading = true);

    UserDataService service = UserDataService(widget.appDatabase);
    RegisterEntity? fetchedUser = await service.getUserData(context);

    if (fetchedUser != null) {
      user = fetchedUser;

      _widgetOptions = [
        DashboardView(appDatabase: widget.appDatabase, userId: user!.id!),
        StatisticsScreen(appDatabase: widget.appDatabase, userId: user!.id!,),
        DetailsScreen(appDatabase: widget.appDatabase, userId: user!.id!),
        GoalScreen(appDatabase: widget.appDatabase, userId: user!.id!),
        Settings(appDatabase: widget.appDatabase, userId: user!.id!,),
      ];
    } else {
      // User not found → redirect to login
      _logout();
      return;
    }

    setState(() => isLoading = false);
  }

  void _logout() async {
    await SharedPreferenceManager.clearToken();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              LoginRegisterView(appDatabase: widget.appDatabase)),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_selectedIndex]),
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(halfPadding),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      customPageRouteFromRight(
                        ProfileView(appDatabase: widget.appDatabase),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person),
                ),
              ),
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : (_widgetOptions.isEmpty
            ? const Center(child: Text("No user found"))
            : _widgetOptions[_selectedIndex]),
        drawer: _buildDrawer(),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Palette.primaryColor),
            child: Text(
              'Expense Tracker',
              textAlign: TextAlign.center,
              style: mediumTextStyle(textColor: Colors.white, fontSize: 20),
            ),
          ),
          ...List.generate(_titles.length, (index) {
            return ListTile(
              title: Text(_titles[index]),
              selected: _selectedIndex == index,
              onTap: () {
                _onItemTapped(index);
                Navigator.pop(context);
              },
            );
          }),
          const Divider(thickness: 1.5),
          ListTile(
            title: const Text('Logout'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
