#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"

namespace {

// One process per instance key: the plain app, or one window per pinned
// server (`--server=<url>`). Each process holds its storage's Hive locks, so
// a second process with the same key could not open them — it brings the
// running window forward and exits instead.
std::wstring InstanceKey(const std::vector<std::string>& args) {
  std::string key = "ddagent_app";
  for (const auto& arg : args) {
    if (arg.rfind("--server=", 0) == 0) key += "|" + arg.substr(9);
  }
  for (auto& c : key) {
    if (c == '\\') c = '/';  // kernel object names reserve backslash
  }
  int size = ::MultiByteToWideChar(CP_UTF8, 0, key.c_str(), -1, nullptr, 0);
  if (size <= 1) return L"ddagent_app";
  std::wstring wide(size - 1, L'\0');
  ::MultiByteToWideChar(CP_UTF8, 0, key.c_str(), -1, wide.data(), size);
  return wide;
}

// Window property name == instance key marks the window owning that key.
BOOL CALLBACK FocusInstanceWindow(HWND window, LPARAM key) {
  if (!::GetPropW(window, reinterpret_cast<LPCWSTR>(key))) return TRUE;
  if (::IsIconic(window)) ::ShowWindow(window, SW_RESTORE);
  ::SetForegroundWindow(window);
  return FALSE;
}

}  // namespace

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  const std::wstring instance_key = InstanceKey(command_line_arguments);
  HANDLE instance_mutex =
      ::CreateMutexW(nullptr, TRUE, (L"Local\\" + instance_key).c_str());
  if (instance_mutex != nullptr && ::GetLastError() == ERROR_ALREADY_EXISTS) {
    ::EnumWindows(FocusInstanceWindow,
                  reinterpret_cast<LPARAM>(instance_key.c_str()));
    ::CloseHandle(instance_mutex);
    ::CoUninitialize();
    return EXIT_SUCCESS;
  }

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(L"DDAgent", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);
  ::SetPropW(window.GetHandle(), instance_key.c_str(),
             reinterpret_cast<HANDLE>(1));

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
