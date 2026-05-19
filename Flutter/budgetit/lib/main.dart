import 'package:budgetit/views/transaction_manager/transaction.manager.dart';
import 'package:flutter/material.dart';
import 'screens/dashboard.dart';
import 'shared/widgets/main_scaffold.dart';
import 'shared/widgets/main_appbar.dart';
import 'package:budgetit/utils/app_colour.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

    debugShowCheckedModeBanner: false,

    title: 'BudgetIt',

    theme: ThemeData(

      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
      ),

      useMaterial3: true,
    ),

    initialRoute: '/',

    routes: {
      '/transaction_manager': (context) =>
          const TransactionManager(),
    },

    home: const DashboardPage(),  

    );
  }
}

// Separate stateful widget for the home screen with bottom navigation
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List of pages to display for each destination
  final List<Widget> _pages = [
    const MainScaffold(),           // Home page (index 0)
    const TransactionManager(),     // Transaction Manager (index 1)
    const ReportsPage(),            // Reports page – create this widget
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppbar(),
      body: _pages[_selectedIndex],   // Show the selected page
      bottomNavigationBar: Container(
  decoration: BoxDecoration(
  
    borderRadius: BorderRadius.all(Radius.circular(10)),
    border: Border(top: BorderSide(color: MyColours().secondary, width: 1.5))
    
    
  ),
  child: NavigationBar(
    selectedIndex: _selectedIndex,
    backgroundColor: MyColours().background,
    indicatorColor: MyColours().secondary,
  
    onDestinationSelected: _onDestinationSelected,

  
 
    destinations: const [
      NavigationDestination(
         // Empty widget to remove label space 
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: '',
      ),

      NavigationDestination(
        icon: Icon(Icons.attach_money),
        selectedIcon: Icon(Icons.attach_money),
        label: '',

      ),
      NavigationDestination(
        icon: Icon(Icons.pie_chart_outline),
        selectedIcon: Icon(Icons.pie_chart),
        label: '',
      ),
    ],
  ),
),
    );
  }
}

// Temporary placeholder for Reports page – replace with your actual widget
class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Reports Page - Coming Soon'),
    );
  }
}