import 'package:get_it/get_it.dart';
import '../data/di/data_layer_injection.dart';
import '../presentation/di/presentation_layer_injection.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Thứ tự cực kỳ quan trọng: Data phải có trước để Store sử dụng
  await setupDataLayerInjection();
  await setupPresentationLayerInjection();
}
