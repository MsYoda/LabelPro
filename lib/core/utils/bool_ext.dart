extension BoolExt on bool {
  int get value {
    switch (this) {
      case true:
        return 1;
      case false:
        return 0;
    }
  }
}
