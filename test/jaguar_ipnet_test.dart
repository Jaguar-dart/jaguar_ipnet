// Copyright (c) 2017, SERAGUD. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar_ipnet.tests;

import 'package:jaguar_ipnet/jaguar_ipnet.dart';
import 'package:test/test.dart';

part 'ip4_net.dart';

void main() {
  group('A group of tests', () {
    test('IP parse', () {
      Ip4 parsed = Ip4.parse('192.67.148.100');

      expect(parsed[0], 192);
      expect(parsed[1], 67);
      expect(parsed[2], 148);
      expect(parsed[3], 100);

      expect(parsed.a, 192);
      expect(parsed.b, 67);
      expect(parsed.c, 148);
      expect(parsed.d, 100);

      expect(parsed.toString(), '192.67.148.100');

      expect(parsed.cidrLen, 0);

      expect(parsed.masked(Ip4.classBMask), equals(new Ip4.make(192, 67, 0, 0)));
    });

    test('IP parse invalid', () {
      expect(
              () => Ip4.parse(null),
          throwsA(allOf(
              isException,
              predicate((e) =>
              e.message == "IP address must be a String"))));

      expect(
              () => Ip4.parse("4.5"),
          throwsA(allOf(
              isException,
              predicate((e) =>
              e.message == "Invalid IP address"))));

      expect(
              () => Ip4.parse("4.5.6"),
          throwsA(allOf(
              isException,
              predicate((e) =>
              e.message == "Invalid IP address"))));

      expect(
              () => Ip4.parse("4.5.6.7.9"),
          throwsA(allOf(
              isException,
              predicate((e) =>
              e.message == "Invalid IP address"))));

      expect(
              () => Ip4.parse("4.5.6.7/3"),
          throwsA(allOf(
              isException,
              predicate((e) =>
              e.message == "Invalid IP address format"))));
    });
  });

  groupIp4Net();
}
