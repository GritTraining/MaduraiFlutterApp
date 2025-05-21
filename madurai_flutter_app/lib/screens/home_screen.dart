import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Assistant'),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            Center(
              child: Container(
                width: 150,
                height: 150,
                margin: const EdgeInsets.only(top: 24, bottom: 32),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.psychology,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            
            // Welcome text
            Text(
              'Welcome to Gemini Assistant',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your AI assistant powered by Google\'s Gemini language model. Ask questions, get creative responses, and more!',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Feature cards
            Text(
              'What can Gemini do?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    context,
                    Icons.help_outline,
                    'Answer Questions',
                    'Get information on virtually any topic'
                  ),
                  _buildFeatureCard(
                    context,
                    Icons.lightbulb_outline,
                    'Creative Writing',
                    'Generate stories, poems, and other creative text'
                  ),
                  _buildFeatureCard(
                    context,
                    Icons.translate,
                    'Translation',
                    'Translate between different languages'
                  ),
                  _buildFeatureCard(
                    context,
                    Icons.code,
                    'Programming Help',
                    'Get coding examples and explanations'
                  ),
                ],
              ),
            ),
            
            // Start chat button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to chat screen using bottom navigation
                  DefaultTabController.of(context)?.animateTo(1);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  minimumSize: const Size(double.infinity, 54),
                ),
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text(
                  'Start Chatting',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}