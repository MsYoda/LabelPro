enum CustomDataType {
  sound,
  image,
  string;

  static CustomDataType fromString(String data) {
    switch (data) {
      case 'sound':
        return CustomDataType.sound;
      case 'image':
        return CustomDataType.image;
      case 'string':
        return CustomDataType.string;
      default:
        return CustomDataType.string;
    }
  }
}
