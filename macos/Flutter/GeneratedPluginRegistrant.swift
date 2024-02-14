//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import ble_peripheral
import cloud_firestore
import device_info_plus
import firebase_auth
import firebase_core
import firebase_storage
import flutter_ble_peripheral
import flutter_blue_plus
import location

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  BlePeripheralPlugin.register(with: registry.registrar(forPlugin: "BlePeripheralPlugin"))
  FLTFirebaseFirestorePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseFirestorePlugin"))
  DeviceInfoPlusMacosPlugin.register(with: registry.registrar(forPlugin: "DeviceInfoPlusMacosPlugin"))
  FLTFirebaseAuthPlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseAuthPlugin"))
  FLTFirebaseCorePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseCorePlugin"))
  FLTFirebaseStoragePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseStoragePlugin"))
  FlutterBlePeripheralPlugin.register(with: registry.registrar(forPlugin: "FlutterBlePeripheralPlugin"))
  FlutterBluePlusPlugin.register(with: registry.registrar(forPlugin: "FlutterBluePlusPlugin"))
  LocationPlugin.register(with: registry.registrar(forPlugin: "LocationPlugin"))
}
