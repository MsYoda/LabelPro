enum CustomInputType {
  oneFromMany,
  manyFromMany,
  text;

  static CustomInputType fromString(String data) {
    switch (data) {
      case 'one_from_many':
      case 'oneFromMany':
        return CustomInputType.oneFromMany;
      case 'manyFromMany':
      case 'many_from_many':
        return CustomInputType.manyFromMany;
      case 'text':
        return CustomInputType.text;
      default:
        return CustomInputType.text;
    }
  }

  String toJson() {
    switch (this) {
      case CustomInputType.oneFromMany:
        return 'one_from_many';
      case CustomInputType.manyFromMany:
        return 'many_from_many';
      case CustomInputType.text:
        return 'text';
    }
  }
}
