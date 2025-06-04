import 'package:flutter/material.dart';
import 'advanced_performance_monitor.dart';
import 'advanced_performance_helper.dart';

class AdvancedExampleScreen extends StatelessWidget {
  const AdvancedExampleScreen({Key? key}) : super(key: key);

  Future<void> _simulateApiCall() async {
    await AdvancedPerformanceHelper().trackApiCall(
      endpoint: 'example_endpoint',
      apiCall: () async {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));
        return {'data': 'example'};
      },
      metadata: {
        'request_type': 'GET',
        'cache_enabled': 'true',
      },
    );
  }

  Future<void> _navigateToNextScreen(BuildContext context) async {
    await AdvancedPerformanceHelper().trackScreenTransition(
      fromScreen: 'advanced_example',
      toScreen: 'next_screen',
      transition: () async {
        // Simulate navigation
        await Future.delayed(const Duration(milliseconds: 500));
        // Navigate to next screen
        // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedPerformanceMonitor(
      screenName: 'advanced_example_screen',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Advanced Performance Test Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _simulateApiCall,
                child: const Text('Simulate API Call'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _navigateToNextScreen(context),
                child: const Text('Navigate to Next Screen'),
              ),
              const SizedBox(height: 20),
              const Text('This screen is wrapped with AdvancedPerformanceMonitor'),
            ],
          ),
        ),
      ),
    );
  }
} 