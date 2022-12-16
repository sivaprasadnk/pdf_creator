//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import device_info_plus_macos
import package_info_plus
import path_provider_macos
import pdf_render
import pdfx
import printing
import share_plus

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  DeviceInfoPlusMacosPlugin.register(with: registry.registrar(forPlugin: "DeviceInfoPlusMacosPlugin"))
  FLTPackageInfoPlusPlugin.register(with: registry.registrar(forPlugin: "FLTPackageInfoPlusPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SwiftPdfRenderPlugin.register(with: registry.registrar(forPlugin: "SwiftPdfRenderPlugin"))
  PdfxPlugin.register(with: registry.registrar(forPlugin: "PdfxPlugin"))
  PrintingPlugin.register(with: registry.registrar(forPlugin: "PrintingPlugin"))
  SharePlusMacosPlugin.register(with: registry.registrar(forPlugin: "SharePlusMacosPlugin"))
}
