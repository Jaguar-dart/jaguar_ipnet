# jaguar_ipnet

An extensive library to handle IP addresses

## Usage

A simple usage example:

````dart
import 'package:jaguar_ipnet/jaguar_ipnet.dart';

main() {
  final Ip4 ip = Ip4.parse('192.67.148.100');

  print(ip[0]);  // Should print `192`
  print(ip[1]);  // Should print `67`
  print(ip[2]);  // Should print `148`
  print(ip[3]);  // Should print `100`

  print(ip.a);  // Should print `192`
  print(ip.b);  // Should print `67`
  print(ip.c);  // Should print `148`
  print(ip.d);

  print(ip.toString());  // Should print `192.67.148.100`

  print(Ip4.classAMask.cidrLen);  // Should print `8`
  print(Ip4.classBMask.cidrLen);  // Should print `16`
  print(Ip4.classCMask.cidrLen);  // Should print `24`

  print(ip.masked(Ip4.classBMask));  // Should print `192.67.0.0`;

  final Ip4Net net = Ip4Net.parseCIDR('192.67.148.100/16');

  print(net.network);  // Should print `192.67.0.0`;
  print(net.mask);  // Should print `255.255.0.0`;

  print(net.toString());  // Should print `192.67.0.0/16`;

  print(net.mask.cidrLen);  // Should print `16`;

  print(net.contains(Ip4.parse('192.67.148.27')));  // Should print `true`;
  print(net.contains(Ip4.parse('192.68.148.27')));  // Should print `false`;
}
````

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
