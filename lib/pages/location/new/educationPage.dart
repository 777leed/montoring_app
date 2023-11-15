import 'package:flutter/material.dart';
import 'package:montoring_app/models/Place.dart';
import 'package:montoring_app/models/EducationStatistics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EducationStatisticsPage extends StatefulWidget {
  final Place? place;
  final String? id;

  const EducationStatisticsPage({Key? key, this.place, required this.id})
      : super(key: key);

  @override
  State<EducationStatisticsPage> createState() =>
      _EducationStatisticsPageState();
}

class _EducationStatisticsPageState extends State<EducationStatisticsPage> {
  EducationStatistics? educationStatistics;
  late AppLocalizations l;

  @override
  void initState() {
    super.initState();
    fetchEducationStatisticsFromFirestore();
  }

  @override
  void didChangeDependencies() {
    l = AppLocalizations.of(context)!;
    super.didChangeDependencies();
  }

  Future<void> fetchEducationStatisticsFromFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final placeDocument =
          await firestore.collection('places').doc(widget.id).get();

      if (placeDocument.exists) {
        final educationStatisticsData =
            placeDocument.data()?['educationStatistics'];

        if (educationStatisticsData != null &&
            educationStatisticsData is Map<String, dynamic>) {
          final educationStatistics =
              EducationStatistics.fromMap(educationStatisticsData);
          setState(() {
            this.educationStatistics = educationStatistics;
          });
        } else {
          setState(() {
            this.educationStatistics = EducationStatistics(
              numberOfLiterateMen: 0,
              numberOfLiterateWomen: 0,
              numberOfPostGraduateMen: 0,
              numberOfPostGraduateWomen: 0,
              numberOfBaccalaureateMen: 0,
              numberOfBaccalaureateWomen: 0,
              numberOfMiddleSchoolGraduateMen: 0,
              numberOfMiddleSchoolGraduateWomen: 0,
              numberOfPrimarySchoolGraduateMen: 0,
              numberOfPrimarySchoolGraduateWomen: 0,
              numberOfIlliterateMen: 0,
              numberOfIlliterateWomen: 0,
              hasSchool: false,
            );
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading education statistics data from Firestore: $e');
    }
  }

  void _showEducationStatisticsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l.educationStatistics),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildTextField(
                  l.literate + l.menLabelText,
                  educationStatistics?.numberOfLiterateMen.toString() ?? "0",
                  (value) {
                    setState(() {
                      educationStatistics?.numberOfLiterateMen =
                          int.tryParse(value) ?? 0;
                    });
                  },
                ),
                _buildTextField(
                  l.literate + l.womenLabelText,
                  educationStatistics?.numberOfLiterateWomen.toString() ?? "0",
                  (value) {
                    setState(() {
                      educationStatistics?.numberOfLiterateWomen =
                          int.tryParse(value) ?? 0;
                    });
                  },
                ),
                _buildTextField(
                  l.postGraduate + l.menLabelText,
                  educationStatistics?.numberOfPostGraduateMen.toString() ??
                      "0",
                  (value) {
                    setState(() {
                      educationStatistics?.numberOfPostGraduateMen =
                          int.tryParse(value) ?? 0;
                    });
                  },
                ),
                _buildTextField(
                  l.postGraduate + l.womenLabelText,
                  educationStatistics?.numberOfPostGraduateWomen.toString() ??
                      "0",
                  (value) {
                    setState(() {
                      educationStatistics?.numberOfPostGraduateWomen =
                          int.tryParse(value) ?? 0;
                    });
                  },
                ),
                _buildTextField(
                  l.baccalaureate + l.menLabelText,
                  educationStatistics?.numberOfBaccalaureateMen.toString() ??
                      "0",
                  (value) {
                    setState(() {
                      educationStatistics?.numberOfBaccalaureateMen =
                          int.tryParse(value) ?? 0;
                    });
                  },
                ),
                _buildTextField(
                  l.baccalaureate + l.womenLabelText,
                  educationStatistics?.numberOfBaccalaureateWomen.toString() ??
                      "0",
                  (value) {
                    setState(() {
                      educationStatistics?.numberOfBaccalaureateWomen =
                          int.tryParse(value) ?? 0;
                    });
                  },
                ),
                _buildTextField(
                  l.middleSchool + l.menLabelText,
                  educationStatistics?.numberOfMiddleSchoolGraduateMen
                          .toString() ??
                      "0",
                  (value) {
                    setState(() {
                      educationStatistics?.numberOfMiddleSchoolGraduateMen =
                          int.tryParse(value) ?? 0;
                    });
                  },
                ),
                _buildTextField(
                  l.middleSchool + l.womenLabelText,
                  educationStatistics?.numberOfMiddleSchoolGraduateWomen
                          .toString() ??
                      "0",
                  (value) {
                    setState(() {
                      educationStatistics?.numberOfMiddleSchoolGraduateWomen =
                          int.tryParse(value) ?? 0;
                    });
                  },
                ),
                _buildTextField(
                  l.primarySchool + l.menLabelText,
                  educationStatistics?.numberOfPrimarySchoolGraduateMen
                          .toString() ??
                      "0",
                  (value) {
                    setState(() {
                      educationStatistics?.numberOfPrimarySchoolGraduateMen =
                          int.tryParse(value) ?? 0;
                    });
                  },
                ),
                _buildTextField(
                  l.primarySchool + l.womenLabelText,
                  educationStatistics?.numberOfPrimarySchoolGraduateWomen
                          .toString() ??
                      "0",
                  (value) {
                    setState(() {
                      educationStatistics?.numberOfPrimarySchoolGraduateWomen =
                          int.tryParse(value) ?? 0;
                    });
                  },
                ),
                _buildTextField(
                  l.illiterate + l.menLabelText,
                  educationStatistics?.numberOfIlliterateMen.toString() ?? "0",
                  (value) {
                    setState(() {
                      educationStatistics?.numberOfIlliterateMen =
                          int.tryParse(value) ?? 0;
                    });
                  },
                ),
                _buildTextField(
                  l.illiterate + l.womenLabelText,
                  educationStatistics?.numberOfIlliterateWomen.toString() ??
                      "0",
                  (value) {
                    setState(() {
                      educationStatistics?.numberOfIlliterateWomen =
                          int.tryParse(value) ?? 0;
                    });
                  },
                ),
                _buildCheckboxField(
                  l.schoolAvailability,
                  educationStatistics?.hasSchool ?? false,
                  (value) {
                    setState(() {
                      educationStatistics?.hasSchool = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _updateEducationStatistics();
                Navigator.of(context).pop();
              },
              child: Text(l.update),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCheckboxField(
      String labelText, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(labelText),
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTextField(
      String labelText, String value, ValueChanged<String> onChanged) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: labelText),
      onChanged: onChanged,
      controller: TextEditingController(text: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l.educationStatistics),
      ),
      body: educationStatistics != null
          ? Padding(
              padding: const EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _buildEducationStatisticsSection(
                        l.literate, Icons.menu_book, [
                      _buildEducationStatisticsTile(l.menLabelText,
                          educationStatistics?.numberOfLiterateMen ?? 0),
                      _buildEducationStatisticsTile(l.womenLabelText,
                          educationStatistics?.numberOfLiterateWomen ?? 0),
                    ]),
                    _buildEducationStatisticsSection(
                        l.postGraduate, Icons.menu_book, [
                      _buildEducationStatisticsTile(l.menLabelText,
                          educationStatistics?.numberOfPostGraduateMen ?? 0),
                      _buildEducationStatisticsTile(l.womenLabelText,
                          educationStatistics?.numberOfPostGraduateWomen ?? 0),
                    ]),
                    _buildEducationStatisticsSection(
                        l.baccalaureate, Icons.menu_book, [
                      _buildEducationStatisticsTile(l.menLabelText,
                          educationStatistics?.numberOfBaccalaureateMen ?? 0),
                      _buildEducationStatisticsTile(l.womenLabelText,
                          educationStatistics?.numberOfBaccalaureateWomen ?? 0),
                    ]),
                    _buildEducationStatisticsSection(
                        l.middleSchool, Icons.menu_book, [
                      _buildEducationStatisticsTile(
                          l.menLabelText,
                          educationStatistics
                                  ?.numberOfMiddleSchoolGraduateMen ??
                              0),
                      _buildEducationStatisticsTile(
                          l.womenLabelText,
                          educationStatistics
                                  ?.numberOfMiddleSchoolGraduateWomen ??
                              0),
                    ]),
                    _buildEducationStatisticsSection(
                        l.primarySchool, Icons.menu_book, [
                      _buildEducationStatisticsTile(
                          l.menLabelText,
                          educationStatistics
                                  ?.numberOfPrimarySchoolGraduateMen ??
                              0),
                      _buildEducationStatisticsTile(
                          l.womenLabelText,
                          educationStatistics
                                  ?.numberOfPrimarySchoolGraduateWomen ??
                              0),
                    ]),
                    _buildEducationStatisticsSection(
                        l.illiterate, Icons.menu_book, [
                      _buildEducationStatisticsTile(l.menLabelText,
                          educationStatistics?.numberOfIlliterateMen ?? 0),
                      _buildEducationStatisticsTile(l.womenLabelText,
                          educationStatistics?.numberOfIlliterateWomen ?? 0),
                    ]),
                    _buildEducationStatisticsSection(
                      l.primarySchoolOrKindergartenQuestion,
                      Icons.menu_book,
                      [
                        educationStatistics!.hasSchool
                            ? Row(
                                children: [
                                  Icon(Icons.check),
                                  Text(l.schoolAvailability)
                                ],
                              )
                            : Row(
                                children: [
                                  Icon(Icons.stop),
                                  Text(l.schoolAvailability)
                                ],
                              )
                      ],
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEducationStatisticsDialog();
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget _buildEducationStatisticsTile(String educationStat, int value) {
    return ListTile(
      title: Text(educationStat),
      subtitle: Text('$value'),
    );
  }

  Widget _buildEducationStatisticsSection(
      String sectionName, IconData icon, List<Widget> children) {
    return Column(
      children: [
        ListTile(
          title: Text(sectionName),
          leading: Icon(icon),
        ),
        ...children,
      ],
    );
  }

  Future<void> _updateEducationStatistics() async {
    try {
      final firestore = FirebaseFirestore.instance;

      final Map<String, dynamic> updatedEducationStatisticsData =
          educationStatistics?.toMap() ?? {};

      await firestore.collection('places').doc(widget.id).update({
        'educationStatistics': updatedEducationStatisticsData,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Education statistics updated successfully'),
        ),
      );
    } catch (e) {
      debugPrint('Error updating education statistics in Firestore: $e');
    }
  }
}
