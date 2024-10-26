#!/usr/bin/perl
#  Software: ShellyInsights
#  File: main.pl
#  Copyright: 2024 Thomas Obernosterer
#  SPDX-License-Identifier: MPL-2.0
#
#  This Source Code Form is subject to the terms of the Mozilla Public
#  License, v. 2.0. If a copy of the MPL was not distributed with this
#  file, You can obtain one at http://mozilla.org/MPL/2.0/.

use strict;
use warnings FATAL => 'all';
use v5.34.0;

use lib 'lib/';
use ShellySDK::RPC::EM 0.1;
use ShellySDK::RPC::Shelly 0.1;
use Util 0.1;

my $device_ip = "10.1.0.90";

sub get_status() {
    my $new_status = ShellySDK::RPC::EM::get_status($device_ip)->{'current_watts'};
    return $new_status;
}
sub get_uptime() {
    my $new_status = ShellySDK::RPC::Shelly::get_status($device_ip)->{'uptime'};
    my $formatted = Util::format_uptime($new_status);
    return $formatted;
}

use Prima 1.74 qw(Application Buttons Label MDI Menus);

my $wnd = Prima::MDIWindowOwner->new(
    text      => 'Shelly Insights v0.0.5',
    menuItems => [
        [ '~File' => [
            [ '~Exit', 'Alt+X', '@X', sub {exit} ],
        ] ],
        [ '~Widgets' => [
            [ '~Current Power', '', '', \&mdi_pro_3em ],
        ] ],
    ],
    style     => "classic",
);

sub mdi_pro_3em {
    my $mdi = $wnd->insert('MDI',
        text     => "Power",
        size     => [ 400, 100 ],
        centered => 1
    );

    my $box = $mdi->client->insert(Widget =>
        expand                            => 1,
        pack                              => { side => "top" },
    );

    my $row1 = $box->insert(Widget =>
        pack                       => { side => "top" },
        left                       => 0
    );

    $row1->insert(Label =>
        text            => 'Watts: ',
        pack            => { side => "left" },
    );
    my $lblWatts = $row1->insert(Label =>
        text                           => '???',
        pack                           => { side => "left" },
    );

    my $row2 = $box->insert(Widget =>
        pack                       => { side => "top" },
    );
    $row2->insert(Label =>
        text            => 'Uptime: ',
        pack            => { side => "left" },
    );
    my $lblUptime = $row2->insert(Label =>
        text                               => '???',
        pack                               => { side => "left" },
    );

    my $timer = Prima::Timer->create(
        timeout => 1000, # milliseconds
        onTick  => sub {
            $lblWatts->set_text(get_status());
            $lblUptime->set_text(get_uptime());
        },
    );
    $timer->start();
}

Prima->run();
