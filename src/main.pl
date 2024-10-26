#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use lib 'lib/';
use ShellySDK::Devices::EM;

sub get_status {
    my $new_status = ShellySDK::Devices::EM::get_status("10.1.0.90")->{'current_watts'};
    $new_status = int($new_status);
    return $new_status;
}

print(get_status())