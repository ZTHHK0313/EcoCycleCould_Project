abstract final class APIPath {
  const APIPath._();

  static bool useLocalMock = false;

  static Uri get gateway => Uri.http(useLocalMock ? "10.0.2.2:3000" : "192.168.1.156");

  static final Uri userData = gateway.resolve("/api/user_data");

  static final Uri capacity = gateway.resolve("/api/capacity");
}