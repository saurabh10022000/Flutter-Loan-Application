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
  int repaymentDelay = 30;
  List<Map<String, dynamic>> useOfFunds = [];
  String frequency = "Monthly";

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
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Loan Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextField(
                          label: 'What is your annual business revenue?',
                          placeholder: config['placeholder'] ?? 'Enter Value',
                          onChanged: (value) {
                            setState(() {
                              revenueAmount = double.tryParse(value) ?? 0.0;
                            });
                          },
                        ),
                        const SizedBox(height: 16.0),
                        buildRepaymentDelayDropdown(),
                        const SizedBox(height: 16.0),
                        Center(
                          child: Text(
                            'What will you use the funds for?',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        buildUseOfFunds(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildLoanAmountInput(),
                        const SizedBox(height: 16.0),
                        buildFrequencySelector(),
                        const SizedBox(height: 16.0),
                        buildResults(),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text('BACK'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text('NEXT'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoanAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Loan Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter Desired Loan Amount',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              loanAmount = double.tryParse(value) ?? 0.0;
            });
          },
        ),
      ],
    );
  }

  Widget buildFrequencySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Revenue Shared Frequency:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: const Text('Monthly'),
                leading: Radio<String>(
                  value: 'Monthly',
                  groupValue: frequency,
                  onChanged: (value) {
                    setState(() {
                      frequency = value!;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                title: const Text('Weekly'),
                leading: Radio<String>(
                  value: 'Weekly',
                  groupValue: frequency,
                  onChanged: (value) {
                    setState(() {
                      frequency = value!;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildRepaymentDelayDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Desired Repayment Delay:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        DropdownButton<int>(
          value: repaymentDelay,
          items: [30, 60, 90]
              .map((e) => DropdownMenuItem<int>(
                    value: e,
                    child: Text('$e days'),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              repaymentDelay = value!;
            });
          },
        )
      ],
    );
  }

  Widget buildUseOfFunds() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...useOfFunds.map((fund) => Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: fund['type'],
                    items: [
                      'Marketing',
                      'Personnel',
                      'Working Capital',
                      'Inventory',
                      'Machinery/Equipment',
                      'Other'
                    ]
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type, overflow: TextOverflow.ellipsis),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        fund['type'] = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Description'),
                    controller: TextEditingController(text: fund['description']),
                    onChanged: (value) => fund['description'] = value,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Amount'),
                    keyboardType: TextInputType.number,
                    controller: TextEditingController(text: fund['amount']?.toString()),
                    onChanged: (value) => fund['amount'] = double.tryParse(value) ?? 0.0,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      useOfFunds.remove(fund);
                    });
                  },
                ),
              ],
            )),
        TextButton(
          onPressed: () {
            setState(() {
              useOfFunds.add({'type': 'Marketing', 'description': '', 'amount': 0.0});
            });
          },
          child: Text('Add Fund'),
        )
      ],
    );
  }

  Widget buildTextField({
    required String label,
    required String placeholder,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: placeholder,
            border: OutlineInputBorder(),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget buildResults() {
    final fees = loanAmount * 0.5; // Example: using 50% as fee percentage
    final totalRevenueShare = loanAmount + fees;

    final expectedTransfers = (revenueAmount > 0 && totalRevenueShare > 0)
        ? (frequency == 'Weekly')
            ? (totalRevenueShare * 52 / (revenueAmount * 0.0603)).ceil()
            : (totalRevenueShare * 12 / (revenueAmount * 0.0603)).ceil()
        : 0;

    final currentDate = DateTime.now();
    final expectedCompletionDate = (expectedTransfers > 0)
        ? currentDate.add(Duration(days: expectedTransfers * (frequency == 'Weekly' ? 7 : 30) + repaymentDelay))
        : currentDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Annual Business Revenue', style: TextStyle(fontSize: 16)),
            Text('\$${revenueAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Funding Amount', style: TextStyle(fontSize: 16)),
            Text('\$${loanAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Fees (50%)', style: TextStyle(fontSize: 16)),
            Text('\$${fees.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        Divider(thickness: 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Revenue Share', style: TextStyle(fontSize: 16)),
            Text('\$${totalRevenueShare.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Expected Transfers', style: TextStyle(fontSize: 16)),
            Text('$expectedTransfers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Expected Completion Date', style: TextStyle(fontSize: 16)),
            Text('${expectedCompletionDate.toLocal()}'.split(' ')[0],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
