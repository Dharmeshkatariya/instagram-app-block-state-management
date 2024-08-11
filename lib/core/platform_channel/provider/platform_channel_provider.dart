//

import 'package:get_it/get_it.dart';

import '../service/platform_channel_downloader_service.dart';

class PlatformChannelProvider {
  PlatformChannelProvider._();

  static final PlatformChannelProvider instance = PlatformChannelProvider._();

  void setup() {
    GetIt.instance.registerSingleton<PlatformChannelDownloaderService>(
        PlatformChannelDownloaderService());
  }

  PlatformChannelDownloaderService get platformChannelDownloaderService =>
      GetIt.instance<PlatformChannelDownloaderService>();
}
// class PlatformChannelProvider {
//   const PlatformChannelProvider._();
//
//   /// Provider for [PlatformChannelDownloaderService].
//   static final platformChannelDownloaderServiceProvider = Provider<PlatformChannelDownloaderService>((ref) {
//     return const PlatformChannelDownloaderService();
//   });
// }
