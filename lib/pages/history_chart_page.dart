import 'package:flutter/material.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/ordinal/bar.dart';
import 'package:goola/models/glucose.dart';

class HistoryChartPage extends StatelessWidget {
  final List<Glucose> glucoseList;

  const HistoryChartPage({
    super.key,
    required this.glucoseList,
  });

  @override
  Widget build(BuildContext context) {
    List<double> glucoseAmounts = glucoseList.map((glucose) => double.parse(glucose.amount)).toList();

    List<OrdinalData> ordinalDataList = [];
    for (int i = 0; i < glucoseAmounts.length; i++) {
      ordinalDataList.add(OrdinalData(domain: 'Day ${i+1}', measure: glucoseAmounts[i]));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History Chart',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AspectRatio(
                aspectRatio: 9 / 12,
                child: DChartBarO(
                  groupList: [
                    OrdinalGroup(
                      id: '1',
                      data: ordinalDataList,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
