import 'dart:io';

import 'package:flutter_modules_generator/flutter_modules_generator.dart';

void main(List<String> arguments) {
  stdout.write('Enter the module name: ');
  final moduleName = stdin.readLineSync();

  if (moduleName == null || moduleName.isEmpty) {
    print('Module name cannot be empty.');
    return;
  }

  stdout.write('webview/api: ');
  final type = stdin.readLineSync();

  final modulesPath = moduleName;

  final moduleStructure = {
    'controller': [
      '${modulesPath}_controller.dart',
    ],
    'bindings': [
      '${modulesPath}_binding.dart',
    ],
    'business': [
      '${modulesPath}_business.dart',
    ],
    'data': {
      'api': [
        '${modulesPath}_api.dart',
      ],
      'models': ['${modulesPath}_model.dart'],
      'services': [
        '${modulesPath}_service.dart',
      ],
      'webview_services': [
        '${modulesPath}_webview_service.dart',
      ],
    },
    'views': {
      'widgets': [
        '${modulesPath}_widget.dart',
      ],
      '': [
        '${modulesPath}_view.dart',
      ],
    },
  };

  if (type == 'api') {
    (moduleStructure['data'] as Map<String, dynamic>?)
        ?.remove('webview_services');
  } else if (type == 'webview') {
    (moduleStructure['data'] as Map<String, dynamic>?)?.remove('api');
    (moduleStructure['data'] as Map<String, dynamic>?)?.remove('services');
  } else {
    print('Invalid type name. Please enter either "webview" or "api".');
    return;
  }

  createModuleStructure(modulesPath, moduleStructure);
}
