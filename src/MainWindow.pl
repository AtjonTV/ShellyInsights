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

use Prima qw(Application VB::VBLoader);

my $lblWatts;
my $ret = Prima::VBLoad("./src/MainWindow.fm",
    lblWatts => {
        onCreate => sub {
            $lblWatts = shift;
        }
    },
    btnRefresh => {
        onClick => sub {
            my $new_status = get_status();
            $lblWatts->set_text("Watts: $new_status");
        }
    }
);
die "$@\n" unless defined $ret;
$ret-> execute;

run Prima;
