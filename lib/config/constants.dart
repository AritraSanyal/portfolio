class TerminalConstants {
  TerminalConstants._();

  // Terminal dimensions
  static const double terminalMaxWidth = 950;
  static const double terminalMaxHeight = 700;
  static const double terminalWidthRatio = 0.92;
  static const double terminalHeightRatio = 0.85;
  static const double terminalMinWidth = 300;
  static const double terminalMinHeight = 300;

  // Animation / timing
  static const int typewriterCharMs = 16;
  static const int typewriterLineMs = 60;
  static const int cursorBlinkMs = 500;

  // Layout
  static const double titleBarHeight = 32;
  static const double inputRowHeight = 36;

  // Loading bar
  static const double loadingBarMaxWidth = 320;
  static const double loadingBarWidthRatio = 0.52;
  static const double loadingBarHeight = 8;
  static const double loadingDurationSec = 4.5;
}
