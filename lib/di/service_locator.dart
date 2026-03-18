import 'package:ai_helpdesk/core/di/core_layer_injection.dart';
import 'package:ai_helpdesk/data/di/data_layer_injection.dart';
import 'package:ai_helpdesk/domain/di/domain_layer_injection.dart';
import 'package:ai_helpdesk/presentation/di/presentation_layer_injection.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static Future<void> configureDependencies() async {
    await CoreLayerInjection.configureCoreLayerInjection();
    await DataLayerInjection.configureDataLayerInjection();
    await DomainLayerInjection.configureDomainLayerInjection();
    await PresentationLayerInjection.configurePresentationLayerInjection();
  }
}
