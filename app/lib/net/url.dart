abstract final class APIPath {
  const APIPath._();

  static final Uri gateway = Uri.http("192.168.1.2", "/api");

  static final Uri userData = gateway.resolve("user_data");

  static final Uri capacity = gateway.resolve("capacity");
}