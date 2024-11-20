abstract final class APIPath {
  const APIPath._();

  static final Uri gateway = Uri.http(/*"192.168.1.2"*/"10.0.2.2:3000");

  static final Uri userData = gateway.resolve("/api/user_data");

  static final Uri capacity = gateway.resolve("/api/capacity");
}