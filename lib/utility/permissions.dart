import 'dart:io';

import 'package:ecosystem/constants.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> validatePermissions(BuildContext context) async {
  if (Platform.isIOS || Platform.isAndroid) {
    PermissionStatus givenPermission;

    if (Platform.isIOS) {
      givenPermission = await Permission.storage.request();
    } else {
      givenPermission = await Permission.manageExternalStorage.request();
    }

    if (givenPermission.isRestricted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(permissionStorageNotGranted),
        ));
      }
      return false;

    } else if (givenPermission.isPermanentlyDenied) {
      await openAppSettings();
      return false;

    } else if (!givenPermission.isGranted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(permissionStorageGrantRequest),
        ));
      }
      return false;
    }
  }

  if (Platform.isMacOS) {
    // TODO
  }

  if (Platform.isLinux) {
    // TODO
  }

  if (Platform.isWindows) {
    // TODO
  }

  return true;
}