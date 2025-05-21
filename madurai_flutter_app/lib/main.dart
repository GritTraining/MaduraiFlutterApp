import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Day 1 Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  // Example of using different variable types
  final String appTitle = 'Flutter Fundamentals';
  final int demoCount = 5;
  final bool isLearning = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        backgroundColor: Colors.blue,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome header
            _buildWelcomeHeader(),
            SizedBox(height: 20),
            
            // Demo cards in a column
            _buildDemoCard(
              'Text Examples',
              'Different text styles and formatting',
              Icons.text_fields,
              Colors.orange,
            ),
            SizedBox(height: 16),
            
            // Row with multiple cards
            Row(
              children: [
                Expanded(
                  child: _buildDemoCard(
                    'Layout',
                    'Rows & Columns',
                    Icons.view_agenda,
                    Colors.green,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildDemoCard(
                    'Containers',
                    'Styling & Decoration',
                    Icons.crop_square,
                    Colors.purple,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            // Image section
            _buildImageSection(),
            SizedBox(height: 20),
            
            // Progress indicator
            _buildProgressSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Debugging example
          debugPrint('FAB pressed!');
          _showDebugInfo(context);
        },
        child: Icon(Icons.info),
        tooltip: 'Show Debug Info',
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade300, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Welcome to Flutter!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Day 1: Fundamentals',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoCard(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(
            'Image Examples',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Placeholder for network image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade300),
                ),
                child: Icon(
                  Icons.image,
                  size: 40,
                  color: Colors.blue.shade600,
                ),
              ),
              // Circular avatar placeholder
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green.shade100,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.green.shade600,
                ),
              ),
              // Another image placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Icon(
                  Icons.photo,
                  size: 40,
                  color: Colors.orange.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Learning Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(isLearning ? demoCount : 0)}/$demoCount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: isLearning ? 0.4 : 0.0,
            backgroundColor: Colors.green.shade100,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
          ),
          SizedBox(height: 10),
          Text(
            isLearning ? 'Great job! Keep learning!' : 'Start your journey!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }

  void _showDebugInfo(BuildContext context) {
    // Example of debugging function
    final debugInfo = _getDebugInfo();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Debug Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('App Title: $appTitle'),
            Text('Demo Count: $demoCount'),
            Text('Is Learning: $isLearning'),
            Text('Screen Size: ${MediaQuery.of(context).size}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getDebugInfo() {
    // Example function that returns debug information
    return {
      'title': appTitle,
      'count': demoCount,
      'learning': isLearning,
      'timestamp': DateTime.now().toString(),
    };
  }
}

// Example of a separate class demonstrating OOP principles
class LearningProgress {
  String subject;
  int completed;
  int total;
  
  LearningProgress({
    required this.subject,
    required this.completed,
    required this.total,
  });
  
  double get percentage => (completed / total) * 100;
  
  bool get isComplete => completed >= total;
  
  void complete() {
    if (completed < total) {
      completed++;
    }
  }
  
  @override
  String toString() {
    return '$subject: $completed/$total (${percentage.toStringAsFixed(1)}%)';
  }
}