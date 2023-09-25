import 'package:flutter/material.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';

class SuppliesAvailablePage extends StatefulWidget {
  @override
  _SuppliesAvailablePageState createState() => _SuppliesAvailablePageState();
}

class _SuppliesAvailablePageState extends State<SuppliesAvailablePage>
    with AutomaticKeepAliveClientMixin {
  late Map<String, dynamic> currentSupplies;
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

    currentSupplies = surveyDataProvider.currentSupplies ?? {};

    selectedFood = currentSupplies['Food']?.toString() ?? 'Unknown';
    selectedConstructionMaterials =
        currentSupplies['Construction Materials for Building Rehab']
                ?.toString() ??
            'Unknown';
    selectedHygieneProducts =
        currentSupplies['Hygiene Products']?.toString() ?? 'Unknown';
    selectedMedicineFirstAid =
        currentSupplies['Medicine/First Aid']?.toString() ?? 'Unknown';

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
                      'Current Available Supplies:',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.shopping_basket_sharp)
                  ],
                ),
                SizedBox(height: 16.0),
                buildSupplyTextInput(
                  'Tents',
                  currentSupplies['Tents']?.toString() ?? '',
                  (value) => surveyDataProvider.updateCurrentSupplies({
                    'Tents': value,
                  }),
                ),
                buildSupplyTextInput(
                  'Blankets',
                  currentSupplies['Blankets']?.toString() ?? '',
                  (value) => surveyDataProvider.updateCurrentSupplies({
                    'Blankets': value,
                  }),
                ),
                buildSupplyTextInput(
                  'Cushions',
                  currentSupplies['Cushions']?.toString() ?? '',
                  (value) => surveyDataProvider.updateCurrentSupplies({
                    'Cushions': value,
                  }),
                ),
                buildSupplyTextInput(
                  'Pallets',
                  currentSupplies['Pallets']?.toString() ?? '',
                  (value) => surveyDataProvider.updateCurrentSupplies({
                    'Pallets': value,
                  }),
                ),
                buildDropdownWithStatus(
                  'Food',
                  selectedFood,
                  'Food',
                  currentSupplies,
                  ['Unknown', 'Low', 'Moderate', 'High'],
                  (value) {
                    setState(() {
                      selectedFood = value!;
                      currentSupplies['Food'] = value;
                    });
                  },
                ),
                buildDropdownWithStatus(
                  'Construction Materials for Building Rehab',
                  selectedConstructionMaterials,
                  'Construction Materials for Building Rehab',
                  currentSupplies,
                  ['Unknown', 'Low', 'Moderate', 'High'],
                  (value) {
                    setState(() {
                      selectedConstructionMaterials = value!;
                      currentSupplies[
                          'Construction Materials for Building Rehab'] = value;
                    });
                  },
                ),
                buildDropdownWithStatus(
                  'Hygiene Products',
                  selectedHygieneProducts,
                  'Hygiene Products',
                  currentSupplies,
                  ['Unknown', 'Low', 'Moderate', 'High'],
                  (value) {
                    setState(() {
                      selectedHygieneProducts = value!;
                      currentSupplies['Hygiene Products'] = value;
                    });
                  },
                ),
                buildDropdownWithStatus(
                  'Medicine/First Aid',
                  selectedMedicineFirstAid,
                  'Medicine/First Aid',
                  currentSupplies,
                  ['Unknown', 'Low', 'Moderate', 'High'],
                  (value) {
                    setState(() {
                      selectedMedicineFirstAid = value!;
                      currentSupplies['Medicine/First Aid'] = value;
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
