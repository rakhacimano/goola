import 'package:flutter/material.dart';
import 'package:goola/databases/glucose_database.dart';
import 'package:goola/models/glucose.dart';
import 'package:goola/widgets/custom_text_field_widget.dart';

class AddEditGlucosePage extends StatefulWidget {
  const AddEditGlucosePage({super.key, this.glucose});
  final Glucose? glucose;

  @override
  State<AddEditGlucosePage> createState() => _AddEditGlucosePageState();
}

class _AddEditGlucosePageState extends State<AddEditGlucosePage> {
  late String _amount;
  final _formKey = GlobalKey<FormState>();
  var _isUpdateForm = false;

  @override
  void initState() {
    super.initState();
    _amount = widget.glucose?.amount ?? '';
    _isUpdateForm = widget.glucose != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isUpdateForm ? 'Edit Glucose' : 'Add Glucose',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 24,),
                _banner(),
                const SizedBox(height: 32,),
                Column(
                  children: [
                    _customTextField(),
                    const SizedBox(height: 24,),
                    _buildButtonSave(),
                  ],
                ),
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget _buildButtonSave() {
    return ElevatedButton(
        onPressed: () async {
          final isValid = _formKey.currentState?.validate() ?? true;
          if (isValid) {
            if (_isUpdateForm) {
              await _updateGlucose();
            } else {
              await _addGlucose();
            }
            Navigator.pop(context);
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFFEED55),
          foregroundColor: const Color(0xFF0F1511),
          minimumSize: const Size(double.infinity, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 24, right: 24),
          child: Text(
            'Save Glucose',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
  }

  Widget _banner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBDD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFEED55),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFFFF8BB),
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: const Row(
        children: [
          Image(
            image: AssetImage(
              'assets/images/img_peak_glucose.png'
            ),
            width: 56,
          ),
          SizedBox(width: 16,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Glucose Tracking',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 4,),
              Text(
                'Record & set your glucose',
                style: TextStyle(
                  fontSize: 14,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _customTextField() {
    return CustomTextField(
      onChangeAmount: (value) {
      setState(() {
        _amount = value;
      });
      },
      amount: _amount,
      hint: _isUpdateForm ? widget.glucose?.amount : 'Input Glucose',
      label: 'Glucose',
    );
  }

  Future<void> _addGlucose() async {
    final glucose = Glucose(
        amount: _amount,
        createdTime: DateTime.now());
    await GlucoseDatabase.instance.create(glucose);
  }

  Future<void> _updateGlucose() async {
    final updateGlucose = Glucose(
        id: widget.glucose?.id,
        amount: _amount,
        createdTime: DateTime.now());
    await GlucoseDatabase.instance.updateGlucose(updateGlucose);
  }
}