    T enumFromString<T>(String value, List<T> values) {
      return values.firstWhere(
        (type) => type.toString().split('.').last == value,
        orElse: () => throw Exception('Unknown enum value: $value'),
      );
    }