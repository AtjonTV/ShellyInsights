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

use lib 'lib/';
use ShellySDK::Devices::EM;

sub get_status {
    my $new_status = ShellySDK::Devices::EM::get_status("10.1.0.90")->{'current_watts'};
    $new_status = int($new_status);
    return $new_status;
}

use Prima qw(Application MDI Buttons Label);

my $wnd = Prima::MDIWindowOwner->new(
    text => 'Shelly Insights v0.0.3',
);
my $mdi = $wnd->insert('MDI',
    text => "Pro 3EM",
    size => [ 200, 100 ],
);

sub mdi_pro_3em {
    my $box = $mdi->client->insert(Widget =>
        expand => 1,
        pack => {side => "top"},
    );

    my $lbl = $box->insert(Label =>
        text                     => 'Watts: ???',
        pack                     => { side => "left" },
    );

    my $timer = Prima::Timer->create(
        timeout => 500, # milliseconds
        onTick  => sub {
            my $new_status = get_status();
            $lbl->set_text("Watts: $new_status");
        },
    );
    $timer->start();
}
mdi_pro_3em();

run Prima;
