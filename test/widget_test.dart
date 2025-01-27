// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:my_project/main.dart';

// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(const MyApp());

//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);

//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();

//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:my_project/main.dart';

// void main() {
//   testWidgets('LoanApp widget test', (WidgetTester tester) async {
//     // Build the LoanApp and trigger a frame.
//     await tester.pumpWidget(LoanApp());

//     // Verify that the loading spinner is displayed initially.
//     expect(find.byType(CircularProgressIndicator), findsOneWidget);

//     // Simulate the configuration fetch and trigger rebuild.
//     await tester.pumpAndSettle();

//     // Verify that the text field and slider are present after the loading spinner disappears.
//     expect(find.byType(TextField), findsOneWidget);
//     expect(find.byType(Slider), findsOneWidget);

//     // Enter a value in the Annual Business Revenue text field.
//     await tester.enterText(find.byType(TextField), '300000');
//     await tester.pump();

//     // Verify that the slider updates with a new maximum value.
//     final slider = tester.widget<Slider>(find.byType(Slider));
//     expect(slider.max, equals(100000)); // 1/3 of 300000

//     // Interact with the slider and update its value.
//     await tester.tap(find.byType(Slider));
//     await tester.pump();

//     // Verify that the selected loan amount is displayed correctly.
//     expect(find.text('Selected Loan Amount: \$0.00'), findsNothing);
//   });
// }
// Flutter loan calculator app with dynamic configuration from API
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(LoanApp());

class LoanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoanPage(),
    );
  }
}

class LoanPage extends StatefulWidget {
  @override
  _LoanPageState createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  late Map<String, dynamic> config;
  bool isLoading = true;

  double revenueAmount = 0.0;
  double loanAmount = 0.0;
  double revenuePercentage = 0.0;
  String frequency = "";
  int repaymentDelay = 0;

  @override
  void initState() {
    super.initState();
    fetchConfig();
  }

  Future<void> fetchConfig() async {
    final url = Uri.parse(
        'https://gist.githubusercontent.com/motgi/8fc373cbfccee534c820875ba20ae7b5/raw/7143758ff2caa773e651dc3576de57cc829339c0/config.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        config = responseData.firstWhere((element) => element is Map<String, dynamic>, orElse: () => {});
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load configuration');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Loan Calculator')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Loan Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField(
              label: config['label'] ?? 'Enter Value',
              placeholder: config['placeholder'] ?? 'Enter Placeholder',
              onChanged: (value) {
                setState(() {
                  revenueAmount = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 16.0),
            buildSlider(),
            const SizedBox(height: 16.0),
            buildResults(),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required String placeholder,
    required Function(String) onChanged,
  }) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }

  Widget buildSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Loan Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Slider(
          value: loanAmount,
          min: 0,
          max: revenueAmount / 3,
          divisions: (revenueAmount / 3000).round(),
          label: loanAmount.toStringAsFixed(0),
          onChanged: (value) {
            setState(() {
              loanAmount = value;
            });
          },
        ),
        Text('Selected Loan Amount: \$${loanAmount.toStringAsFixed(2)}')
      ],
    );
  }

  Widget buildResults() {
    final fees = loanAmount * 0.5; // Example: using 50% as fee percentage
    final totalRevenueShare = loanAmount + fees;
    final expectedTransfers = frequency == 'weekly'
        ? (totalRevenueShare * 52 / (revenueAmount * revenuePercentage)).ceil()
        : (totalRevenueShare * 12 / (revenueAmount * revenuePercentage)).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('Fees: \$${fees.toStringAsFixed(2)}'),
        Text('Total Revenue Share: \$${totalRevenueShare.toStringAsFixed(2)}'),
        Text('Expected Transfers: $expectedTransfers'),
        Text('Repayment Delay: $repaymentDelay days'),
      ],
    );
  }
}
