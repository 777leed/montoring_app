import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:montoring_app/components/MyBanner.dart';
import 'package:montoring_app/components/myHeader.dart';
import 'package:montoring_app/models/MyTrees.dart';
import 'package:montoring_app/pages/Survey/SurveyData.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TreesSurvey extends StatefulWidget {
  @override
  _TreesSurveyState createState() => _TreesSurveyState();
}

class _TreesSurveyState extends State<TreesSurvey>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController treeTypeController = TextEditingController();
  final TextEditingController treeNumberController = TextEditingController();

  List<MyTrees> treesList = [];

  void saveTrees() {
    MyTrees newTrees = MyTrees(
        type: treeTypeController.text,
        number: int.tryParse(treeNumberController.text) ?? 0);
    setState(() {
      treesList.add(newTrees);
    });
    SurveyDataProvider surveyDataProvider =
        Provider.of<SurveyDataProvider>(context, listen: false);
    surveyDataProvider.updateTrees(treesList);
    treeTypeController.clear();
    treeNumberController.clear();
  }

  @override
  void dispose() {
    treeTypeController.dispose();
    treeNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: myHeader(title: l.treesSurveyTitle, icon: Icon(LineIcons.tree)),
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
                    title: "Please insert the details below",
                    img: "Assets/images/forest.png"),
                TextField(
                  controller: treeTypeController,
                  decoration: InputDecoration(labelText: l.treeTypeLabel),
                ),
                TextField(
                  controller: treeNumberController,
                  decoration: InputDecoration(labelText: 'Number of Trees'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: saveTrees,
                  child: Text('Save Trees'),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Saved Trees:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 200.0,
                  child: Consumer<SurveyDataProvider>(
                    builder: (context, surveyData, child) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: surveyData.trees.length,
                        itemBuilder: (context, index) {
                          final trees = surveyData.trees[index];
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Container(
                              width: 200.0,
                              child: ListTile(
                                title: Text(
                                  '${l.treeTypeLabel}: ${trees.type}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  '${l.treeNumberLabel}: ${trees.number.toString()}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
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
