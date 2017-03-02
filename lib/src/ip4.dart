part of jaguar_ipnet;

abstract class Ip {
  /// Access a component of the IP address by index
  int operator [](int index);

  /// Checks if two IP addresses are equal
  bool operator ==(ip);

  /// Returns true if it is a v4 IP address
  bool get isIp4;

  /// Returns true if it is a v6 IP address
  bool get isIp6;

  /// Returns true if it is a loopback address
  bool get isLoopback;

  /// Returns true is it is a multicast address
  bool get isMulticast;

  /// Returns true if all components of the address are 0xFF
  bool get isAllFF;
}

/// IPv4 address
class Ip4 implements Ip {
  final List<int> _bytes = new List(4);

  /// Creates v4 IP address from its component parts
  Ip4.make(int a, int b, int c, int d) {
    _bytes[0] = a;
    _bytes[1] = b;
    _bytes[2] = c;
    _bytes[3] = d;
  }

  /// Creates v4 IP address from its CIDR length
  factory Ip4.cidr(int ones) {
    if (ones < 0 || ones > (8 * ipV4Len))
      throw new Exception("Ones must be between 0 and 24");

    final list = new List<int>(ipV4Len);
    for (int idx = 0; idx < ipV4Len; idx++) {
      if (ones >= 8) {
        list[idx] = 0xFF;
        ones -= 8;
        continue;
      }
      list[idx] = ~(0xFF >> ones) & 0xFF;
    }

    return new Ip4.make(list[0], list[1], list[2], list[3]);
  }

  /// Returns first component of the address
  int get a => _bytes[0];

  /// Returns second component of the address
  int get b => _bytes[1];

  /// Returns third component of the address
  int get c => _bytes[2];

  /// Returns fourth component of the address
  int get d => _bytes[3];

  /// Access a component of the IP address by index
  int operator [](int index) {
    if (index < 0 || index >= ipV4Len) throw new IndexError(index, _bytes);
    return _bytes[index];
  }

  /// Checks if two IP addresses are equal
  bool operator ==(ip) {
    if(ip is Ip4) {
      for (int i = 0; i < ipV4Len; i++) {
        if (_bytes[i] != ip[i]) return false;
      }

      return true;
    }
    //TODO handle ipv6
    return false;
  }

  /// Returns true if it is a v4 IP address
  bool get isIp4 => true;

  /// Returns true if it is a v6 IP address
  bool get isIp6 => false;

  /// Returns true if it is a loopback address
  bool get isLoopback => _bytes[0] == 127;

  /// Returns true is it is a multicast address
  bool get isMulticast => (_bytes[0] & 0xf0) == 0xe0;

  bool get isAllFF => !_bytes.any((int v) => v != 0xFF);

  /// Returns default mask of the IP address
  Ip4 get defaultMask {
    if (_bytes[0] < 0x80) return classAMask;
    if (_bytes[0] < 0xC0) return classBMask;
    return classCMask;
  }

  /// Returns the IP address resulting from masking this address with
  /// the given [mask]
  Ip4 masked(Ip4 mask) {
    final ret = new List<int>(4);
    for (int i = 0; i < ipV4Len; i++) ret[i] = _bytes[i] & mask[i];
    return new Ip4.make(ret[0], ret[1], ret[2], ret[3]);
  }

  /// Returns CIRD length of the mask
  int get cidrLen {
    int ret = 0;
    int i = 0;
    for(; i < ipV4Len; i++) {
      if(_bytes[i] == 0xFF) {
        ret += 8;
        continue;
      }

      if(_bytes[i] == 0) break;
      final int leading = _byteToLeadingOnes(_bytes[i]);
      if(leading == 0) return 0;
      ret += leading;
      break;
    }

    for(i++;i < ipV4Len; i++) {
      if(_bytes[i] != 0) {
        return 0;
      }
    }

    return ret;
  }

  String toString() => "$a.$b.$c.$d";

  /// Parses the IP address from String of form a.b.c.d
  static Ip4 parse(String ip) {
    if (ip is! String) throw new Exception("IP address must be a String");

    final List<String> parts = ip.split('.');
    if (parts.length != 4) throw new Exception("Invalid IP address");

    List<int> intParts;
    try {
      intParts =
          parts.map((String str) => int.parse(str)).toList(growable: false);
    } on FormatException {
      throw new Exception("Invalid IP address format");
    }

    return new Ip4.make(intParts[0], intParts[1], intParts[2], intParts[3]);
  }

  /// limited broadcast
  static Ip4 get broadcast => new Ip4.make(255, 255, 255, 255);

  /// all systems
  static Ip4 get allsys => new Ip4.make(224, 0, 0, 1);

  /// all routers
  static Ip4 get allrouter => new Ip4.make(224, 0, 0, 2);

  /// all zeros
  static Ip4 get zero => new Ip4.make(0, 0, 0, 0);

  static Ip4 get classAMask => new Ip4.make(0xff, 0, 0, 0);
  static Ip4 get classBMask => new Ip4.make(0xff, 0xff, 0, 0);
  static Ip4 get classCMask => new Ip4.make(0xff, 0xff, 0xff, 0);
}

/// Returns leading ones in a given byte
int _byteToLeadingOnes(int byte) {
  int ret = 0;
  int i = 0;
  while(i < 8) {
    if(byte & 0x80 != 0) {
      ret++;
    } else {
      break;
    }
    byte <<= 1;
    i++;
  }

  while(i < 8) {
    if(byte & 0x80 != 0) {
      ret = 0;
      break;
    }
    byte <<= 1;
    i++;
  }

  return ret;
}