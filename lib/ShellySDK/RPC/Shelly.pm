#  Software: ShellyInsights
#  File:
#  Copyright: 2024 Thomas Obernosterer
#  SPDX-License-Identifier: MPL-2.0
#
#  This Source Code Form is subject to the terms of the Mozilla Public
#  License, v. 2.0. If a copy of the MPL was not distributed with this
#  file, You can obtain one at http://mozilla.org/MPL/2.0/.

package ShellySDK::RPC::Shelly 0.1;
use strict;
use warnings FATAL => 'all';

use ShellySDK::RPC 0.2;

sub get_status($) {
    my $ip = shift;

    my %resp = ShellySDK::RPC::send_rpc($ip, ShellySDK::RPC::payload_only_method("Shelly.GetStatus"));
    if ($resp{'status'} == -1 || $resp{'status'} == -2) {
        return "Failed to send request";
    }
    my $data = $resp{'data'};
    my $sys = $data->{'sys'};

    my $uptime = $sys->{'uptime'};

    return {
        uptime => int($uptime),
    };
}

1;