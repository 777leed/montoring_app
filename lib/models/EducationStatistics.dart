class EducationStatistics {
  int numberOfLiterateMen;
  int numberOfLiterateWomen;
  int numberOfPostGraduateMen;
  int numberOfPostGraduateWomen;
  int numberOfBaccalaureateMen;
  int numberOfBaccalaureateWomen;
  int numberOfMiddleSchoolGraduateMen;
  int numberOfMiddleSchoolGraduateWomen;
  int numberOfPrimarySchoolGraduateMen;
  int numberOfPrimarySchoolGraduateWomen;
  int numberOfIlliterateMen;
  int numberOfIlliterateWomen;
  bool hasSchool;

  EducationStatistics(
      {required this.numberOfLiterateMen,
      required this.numberOfLiterateWomen,
      required this.numberOfPostGraduateMen,
      required this.numberOfPostGraduateWomen,
      required this.numberOfBaccalaureateMen,
      required this.numberOfBaccalaureateWomen,
      required this.numberOfMiddleSchoolGraduateMen,
      required this.numberOfMiddleSchoolGraduateWomen,
      required this.numberOfPrimarySchoolGraduateMen,
      required this.numberOfPrimarySchoolGraduateWomen,
      required this.numberOfIlliterateMen,
      required this.numberOfIlliterateWomen,
      required this.hasSchool});

  EducationStatistics.initial()
      : numberOfLiterateMen = 0,
        numberOfLiterateWomen = 0,
        numberOfPostGraduateMen = 0,
        numberOfPostGraduateWomen = 0,
        numberOfBaccalaureateMen = 0,
        numberOfBaccalaureateWomen = 0,
        numberOfMiddleSchoolGraduateMen = 0,
        numberOfMiddleSchoolGraduateWomen = 0,
        numberOfPrimarySchoolGraduateMen = 0,
        numberOfPrimarySchoolGraduateWomen = 0,
        numberOfIlliterateMen = 0,
        numberOfIlliterateWomen = 0,
        hasSchool = false;

  factory EducationStatistics.fromMap(Map<String, dynamic> data) {
    return EducationStatistics(
      numberOfLiterateMen: data['numberOfLiterateMen'],
      numberOfLiterateWomen: data['numberOfLiterateWomen'],
      numberOfPostGraduateMen: data['numberOfPostGraduateMen'],
      numberOfPostGraduateWomen: data['numberOfPostGraduateWomen'],
      numberOfBaccalaureateMen: data['numberOfBaccalaureateMen'],
      numberOfBaccalaureateWomen: data['numberOfBaccalaureateWomen'],
      numberOfMiddleSchoolGraduateMen: data['numberOfMiddleSchoolGraduateMen'],
      numberOfMiddleSchoolGraduateWomen:
          data['numberOfMiddleSchoolGraduateWomen'],
      numberOfPrimarySchoolGraduateMen:
          data['numberOfPrimarySchoolGraduateMen'],
      numberOfPrimarySchoolGraduateWomen:
          data['numberOfPrimarySchoolGraduateWomen'],
      numberOfIlliterateMen: data['numberOfIlliterateMen'],
      numberOfIlliterateWomen: data['numberOfIlliterateWomen'],
      hasSchool: data['hasSchool'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'numberOfLiterateMen': numberOfLiterateMen,
      'numberOfLiterateWomen': numberOfLiterateWomen,
      'numberOfPostGraduateMen': numberOfPostGraduateMen,
      'numberOfPostGraduateWomen': numberOfPostGraduateWomen,
      'numberOfBaccalaureateMen': numberOfBaccalaureateMen,
      'numberOfBaccalaureateWomen': numberOfBaccalaureateWomen,
      'numberOfMiddleSchoolGraduateMen': numberOfMiddleSchoolGraduateMen,
      'numberOfMiddleSchoolGraduateWomen': numberOfMiddleSchoolGraduateWomen,
      'numberOfPrimarySchoolGraduateMen': numberOfPrimarySchoolGraduateMen,
      'numberOfPrimarySchoolGraduateWomen': numberOfPrimarySchoolGraduateWomen,
      'numberOfIlliterateMen': numberOfIlliterateMen,
      'numberOfIlliterateWomen': numberOfIlliterateWomen,
      'hasSchool': hasSchool
    };
  }
}
