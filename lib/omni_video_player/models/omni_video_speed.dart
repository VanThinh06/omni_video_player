/// Video playback speed.
enum OmniVideoSpeed {
  speed0_25x,

  speed0_5x,

  speed0_75x,

  /// Normal speed (1.0x).
  speed1x,

  /// Slightly faster (1.25x).
  speed1_25x,

  /// Faster (1.5x).
  speed1_5x,

  /// Double speed (2.0x).
  speed2x,
}

extension SpeedString on OmniVideoSpeed {
  /// Display string
  String get speedString {
    return switch (this) {
      OmniVideoSpeed.speed0_25x => '0.25',
      OmniVideoSpeed.speed0_5x => '0.5',
      OmniVideoSpeed.speed0_75x => '0.75',
      OmniVideoSpeed.speed1x => '1',
      OmniVideoSpeed.speed1_25x => '1.25',
      OmniVideoSpeed.speed1_5x => '1.5',
      OmniVideoSpeed.speed2x => '2',
    };
  }

  /// Numeric value of speed
  double get value {
    return switch (this) {
      OmniVideoSpeed.speed0_25x => 0.25,
      OmniVideoSpeed.speed0_5x => 0.5,
      OmniVideoSpeed.speed0_75x => 0.75,
      OmniVideoSpeed.speed1x => 1.0,
      OmniVideoSpeed.speed1_25x => 1.25,
      OmniVideoSpeed.speed1_5x => 1.5,
      OmniVideoSpeed.speed2x => 2.0,
    };
  }

  int compareTo(OmniVideoSpeed other) {
    return value.compareTo(other.value);
  }

  /// Convert from string like '1x' or '1.5x'
  static OmniVideoSpeed fromString(String speedStr) {
    switch (speedStr) {
      case '0.25':
        return OmniVideoSpeed.speed0_25x;
      case '0.5':
        return OmniVideoSpeed.speed0_5x;
      case '0.75':
        return OmniVideoSpeed.speed0_75x;
      case '1':
        return OmniVideoSpeed.speed1x;
      case '1.25':
        return OmniVideoSpeed.speed1_25x;
      case '1.5':
        return OmniVideoSpeed.speed1_5x;
      case '2':
        return OmniVideoSpeed.speed2x;
      default:
        return OmniVideoSpeed.speed1x;
    }
  }

  /// Convert from raw value
  static OmniVideoSpeed fromValue(double value) {
    if (value == 0.25) return OmniVideoSpeed.speed0_25x;
    if (value == 0.5) return OmniVideoSpeed.speed0_5x;
    if (value == 0.75) return OmniVideoSpeed.speed0_75x;
    if (value == 1.0) return OmniVideoSpeed.speed1x;
    if (value == 1.25) return OmniVideoSpeed.speed1_25x;
    if (value == 1.5) return OmniVideoSpeed.speed1_5x;
    if (value == 2.0) return OmniVideoSpeed.speed2x;
    return OmniVideoSpeed.speed1x;
  }
}
