import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/web.dart';
import 'package:optiparse_nawabs/screens/loading_transition.dart';

final log = Logger();

class ImgService {
  File? _image;
  final picker = ImagePicker();
  final Dio dio = Dio(); // Initialize Dio

  // Show options to get image from camera or gallery
  Future<Map<String, dynamic>> showOptions(BuildContext context) async {
    // Completer to return data when fetched
    final completer = Completer<Map<String, dynamic>>();
    final parentContext = context;

    showCupertinoModalPopup(
      context: parentContext,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () async {
              // Close the options modal
              Navigator.of(context).pop();

              // Get image from gallery
              final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery, imageQuality: 25);
              if (pickedFile != null) {
                _image = File(pickedFile.path);

                // Show the LoadingPage
                showDialog(
                  context: parentContext,
                  barrierDismissible: false,
                  builder: (_) => const LoadingPage(),
                );

                var data = await sendImageToModel(context, _image!);

                Navigator.of(parentContext).pop();
                completer
                    .complete(data); // Complete the completer with fetched data
              }
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () async {
              // Close the options modal
              Navigator.of(context).pop();

              // Get image from camera
              final pickedFile =
                  await picker.pickImage(source: ImageSource.camera, imageQuality: 25);
              if (pickedFile != null) {
                _image = File(pickedFile.path);
                // Show the LoadingPage
                showDialog(
                  context: parentContext,
                  barrierDismissible: false,
                  builder: (_) => const LoadingPage(),
                );
                var data = await sendImageToModel(context, _image!);
                Navigator.of(parentContext).pop();
                completer
                    .complete(data); // Complete the completer with fetched data
              }
            },
          ),
        ],
      ),
    );

    return completer.future; // Return the data when it becomes available
  }

  // Function to send the selected image to the server and return the data
  Future<Map<String, dynamic>> sendImageToModel(
      BuildContext context, File imageFile) async {
    const url = "http://52.140.76.58:8000/api/upload/";

    FormData formData = FormData.fromMap({
      'file':
          await MultipartFile.fromFile(imageFile.path, filename: 'upload.jpg'),
    });

    try {
      Response response = await dio.post(url, data: formData);

      if (response.statusCode == 201) {
        log.i('Response JSON: ${response.data}');
        var data = await fetchDetectedData(response.data['file']);
        return data;
      } else {
        log.i('Failed to send image. Status code: ${response.statusCode}');
        log.i(response);
      }
    } catch (e) {
      log.i('Error occurred while sending image: $e');
    }
    // Return an empty map if there's an error
    return {};
  }

  // Function to fetch detected data using the file name received from the server
  Future<Map<String, dynamic>> fetchDetectedData(String fileName) async {
    const url = "http://52.140.76.58:8000/api/detect/";
    try {
      Response response = await dio.post(
        url,
        data: {'file_name': fileName},
      );

      if (response.statusCode == 201) {
        log.i('Detected Data: ${response.data['data']['date']}');
        return {
          'date': response.data['data']['date'],
          'invoice_id': response.data['data']['invoice_id'],
          'vendors_name': response.data['data']['vendors_name'],
          'buyer_name': response.data['data']['buyer_name'],
          'total_amount': response.data['data']['total_amount'],
        };
      } else {
        log.i(
            'Failed to fetch detected data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log.i('Error occurred while fetching detected data: $e');
    }
    return {};
  }
}
