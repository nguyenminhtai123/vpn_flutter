import 'dart:convert';

import 'package:eye_vpn_lite/apis/vpn_free_repository.dart';
import 'package:eye_vpn_lite/models/vpn_free.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/ad_helper.dart';
import '../helpers/my_dialogs.dart';
import '../helpers/pref.dart';
import '../models/vpn.dart';
import '../models/vpn_config.dart';
import '../services/vpn_engine.dart';

class HomeController extends GetxController {
  // final Rx<Vpn> vpn = Pref.vpn.obs;
  final Rx<Datum> vpnFree = Pref.datum.obs;

  final vpnState = VpnEngine.vpnDisconnected.obs;

  void connectToFreeVpn() async {
    if (vpnFree.value.hostname!.isEmpty) {
      MyDialogs.info(msg: 'Select a Location by clicking \'Change Location\'');
      return;
    }

    if (vpnState.value == VpnEngine.vpnDisconnected) {
      final config =
          "###############################################################################\r\n# OpenVPN 2.0 Sample Configuration File\r\n# for PacketiX VPN / SoftEther VPN Server\r\n# \r\n# !!! AUTO-GENERATED BY SOFTETHER VPN SERVER MANAGEMENT TOOL !!!\r\n# \r\n# !!! YOU HAVE TO REVIEW IT BEFORE USE AND MODIFY IT AS NECESSARY !!!\r\n# \r\n# This configuration file is auto-generated. You might use this config file\r\n# in order to connect to the PacketiX VPN / SoftEther VPN Server.\r\n# However, before you try it, you should review the descriptions of the file\r\n# to determine the necessity to modify to suitable for your real environment.\r\n# If necessary, you have to modify a little adequately on the file.\r\n# For example, the IP address or the hostname as a destination VPN Server\r\n# should be confirmed.\r\n# \r\n# Note that to use OpenVPN 2.0, you have to put the certification file of\r\n# the destination VPN Server on the OpenVPN Client computer when you use this\r\n# config file. Please refer the below descriptions carefully.\r\n\r\n\r\n###############################################################################\r\n# Specify the type of the layer of the VPN connection.\r\n# \r\n# To connect to the VPN Server as a \"Remote-Access VPN Client PC\",\r\n#  specify 'dev tun'. (Layer-3 IP Routing Mode)\r\n#\r\n# To connect to the VPN Server as a bridging equipment of \"Site-to-Site VPN\",\r\n#  specify 'dev tap'. (Layer-2 Ethernet Bridgine Mode)\r\n\r\ndev tun\r\n\r\n\r\n###############################################################################\r\n# Specify the underlying protocol beyond the Internet.\r\n# Note that this setting must be correspond with the listening setting on\r\n# the VPN Server.\r\n# \r\n# Specify either 'proto tcp' or 'proto udp'.\r\n\r\nproto tcp\r\n\r\n\r\n###############################################################################\r\n# The destination hostname / IP address, and port number of\r\n# the target VPN Server.\r\n# \r\n# You have to specify as 'remote <HOSTNAME> <PORT>'. You can also\r\n# specify the IP address instead of the hostname.\r\n# \r\n# Note that the auto-generated below hostname are a \"auto-detected\r\n# IP address\" of the VPN Server. You have to confirm the correctness\r\n# beforehand.\r\n# \r\n# When you want to connect to the VPN Server by using TCP protocol,\r\n# the port number of the destination TCP port should be same as one of\r\n# the available TCP listeners on the VPN Server.\r\n# \r\n# When you use UDP protocol, the port number must same as the configuration\r\n# setting of \"OpenVPN Server Compatible Function\" on the VPN Server.\r\n\r\nremote 219.100.37.187 443\r\n\r\n\r\n###############################################################################\r\n# The HTTP/HTTPS proxy setting.\r\n# \r\n# Only if you have to use the Internet via a proxy, uncomment the below\r\n# two lines and specify the proxy address and the port number.\r\n# In the case of using proxy-authentication, refer the OpenVPN manual.\r\n\r\n;http-proxy-retry\r\n;http-proxy [proxy server] [proxy port]\r\n\r\n\r\n###############################################################################\r\n# The encryption and authentication algorithm.\r\n# \r\n# Default setting is good. Modify it as you prefer.\r\n# When you specify an unsupported algorithm, the error will occur.\r\n# \r\n# The supported algorithms are as follows:\r\n#  cipher: [NULL-CIPHER] NULL AES-128-CBC AES-192-CBC AES-256-CBC BF-CBC\r\n#          CAST-CBC CAST5-CBC DES-CBC DES-EDE-CBC DES-EDE3-CBC DESX-CBC\r\n#          RC2-40-CBC RC2-64-CBC RC2-CBC\r\n#  auth:   SHA SHA1 MD5 MD4 RMD160\r\n\r\ncipher AES-128-CBC\r\nauth SHA1\r\n\r\n\r\n###############################################################################\r\n# Other parameters necessary to connect to the VPN Server.\r\n# \r\n# It is not recommended to modify it unless you have a particular need.\r\n\r\nresolv-retry infinite\r\nnobind\r\npersist-key\r\npersist-tun\r\nclient\r\nverb 3\r\n#auth-user-pass\r\n\r\n\r\n###############################################################################\r\n# The certificate file of the destination VPN Server.\r\n# \r\n# The CA certificate file is embedded in the inline format.\r\n# You can replace this CA contents if necessary.\r\n# Please note that if the server certificate is not a self-signed, you have to\r\n# specify the signer's root certificate (CA) here.\r\n\r\n<ca>\r\n-----BEGIN CERTIFICATE-----\r\nMIIFazCCA1OgAwIBAgIRAIIQz7DSQONZRGPgu2OCiwAwDQYJKoZIhvcNAQELBQAw\r\nTzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh\r\ncmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMTUwNjA0MTEwNDM4\r\nWhcNMzUwNjA0MTEwNDM4WjBPMQswCQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJu\r\nZXQgU2VjdXJpdHkgUmVzZWFyY2ggR3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBY\r\nMTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAK3oJHP0FDfzm54rVygc\r\nh77ct984kIxuPOZXoHj3dcKi/vVqbvYATyjb3miGbESTtrFj/RQSa78f0uoxmyF+\r\n0TM8ukj13Xnfs7j/EvEhmkvBioZxaUpmZmyPfjxwv60pIgbz5MDmgK7iS4+3mX6U\r\nA5/TR5d8mUgjU+g4rk8Kb4Mu0UlXjIB0ttov0DiNewNwIRt18jA8+o+u3dpjq+sW\r\nT8KOEUt+zwvo/7V3LvSye0rgTBIlDHCNAymg4VMk7BPZ7hm/ELNKjD+Jo2FR3qyH\r\nB5T0Y3HsLuJvW5iB4YlcNHlsdu87kGJ55tukmi8mxdAQ4Q7e2RCOFvu396j3x+UC\r\nB5iPNgiV5+I3lg02dZ77DnKxHZu8A/lJBdiB3QW0KtZB6awBdpUKD9jf1b0SHzUv\r\nKBds0pjBqAlkd25HN7rOrFleaJ1/ctaJxQZBKT5ZPt0m9STJEadao0xAH0ahmbWn\r\nOlFuhjuefXKnEgV4We0+UXgVCwOPjdAvBbI+e0ocS3MFEvzG6uBQE3xDk3SzynTn\r\njh8BCNAw1FtxNrQHusEwMFxIt4I7mKZ9YIqioymCzLq9gwQbooMDQaHWBfEbwrbw\r\nqHyGO0aoSCqI3Haadr8faqU9GY/rOPNk3sgrDQoo//fb4hVC1CLQJ13hef4Y53CI\r\nrU7m2Ys6xt0nUW7/vGT1M0NPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNV\r\nHRMBAf8EBTADAQH/MB0GA1UdDgQWBBR5tFnme7bl5AFzgAiIyBpY9umbbjANBgkq\r\nhkiG9w0BAQsFAAOCAgEAVR9YqbyyqFDQDLHYGmkgJykIrGF1XIpu+ILlaS/V9lZL\r\nubhzEFnTIZd+50xx+7LSYK05qAvqFyFWhfFQDlnrzuBZ6brJFe+GnY+EgPbk6ZGQ\r\n3BebYhtF8GaV0nxvwuo77x/Py9auJ/GpsMiu/X1+mvoiBOv/2X/qkSsisRcOj/KK\r\nNFtY2PwByVS5uCbMiogziUwthDyC3+6WVwW6LLv3xLfHTjuCvjHIInNzktHCgKQ5\r\nORAzI4JMPJ+GslWYHb4phowim57iaztXOoJwTdwJx4nLCgdNbOhdjsnvzqvHu7Ur\r\nTkXWStAmzOVyyghqpZXjFaH3pO3JLF+l+/+sKAIuvtd7u+Nxe5AW0wdeRlN8NwdC\r\njNPElpzVmbUq4JUagEiuTDkHzsxHpFKVK7q4+63SM1N95R1NbdWhscdCb+ZAJzVc\r\noyi3B43njTOQ5yOf+1CceWxG1bQVs5ZufpsMljq4Ui0/1lvh+wjChP4kqKOJ2qxq\r\n4RgqsahDYVvTH9w7jXbyLeiNdd8XM2w9U/t7y0Ff/9yi0GE44Za4rF2LN9d11TPA\r\nmRGunUHBcnWEvgJBQl9nJEiU0Zsnvgc/ubhPgXRR4Xq37Z0j4r7g1SgEEzwxA57d\r\nemyPxgcYxn/eR44/KJ4EBs+lVDR3veyJm+kXQ99b21/+jh5Xos1AnX5iItreGCc=\r\n-----END CERTIFICATE-----\r\n\r\n</ca>\r\n\r\n\r\n###############################################################################\r\n# The client certificate file (dummy).\r\n# \r\n# In some implementations of OpenVPN Client software\r\n# (for example: OpenVPN Client for iOS),\r\n# a pair of client certificate and private key must be included on the\r\n# configuration file due to the limitation of the client.\r\n# So this sample configuration file has a dummy pair of client certificate\r\n# and private key as follows.\r\n\r\n<cert>\r\n-----BEGIN CERTIFICATE-----\r\nMIICxjCCAa4CAQAwDQYJKoZIhvcNAQEFBQAwKTEaMBgGA1UEAxMRVlBOR2F0ZUNs\r\naWVudENlcnQxCzAJBgNVBAYTAkpQMB4XDTEzMDIxMTAzNDk0OVoXDTM3MDExOTAz\r\nMTQwN1owKTEaMBgGA1UEAxMRVlBOR2F0ZUNsaWVudENlcnQxCzAJBgNVBAYTAkpQ\r\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5h2lgQQYUjwoKYJbzVZA\r\n5VcIGd5otPc/qZRMt0KItCFA0s9RwReNVa9fDRFLRBhcITOlv3FBcW3E8h1Us7RD\r\n4W8GmJe8zapJnLsD39OSMRCzZJnczW4OCH1PZRZWKqDtjlNca9AF8a65jTmlDxCQ\r\nCjntLIWk5OLLVkFt9/tScc1GDtci55ofhaNAYMPiH7V8+1g66pGHXAoWK6AQVH67\r\nXCKJnGB5nlQ+HsMYPV/O49Ld91ZN/2tHkcaLLyNtywxVPRSsRh480jju0fcCsv6h\r\np/0yXnTB//mWutBGpdUlIbwiITbAmrsbYnjigRvnPqX1RNJUbi9Fp6C2c/HIFJGD\r\nywIDAQABMA0GCSqGSIb3DQEBBQUAA4IBAQChO5hgcw/4oWfoEFLu9kBa1B//kxH8\r\nhQkChVNn8BRC7Y0URQitPl3DKEed9URBDdg2KOAz77bb6ENPiliD+a38UJHIRMqe\r\nUBHhllOHIzvDhHFbaovALBQceeBzdkQxsKQESKmQmR832950UCovoyRB61UyAV7h\r\n+mZhYPGRKXKSJI6s0Egg/Cri+Cwk4bjJfrb5hVse11yh4D9MHhwSfCOH+0z4hPUT\r\nFku7dGavURO5SVxMn/sL6En5D+oSeXkadHpDs+Airym2YHh15h0+jPSOoR6yiVp/\r\n6zZeZkrN43kuS73KpKDFjfFPh8t4r1gOIjttkNcQqBccusnplQ7HJpsk\r\n-----END CERTIFICATE-----\r\n\r\n</cert>\r\n\r\n<key>\r\n-----BEGIN RSA PRIVATE KEY-----\r\nMIIEpAIBAAKCAQEA5h2lgQQYUjwoKYJbzVZA5VcIGd5otPc/qZRMt0KItCFA0s9R\r\nwReNVa9fDRFLRBhcITOlv3FBcW3E8h1Us7RD4W8GmJe8zapJnLsD39OSMRCzZJnc\r\nzW4OCH1PZRZWKqDtjlNca9AF8a65jTmlDxCQCjntLIWk5OLLVkFt9/tScc1GDtci\r\n55ofhaNAYMPiH7V8+1g66pGHXAoWK6AQVH67XCKJnGB5nlQ+HsMYPV/O49Ld91ZN\r\n/2tHkcaLLyNtywxVPRSsRh480jju0fcCsv6hp/0yXnTB//mWutBGpdUlIbwiITbA\r\nmrsbYnjigRvnPqX1RNJUbi9Fp6C2c/HIFJGDywIDAQABAoIBAERV7X5AvxA8uRiK\r\nk8SIpsD0dX1pJOMIwakUVyvc4EfN0DhKRNb4rYoSiEGTLyzLpyBc/A28Dlkm5eOY\r\nfjzXfYkGtYi/Ftxkg3O9vcrMQ4+6i+uGHaIL2rL+s4MrfO8v1xv6+Wky33EEGCou\r\nQiwVGRFQXnRoQ62NBCFbUNLhmXwdj1akZzLU4p5R4zA3QhdxwEIatVLt0+7owLQ3\r\nlP8sfXhppPOXjTqMD4QkYwzPAa8/zF7acn4kryrUP7Q6PAfd0zEVqNy9ZCZ9ffho\r\nzXedFj486IFoc5gnTp2N6jsnVj4LCGIhlVHlYGozKKFqJcQVGsHCqq1oz2zjW6LS\r\noRYIHgECgYEA8zZrkCwNYSXJuODJ3m/hOLVxcxgJuwXoiErWd0E42vPanjjVMhnt\r\nKY5l8qGMJ6FhK9LYx2qCrf/E0XtUAZ2wVq3ORTyGnsMWre9tLYs55X+ZN10Tc75z\r\n4hacbU0hqKN1HiDmsMRY3/2NaZHoy7MKnwJJBaG48l9CCTlVwMHocIECgYEA8jby\r\ndGjxTH+6XHWNizb5SRbZxAnyEeJeRwTMh0gGzwGPpH/sZYGzyu0SySXWCnZh3Rgq\r\n5uLlNxtrXrljZlyi2nQdQgsq2YrWUs0+zgU+22uQsZpSAftmhVrtvet6MjVjbByY\r\nDADciEVUdJYIXk+qnFUJyeroLIkTj7WYKZ6RjksCgYBoCFIwRDeg42oK89RFmnOr\r\nLymNAq4+2oMhsWlVb4ejWIWeAk9nc+GXUfrXszRhS01mUnU5r5ygUvRcarV/T3U7\r\nTnMZ+I7Y4DgWRIDd51znhxIBtYV5j/C/t85HjqOkH+8b6RTkbchaX3mau7fpUfds\r\nFq0nhIq42fhEO8srfYYwgQKBgQCyhi1N/8taRwpk+3/IDEzQwjbfdzUkWWSDk9Xs\r\nH/pkuRHWfTMP3flWqEYgW/LW40peW2HDq5imdV8+AgZxe/XMbaji9Lgwf1RY005n\r\nKxaZQz7yqHupWlLGF68DPHxkZVVSagDnV/sztWX6SFsCqFVnxIXifXGC4cW5Nm9g\r\nva8q4QKBgQCEhLVeUfdwKvkZ94g/GFz731Z2hrdVhgMZaU/u6t0V95+YezPNCQZB\r\nwmE9Mmlbq1emDeROivjCfoGhR3kZXW1pTKlLh6ZMUQUOpptdXva8XxfoqQwa3enA\r\nM7muBbF0XN7VO80iJPv+PmIZdEIAkpwKfi201YB+BafCIuGxIF50Vg==\r\n-----END RSA PRIVATE KEY-----\r\n\r\n</key>";
      final vpnConfig = VpnConfig(
        country: vpnFree.value.region!,
        username: 'vpn',
        password: 'vpn',
        config: config,
      );
      await VpnEngine.startVpn(vpnConfig);
    } else {
      await VpnEngine.stopVpn();
    }
  }

