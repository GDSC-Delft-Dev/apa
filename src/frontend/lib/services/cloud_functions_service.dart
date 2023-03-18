import 'package:cloud_functions/cloud_functions.dart';

class CloudFunctionsService {

  static Future<void> testHealth() async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('checkHealth');
    final response = await callable.call();
    if (response != null) {
      print('---------- Response: ${response.data}');
    }
  }

  // Define a function to fetch a Scan entry from the "scans" collection
  Future<Map<String, dynamic>> fetchScanNDVIMap(String scanId) async {

    // Create a reference to the Firebase Cloud Functions instance
    final HttpsCallable fetchMapCallable = FirebaseFunctions.instance.httpsCallable("fetchScan");

    // Call the cloud function with the scanId parameter
    final result = await fetchMapCallable.call({'scanId': scanId});

    // Parse the result data as a Map and return it
    return Map<String, dynamic>.from(result.data);
  }

  // Example usage
// void exampleUsage() async {
//   final scanId = 'ABC123'; // Replace with your scan ID
//   final scanData = await fetchScan(scanId);
//   print(scanData);
// }
  
    

}