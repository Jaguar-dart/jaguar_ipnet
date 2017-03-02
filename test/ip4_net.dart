part of jaguar_ipnet.tests;

void groupIp4Net() {
  group('IP4Net', () {
    test('parse', () {
      Ip4Net parsed = Ip4Net.parseCIDR('192.67.148.100/16');

      expect(parsed.network, equals(Ip4.parse('192.67.0.0')));
      expect(parsed.mask, equals(Ip4.classBMask));

      expect(parsed.toString(), '192.67.0.0/16');

      expect(parsed.mask.cidrLen, 16);

      expect(parsed.contains(Ip4.parse('192.67.148.27')), isTrue);
      expect(parsed.contains(Ip4.parse('192.68.148.27')), isFalse);
    });

    test('IP parse invalid', () {
      expect(
              () => Ip4Net.parseCIDR(null),
          throwsA(allOf(
              isException,
              predicate((e) =>
              e.message == "net must be String"))));

      expect(
              () => Ip4Net.parseCIDR("4.5"),
          throwsA(allOf(
              isException,
              predicate((e) =>
              e.message == "Invalid net address"))));

      expect(
              () => Ip4Net.parseCIDR("4.5.6"),
          throwsA(allOf(
              isException,
              predicate((e) =>
              e.message == "Invalid net address"))));

      expect(
              () => Ip4Net.parseCIDR("4.5.6.7.9"),
          throwsA(allOf(
              isException,
              predicate((e) =>
              e.message == "Invalid net address"))));

      expect(
              () => Ip4Net.parseCIDR("4.5.6/3"),
          throwsA(allOf(
              isException,
              predicate((e) =>
              e.message == "Invalid IP address"))));

      expect(
              () => Ip4Net.parseCIDR("/3"),
          throwsA(allOf(
              isException,
              predicate((e) =>
              e.message == "Invalid IP address"))));

      expect(
              () => Ip4Net.parseCIDR("4.5.6.7.8/3"),
          throwsA(allOf(
              isException,
              predicate((e) =>
              e.message == "Invalid IP address"))));

      expect(
              () => Ip4Net.parseCIDR("4.5.6.7/3/3"),
          throwsA(allOf(
              isException,
              predicate((e) =>
              e.message == "Invalid net address"))));
    });
  });
}