  Future<void> getAccess() async {
    await FreeServerRepository.getAccess();
  }

  Future<void> killSession(String session_id) async {
    await FreeServerRepository.killSession(session_id);
  }

  Future<void> validateAds(String hashCode, String code) async {
    await FreeServerRepository.validateAds(hashCode, code);
  }

  void connectToVipServer(
    dynamic countryName,
    dynamic userName,
    dynamic password,
    dynamic config,
  ) async {
    if (vpnState.value == VpnEngine.vpnDisconnected) {
      // log('\nBefore: ${vpn.value.openVPNConfigDataBase64}');
      List<int> decodedBytes = base64.decode(config);
      final decodedConfig = utf8.decode(decodedBytes);

      final vpnConfig = VpnConfig(
          country: countryName,
          username: userName,
          password: password,
          config: '''
          $decodedConfig
          ''');

      // log('\nAfter: $config');

      //code to show interstitial ad and then connect to vpn
      AdHelper.showInterstitialAd(onComplete: () async {
        await VpnEngine.startVpn(vpnConfig);
      });
    } else {
      await VpnEngine.stopVpn();
    }
  }

  // vpn buttons color
  Color get getButtonColor {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return Colors.amber;

      case VpnEngine.vpnConnected:
        return Colors.green;

      default:
        return Colors.orangeAccent;
    }
  }

  // vpn button text
  String get getButtonText {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return 'Tap to Connect';

      case VpnEngine.vpnConnected:
        return 'Disconnect';

      default:
        return 'Connecting...';
    }
  }
}
