A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.

# flutter_modules_generator

## setuup
git clone https://github.com/genss333/flutter_modules_generator.git

### create folder in lib/
    |--- lib/
    |------- bin/
    |----------- clone this here!!

## CLI
dart ../bin/generate_module_structure.dart 


## Example for API
|— modules_name/
|—— controller/
|———— modules_controller.dart
|———— bindings/
|—————— modules_binding.dart
|———— business /
|—————— modules_business.dart
|—— data/
|———— api/
|—————— modules_api.dart
|———— models/
|———— services/
|—————— modules_service.dart
|—— views/
|———— widgets/
|———— modules_view.dart

## Example for webview
|— modules_name/
|—— controller/
|———— modules_controller.dart
|———— bindings/
|—————— modules_binding.dart
|———— business /
|—————— modules_business.dart
|—— data/
|———— models/
|———— webview_services/
|—————— modules_webview_service.dart
|—— views/
|———— widgets/
|———— modules_view.dart
