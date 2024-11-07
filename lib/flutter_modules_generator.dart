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
  File(path).writeAsStringSync(getFileContent(folder, file));
  print('Created: $path');
}

void moveToController(String basePath, List<String> foldersToMove) {
  final controllerPath = '$basePath/controller';
  for (var folder in foldersToMove) {
    final sourcePath = '$basePath/$folder';
    final destinationPath = '$controllerPath/$folder';

    final sourceDirectory = Directory(sourcePath);
    final destinationDirectory = Directory(destinationPath);

    if (sourceDirectory.existsSync()) {
      // Ensure the destination directory exists
      if (!destinationDirectory.existsSync()) {
        destinationDirectory.createSync(recursive: true);
      }

      // Move each file to the new destination
      sourceDirectory.listSync().forEach((entity) {
        if (entity is File) {
          final newPath =
              '${destinationDirectory.path}/${entity.uri.pathSegments.last}';
          entity.renameSync(newPath);
        }
      });

      // Delete the old directory after moving files
      sourceDirectory.deleteSync();
      print('Moved $folder to $controllerPath');
    }
  }
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
    return [
      Bind.lazyPut(() => ${file.split('_')[0].capitalize()}Controller()),
    ];
  }
}
''';
    case 'business':
      return '''
extension ${file.split('_')[0].capitalize()}Business on ${file.split('_')[0].capitalize()}Controller {}
''';
    case 'api':
      return '''import 'package:dio_helper_api/dio_helper.dart';
import 'package:flutter/material.dart';

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
        debugPrint('New token: \$newToken');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('${file.split('_')[0].capitalize()}View'),
      ),
      body: Center(
        child: Text('${file.split('_')[0].capitalize()}View'),
      ),
    );
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
