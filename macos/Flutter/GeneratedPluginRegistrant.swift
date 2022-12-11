//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import device_info_plus_macos
import pasteboard
import path_provider_macos
import pdf_render
import pdfx
import printing
import url_launcher_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  DeviceInfoPlusMacosPlugin.register(with: registry.registrar(forPlugin: "DeviceInfoPlusMacosPlugin"))
  PasteboardPlugin.register(with: registry.registrar(forPlugin: "PasteboardPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SwiftPdfRenderPlugin.register(with: registry.registrar(forPlugin: "SwiftPdfRenderPlugin"))
  PdfxPlugin.register(with: registry.registrar(forPlugin: "PdfxPlugin"))
  PrintingPlugin.register(with: registry.registrar(forPlugin: "PrintingPlugin"))
  UrlLauncherPlugin.register(with: registry.registrar(forPlugin: "UrlLauncherPlugin"))
}
