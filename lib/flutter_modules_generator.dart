import 'dart:io';

void createModuleStructure(String basePath, Map<String, dynamic> structure) {
  Directory(basePath).createSync(recursive: true); // Create the base directory

  structure.forEach((folder, files) {
    final folderPath = '$basePath/$folder';
    Directory(folderPath).createSync(); // Create the folder

    if (files is List<String>) {
      for (var file in files) {
        final filePath = '$folderPath/$file';
        createFile(filePath, folder, file);
      }
    } else if (files is Map<String, dynamic>) {
      createModuleStructure(folderPath, files);
    }
  });
}

void createFile(String path, String folder, String file) {
  print('folder:$folder/$file');
  File(path).writeAsStringSync(getFileContent(folder, file));
  print('Created: $path');
}

String getFileContent(String folder, String file) {
  switch (folder) {
    case 'controller':
      return '''import 'package:get/get.dart';

class ${file.split('_')[0].capitalize()}Controller extends GetxController {}
''';
    case 'bindings':
      return '''import 'package:get/get.dart';

class ${file.split('_')[0].capitalize()}Binding implements Binding {
  @override
  List<Bind> dependencies() {
    return [];
  }
}
''';
    case 'business':
      return '''
extension ${file.split('_')[0].capitalize()}Business on ${file.split('_')[0].capitalize()}Controller {}
''';
    case 'api':
      return '''
class ${file.split('_')[0].capitalize()}Api {
  Dio dioApi() {
    //get base url from env
    String baseUrl = '';

    // Set up the api
    Api api = Api(
      baseUrl: baseUrl,
      accessToken: '',
      refreshToken: '',
      onTokenRefreshed: (newToken) {
        debugprint('New token: \$newToken');
      },
      serverCertificate: '',
      connectTimeout: 180,
      receiveTimeout: 180,
      header: {},
    );

    api.onInit();

    return api.dio;
  }
}
''';
    case 'services':
      return '''import 'package:get/get.dart';

class ${file.split('_')[0].capitalize()}Service extends GetxService {
  final ${file.split('_')[0].capitalize()}Api api;

  ${file.split('_')[0].capitalize()}Service({required this.api});
}
''';
    case 'webview_services':
      return ''' class ${file.split('_')[0].capitalize()}Service extends GetxService {
  final WebViewService service;

  ${file.split('_')[0].capitalize()}Service({required this.service});

  Future<void> fetchData(${file.split('_')[0].capitalize()}Controller controller) async {
    await service.get(
      model: WebviewGETModel(
      //webViewController: controller.webViewController,
        url: '',
        handlerName: '',
        getDataCallback: (dataaCallback){},
        getLoadingCallback: (){},
      ),
    );
  }

  Future<void> someAction(${file.split('_')[0].capitalize()}Controller controller) async {
     List<Map<String, dynamic>> json = [{}];

     final model = WebviewPOSTModel(
      webViewController: controller.webViewController,
      funcName: "btn_01",
      handlerName: 'ProcessInsert',
      json: json,
      getDataCallback: (dataCallback) {},
    );

    await service.post(model: model);
  }
}
''';
    case '':
      return '''import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ${file.split('_')[0].capitalize()}View extends GetView<${file.split('_')[0].capitalize()}Controller> {
  const ${file.split('_')[0].capitalize()}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(); // Placeholder for the widget's build method
  }
}
''';

    default:
      return '';
  }
}

extension StringCapitalize on String {
  String capitalize() => isNotEmpty ? this[0].toUpperCase() + substring(1) : '';
}