# ShellyInsights

> This is a Perl 5 learning project.  
> It is far from production grade software, and will never come close.  
> Use at your own risk.
 
ShellyInsights is a desktop app that allows fetching and show statistics from a [Shelly Pro 3EM](https://www.shelly.com/products/shelly-pro-3em-x1) power monitor.

The Shelly must be installed properly, according to its manual, and connected to a network.  

In my setup, it is connected via WiFi and has the IP `10.1.0.90`.  
The default settings of the Shelly already allow for local un-authenticated API access, this is required.

## Dependencies

* [Perl v5.34](https://www.perl.org/get.html#unix_like), Scripting Language
* [Prima v1.74](https://metacpan.org/dist/Prima), GUI Toolkit
* **LOCAL** [ShellySDK v0.1](/lib/ShellySDK.pm), Shelly RPC SDK
  * [HTTP::Request v6.36](https://metacpan.org/pod/HTTP::Request), HTTP Request/Response
  * [LWP::UserAgent v6.61](https://metacpan.org/pod/LWP::UserAgent), headless User Agent
  * [JSON::MaybeXS v1.004008](https://metacpan.org/pod/JSON::MaybeXS), JSON Encoder/Decoder

Later versions may also work, but have not been tested.  
Developed and Tested on `TUXEDO OS 3` (`Ubuntu 22.04`).

## Execution

If you have installed all non-local dependencies using CPAN, you can simply run the `main.pl` script.

# License

Copyright 2024 Thomas Obernosterer (https://atjon.tv).  
ShellyInsights is free software licensed under the Mozilla Public License, version 2.0.