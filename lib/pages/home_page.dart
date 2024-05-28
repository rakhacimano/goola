import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goola/databases/glucose_database.dart';
import 'package:goola/models/glucose.dart';
import 'package:goola/pages/glucose_detail_page.dart';
import 'package:goola/pages/history_chart_page.dart';
import 'package:goola/widgets/glucose_history_card_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:goola/pages/add_edit_glucose_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Glucose> _glucoses = [];
  var _isLoading = false;

  Future<void> _refreshNotes() async {
    setState(() {
      _isLoading = true;
    });

    _glucoses = await GlucoseDatabase.instance.getAllGlucoses();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, _refreshNotes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _topBar(),
                const SizedBox(height: 20),
                _greetings(),
                const SizedBox(height: 20),
                _info(context),
                const SizedBox(height: 32),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : _glucoses.isEmpty
                        ? const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Glucose Data is Empty!'),
                          ],
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Glucose History',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HistoryChartPage(
                                          glucoseList: _glucoses,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Iconsax.chart,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4,),
                                      Text(
                                        'See History Chart',
                                        style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 12),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _glucoses.length,
                              itemBuilder: (context, index) {
                                final glucose = _glucoses.reversed.toList()[index];
                                return GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GlucoseDetailPage(
                                          id: glucose.id!,
                                        ),
                                      ),
                                    );
                                    _refreshNotes();
                                  },
                                  child: GlucoseHistoryCardWidget(
                                    glucose: glucose,
                                    index: index,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        
                const SizedBox(height: 90),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddEditGlucosePage()));
          _refreshNotes();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: const Color(0xFFFEED55),
        child: const Icon(
          Iconsax.add,
          size: 48,
        ),
      ),
    );
  }

  Row _topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/images/logo_app.png',
          height: 40,
        ),
        Image.network(
          'https://avatars.githubusercontent.com/u/37649999?v=4',
          height: 40,
          width: 40,
        ),
      ],
    );
  }

  Widget _greetings() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Glad you are here,',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              'Fulan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }

  Widget _info(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCardInfo(context, const Color(0xFFFFFBDD), 'Peak of Glucose',
            Iconsax.trend_up, _getHighestGlucoseAmount().toStringAsFixed(0)),
        _buildCardInfo(context, const Color(0xFFFFFFFF), 'Lowest of Glucose',
            Iconsax.trend_down, _getLowestGlucoseAmount().toStringAsFixed(0)),
      ],
    );
  }

  double _getHighestGlucoseAmount() {
    double highestAmount = 0;
    for (var glucose in _glucoses) {
      double amount = double.parse(glucose.amount);
      if (amount > highestAmount) {
        highestAmount = amount;
      }
    }
    return highestAmount;
  }

  double _getLowestGlucoseAmount() {
    double lowestAmount = double.infinity;
    for (var glucose in _glucoses) {
      double amount = double.parse(glucose.amount);
      if (amount < lowestAmount) {
        lowestAmount = amount;
      }
    }
    return lowestAmount;
  }

  Widget _buildCardInfo(BuildContext context, Color? bgColor, String? info,
      IconData? icon, String? amount) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF0F1511),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF0F1511),
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(8, 8),
          ),
        ],
      ),
      width: MediaQuery.of(context).size.width * 0.4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  amount!,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8BB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFEF499),
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFFEF177),
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon!,
                    size: 20,
                  ),
                )
              ],
            ),
            const Text(
              'mg/dL',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              info!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
