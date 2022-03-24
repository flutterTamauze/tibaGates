import 'package:flutter/cupertino.dart';

import '../Utilities/Shared/dialogs/dialog_helper.dart';
import 'app_exceptions.dart';
import 'package:get/get.dart';

class BaseExceptionHandling {

  void handleError(error,VoidCallback) {

    if (error is BadRequestException) {
      var message = error.message;
      DialogHelper.showErroDialog(description: message);
    } else if (error is FetchDataException) {
      var message =    error.message;
      DialogHelper.showErroDialog(description: message);
    } else if (error is ApiNotRespondingException) {

      DialogHelper.showErroDialog(
          description: 'Time Out , it takes longer time to respond');
    }
  }
}
