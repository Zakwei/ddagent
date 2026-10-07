/// Non-web clients have no browser tab to reload. Returns false so the caller
/// can fall back to refreshing in-app state instead.
bool reloadClient() => false;
