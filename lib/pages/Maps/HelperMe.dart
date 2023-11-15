import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HelperMe {
  String? localTrans(String? selectedStatus, AppLocalizations l) {
    if (selectedStatus == "Unknown" || selectedStatus == "غير معروف") {
      selectedStatus = l.unknownText;
    } else if (selectedStatus == "Low" || selectedStatus == "منخفض") {
      selectedStatus = l.lowText;
    } else if (selectedStatus == "Medium" || selectedStatus == "متوسط") {
      selectedStatus = l.mediumText;
    } else if (selectedStatus == "High" || selectedStatus == "عالي") {
      selectedStatus = l.highText;
    }
    return selectedStatus;
  }

  String localTransNotNull(String selectedStatus, AppLocalizations l) {
    if (selectedStatus == "Unknown" || selectedStatus == "غير معروف") {
      selectedStatus = l.unknownText;
    } else if (selectedStatus == "Low" || selectedStatus == "منخفض") {
      selectedStatus = l.lowText;
    } else if (selectedStatus == "Medium" || selectedStatus == "متوسط") {
      selectedStatus = l.mediumText;
    } else if (selectedStatus == "High" || selectedStatus == "عالي") {
      selectedStatus = l.highText;
    }
    return selectedStatus;
  }
}
