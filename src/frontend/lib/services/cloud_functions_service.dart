import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionsService {

  static Future<void> testHealth() async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('checkHealth');
    final response = await callable.call();
    if (response != null) {
      print('---------- Response: ${response.data}');
    }
  }

}