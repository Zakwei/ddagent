import 'dart:io';

/// Terminates the process immediately. Callers must hand off anything that has
/// to survive (e.g. a staged update installer) before calling this.
bool quitApp() => exit(0);
