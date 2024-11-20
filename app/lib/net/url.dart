abstract final class APIPath {
  const APIPath._();

  // TODO: Uses 192.168.1.156 for physical interaction or 10.0.2.2:3000 when using emulator + Mockoon
  static final Uri gateway = Uri.http("192.168.1.156"/*"10.0.2.2:3000"*/);

  static final Uri userData = gateway.resolve("/api/user_data");

  static final Uri capacity = gateway.resolve("/api/capacity");
}