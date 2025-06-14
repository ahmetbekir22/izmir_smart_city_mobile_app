import 'dart:io';
// import 'package:path_provider/path_provider.dart';
import 'package:flutter_test/flutter_test.dart';

class TestResult {
  final String name;
  final bool success;
  final String? error;

  TestResult({required this.name, required this.success, this.error});
}

class TestReportGenerator {
  static void generateReport(List<TestResult> results) {
    final totalTests = results.length;
    final successfulTests = results.where((r) => r.success).length;
    final successRate = (successfulTests / totalTests * 100).toStringAsFixed(1);

    var html = '''
<!DOCTYPE html>
<html>
<head>
    <title>Test Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .summary {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 4px;
        }
        .success-rate {
            font-size: 24px;
            font-weight: bold;
            color: #28a745;
            text-align: center;
            margin: 20px 0;
        }
        .test-list {
            margin-top: 20px;
        }
        .test-item {
            padding: 10px;
            margin: 5px 0;
            border-radius: 4px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
        }
        .failure {
            background-color: #f8d7da;
            color: #721c24;
        }
        .error-details {
            margin-top: 5px;
            font-size: 0.9em;
            color: #721c24;
            background-color: #f8d7da;
            padding: 10px;
            border-radius: 4px;
            white-space: pre-wrap;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Test Report</h1>
        
        <div class="summary">
            <div class="success-rate">
                Success Rate: $successRate%
            </div>
        </div>

        <div class="test-list">
''';

    for (var result in results) {
      html += '''
            <div class="test-item ${result.success ? 'success' : 'failure'}">
                <strong>${result.name}</strong>
                ${result.error != null ? '<div class="error-details">${result.error}</div>' : ''}
            </div>
''';
    }

    html += '''
        </div>
    </div>
</body>
</html>
''';

    File('test_report.html').writeAsStringSync(html);
  }
}
