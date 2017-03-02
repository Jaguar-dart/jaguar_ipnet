part of jaguar_ipnet;

/// An IPNet represents an IPv4 network
class Ip4Net {
  const Ip4Net(this.network, this.mask);

  /// network number
  final Ip4 network;

  /// network mask
  final Ip4 mask;

  /// Contains reports whether the network includes ip
  bool contains(Ip4 ip4) => ip4.masked(mask) == network;

  String toString() => '$network/${mask.cidrLen}';

  /// Parses CIDR network address of the form a.b.c.d/len
  static Ip4Net parseCIDR(String net) {
    if (net is! String) throw new Exception("net must be String");

    final List<String> parts = net.split('/');
    if (parts.length != 2) throw new Exception("Invalid net address");

    final Ip4 ip = Ip4.parse(parts[0]);
    int cidrMask;
    try {
      cidrMask = int.parse(parts[1]);
    } on FormatException {
      throw new Exception("CIDR mask length must be integer");
    }
    final Ip4 mask = new Ip4.cidr(cidrMask);

    return new Ip4Net(ip.masked(mask), mask);
  }
}
