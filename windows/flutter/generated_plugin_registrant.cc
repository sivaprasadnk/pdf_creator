//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <pasteboard/pasteboard_plugin.h>
#include <pdfx/pdfx_plugin.h>
#include <printing/printing_plugin.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  PasteboardPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PasteboardPlugin"));
  PdfxPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PdfxPlugin"));
  PrintingPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PrintingPlugin"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
