abstract final class APIPath {
  const APIPath._();

  static final Uri gateway = Uri.parse(const String.fromEnvironment("API_ADDR",
      defaultValue: "http://192.168.1.156"));

  static final Uri userData = gateway.resolve("/api/user_data");

  static final Uri capacity = gateway.resolve("/api/capacity");
}
