import 'package:flutter/material.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';

class SuppliesNeededPage extends StatefulWidget {
  @override
  _SuppliesNeededPageState createState() => _SuppliesNeededPageState();
}

class _SuppliesNeededPageState extends State<SuppliesNeededPage>
    with AutomaticKeepAliveClientMixin {
  late Map<String, dynamic> neededSupplies;
  late String selectedFood;
  late String selectedConstructionMaterials;
  late String selectedHygieneProducts;
  late String selectedMedicineFirstAid;
  late SurveyDataProvider surveyDataProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    SurveyDataProvider surveyDataProvider =
        Provider.of<SurveyDataProvider>(context, listen: false);

    neededSupplies = surveyDataProvider.neededSupplies ?? {};

    selectedFood = neededSupplies['Food']?.toString() ?? 'Unknown';
    selectedConstructionMaterials =
        neededSupplies['Construction Materials for Building Rehab']
                ?.toString() ??
            'Unknown';
    selectedHygieneProducts =
        neededSupplies['Hygiene Products']?.toString() ?? 'Unknown';
    selectedMedicineFirstAid =
        neededSupplies['Medicine/First Aid']?.toString() ?? 'Unknown';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Current Needed Supplies:',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.shopping_basket_rounded)
                  ],
                ),
                SizedBox(height: 16.0),
                buildSupplyTextInput(
                  'Tents',
                  neededSupplies['Tents']?.toString() ?? '',
                  (value) =>
                      surveyDataProvider.updateNeededSupplies('Tents', value),
                ),
                buildSupplyTextInput(
                  'Blankets',
                  neededSupplies['Blankets']?.toString() ?? '',
                  (value) => surveyDataProvider.updateNeededSupplies(
                      'Blankets', value),
                ),
                buildSupplyTextInput(
                  'Cushions',
                  neededSupplies['Cushions']?.toString() ?? '',
                  (value) => surveyDataProvider.updateNeededSupplies(
                      'Cushions', value),
                ),
                buildSupplyTextInput(
                  'Pallets',
                  neededSupplies['Pallets']?.toString() ?? '',
                  (value) =>
                      surveyDataProvider.updateNeededSupplies('Pallets', value),
                ),
                buildDropdownWithStatus(
                  'Food',
                  selectedFood,
                  'Food',
                  neededSupplies,
                  ['Unknown', 'Low', 'Moderate', 'High'],
                  (value) {
                    setState(() {
                      selectedFood = value!;
                      neededSupplies['Food'] = value;
                      surveyDataProvider.updateNeededSupplies('Food', value);
                    });
                  },
                ),
                buildDropdownWithStatus(
                  'Construction Materials for Building Rehab',
                  selectedConstructionMaterials,
                  'Construction Materials for Building Rehab',
                  neededSupplies,
                  ['Unknown', 'Low', 'Moderate', 'High'],
                  (value) {
                    setState(() {
                      selectedConstructionMaterials = value!;
                      neededSupplies[
                          'Construction Materials for Building Rehab'] = value;
                      surveyDataProvider.updateNeededSupplies(
                          'Construction Materials for Building Rehab', value);
                    });
                  },
                ),
                buildDropdownWithStatus(
                  'Hygiene Products',
                  selectedHygieneProducts,
                  'Hygiene Products',
                  neededSupplies,
                  ['Unknown', 'Low', 'Moderate', 'High'],
                  (value) {
                    setState(() {
                      selectedHygieneProducts = value!;
                      neededSupplies['Hygiene Products'] = value;
                      surveyDataProvider.updateNeededSupplies(
                          'Hygiene Products', value);
                    });
                  },
                ),
                buildDropdownWithStatus(
                  'Medicine/First Aid',
                  selectedMedicineFirstAid,
                  'Medicine/First Aid',
                  neededSupplies,
                  ['Unknown', 'Low', 'Moderate', 'High'],
                  (value) {
                    setState(() {
                      selectedMedicineFirstAid = value!;
                      neededSupplies['Medicine/First Aid'] = value;
                      surveyDataProvider.updateNeededSupplies(
                          'Medicine/First Aid', value);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSupplyTextInput(
    String supplyType,
    String value,
    ValueChanged<String> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          supplyType,
          style: TextStyle(fontSize: 16.0),
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter amount for $supplyType',
          ),
          initialValue: value,
          onChanged: onChanged,
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget buildDropdownWithStatus(
    String supplyType,
    String selectedStatus,
    String supplyKey,
    Map<String, dynamic> supplies,
    List<String> statusOptions,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          supplyType,
          style: TextStyle(fontSize: 16.0),
        ),
        DropdownButtonFormField<String>(
          value: selectedStatus,
          onChanged: onChanged,
          items: statusOptions.map((status) {
            return DropdownMenuItem<String>(
              value: status,
              child: Text(status),
            );
          }).toList(),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
