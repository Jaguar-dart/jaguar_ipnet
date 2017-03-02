// Copyright (c) 2017, SERAGUD. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// IP address manipulations
///
/// IPv4 addresses are 4 bytes; IPv6 addresses are 16 bytes.
/// An IPv4 address can be converted to an IPv6 address by
/// adding a canonical prefix (10 zeros, 2 0xFFs).
/// This library accepts either size of byte slice but always
/// returns 16-byte addresses.
library jaguar_ipnet;

export 'src/jaguar_ipnet_base.dart';
