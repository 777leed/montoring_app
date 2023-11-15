import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:montoring_app/components/MyBanner.dart';
import 'package:montoring_app/components/myHeader.dart';
import 'package:montoring_app/models/MyNeeds.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NeedsSurvey extends StatefulWidget {
  @override
  _NeedsSurveyState createState() => _NeedsSurveyState();
}

class _NeedsSurveyState extends State<NeedsSurvey>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  late String selectedType;
  late String otherText;
  final TextEditingController commentController = TextEditingController();

  List<MyNeeds> needsList = [];
  @override
  void didChangeDependencies() {
    final l = AppLocalizations.of(context)!;
    selectedType = l.unknownText;
    otherText = l.otherType;
    super.didChangeDependencies();
  }

  void saveNeeds() {
    String type;
    if (selectedType == otherText) {
      type = typeController.text;
    } else {
      type = selectedType;
    }
    MyNeeds newNeeds = MyNeeds(
        name: nameController.text,
        quantity: int.tryParse(quantityController.text) ?? 0,
        needType: type,
        date: DateTime.now(),
        comment: commentController.text);
    setState(() {
      needsList.add(newNeeds);
    });
    SurveyDataProvider surveyDataProvider =
        Provider.of<SurveyDataProvider>(context, listen: false);
    surveyDataProvider.updateNeeds(needsList);
    nameController.clear();
    quantityController.clear();
    commentController.clear();
  }

  Widget buildDropdownWithStatus(
    String supplyType,
    String selectedStatus,
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
  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: myHeader(
            title: l.currentNeedsTitle, icon: Icon(LineIcons.shoppingBag)),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyBanner(
                    title: l.pleaseInsertDetails,
                    img: "Assets/images/export.png"),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: l.insertNameLabel),
                ),
                TextField(
                  controller: quantityController,
                  decoration:
                      InputDecoration(labelText: l.quantityInputLabelText),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: commentController,
                  decoration:
                      InputDecoration(labelText: l.commentInputLabelText),
                ),
                SizedBox(height: 16.0),
                buildDropdownWithStatus(
                  l.typeLabelText,
                  selectedType,
                  [
                    l.unknownText,
                    l.foodType,
                    l.hygieneType,
                    l.medicineType,
                    l.constructionType,
                    l.otherType
                  ],
                  (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                if (selectedType == otherText) ...[
                  TextField(
                    controller: typeController,
                    decoration: InputDecoration(labelText: l.typeLabelText),
                  ),
                ],
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: saveNeeds,
                  child: Text(l.saveNeedsButton),
                ),
                SizedBox(height: 16.0),
                Text(
                  l.savedItemsTitle,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                SizedBox(
                  height: 200.0,
                  child: Consumer<SurveyDataProvider>(
                    builder: (context, surveyData, child) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: surveyData.needs.map((needs) {
                            DateFormat formatter = DateFormat('dd-MM-yyyy');
                            return Card(
                              margin: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                width: 200.0,
                                child: ListTile(
                                  title: Text(
                                    '${l.needNameText} ${needs.name}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${l.quantityLabel}: ${needs.quantity.toString()}'),
                                      Text(
                                        '${l.needTypeInputLabelText}: ${needs.needType}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${l.dateText} ${formatter.format(needs.date)}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${l.commentInputLabelText}: ${needs.comment}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
