enum AppFlavor { development, staging, production }

extension AppFlavorX on AppFlavor {
  String get label => switch (this) {
    AppFlavor.development => 'Development',
    AppFlavor.staging => 'Staging',
    AppFlavor.production => 'Production',
  };

  bool get isProduction => this == AppFlavor.production;
}
