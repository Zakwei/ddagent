/// Native builds have no notification surface wired up — the caller falls
/// back to an in-app toast.
Future<bool> requestPermissionImpl() async => false;

Future<bool> showImpl({required String title, required String body}) async => false;
