import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StepCounterScreen extends StatefulWidget {
  const StepCounterScreen({super.key});

  @override
  State<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen> {
  static const _channel = MethodChannel('com.example.healthkit/callback');

  int _callbackCount = 0;
  double _stepsToday = 0;
  double _stepsSinceCampaignStart = 0;

  final DateTime _campaignStart = DateTime(2025, 6, 14);

  @override
  void initState() {
    super.initState();
    _setupNativeCallback();
    _fetchStepsToday();
    _fetchStepsSinceCampaignStart();
  }

  void _setupNativeCallback() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'stepCountChanged') {
        setState(() {
          _callbackCount++;
        });
        _fetchStepsToday();
        _fetchStepsSinceCampaignStart();
      }
    });
  }

  Future<void> _fetchStepsToday() async {
    try {
      final steps = await _channel.invokeMethod<double>('getStepsToday');
      setState(() {
        _stepsToday = steps ?? 0;
      });
    } catch (e) {
      debugPrint('Error fetching steps today: $e');
    }
  }

  Future<void> _fetchStepsSinceCampaignStart() async {
    try {
      final secondsSinceEpoch = _campaignStart.millisecondsSinceEpoch / 1000;
      final steps = await _channel.invokeMethod<double>(
        'getStepsFromCampaignStart',
        secondsSinceEpoch,
      );
      setState(() {
        _stepsSinceCampaignStart = steps ?? 0;
      });
    } catch (e) {
      debugPrint('Error fetching campaign steps: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HealthKit Step Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.directions_walk, size: 64),
            const SizedBox(height: 16),
            Text(
              'Steps Today: ${_stepsToday.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 8),
            Text(
              'Steps Since Campaign Start: ${_stepsSinceCampaignStart.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 16),
            Text(
              'HealthKit Callbacks: $_callbackCount',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _fetchStepsToday();
                _fetchStepsSinceCampaignStart();
              },
              child: const Text('Refresh Steps Manually'),
            ),
          ],
        ),
      ),
    );
  }
}