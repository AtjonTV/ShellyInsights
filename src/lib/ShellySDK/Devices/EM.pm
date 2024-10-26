#  Software: ShellyInsights
#  File: ShellySDK/Devices/EM.pm
#  Copyright: 2024 Thomas Obernosterer
#  SPDX-License-Identifier: MPL-2.0
#
#  This Source Code Form is subject to the terms of the Mozilla Public
#  License, v. 2.0. If a copy of the MPL was not distributed with this
#  file, You can obtain one at http://mozilla.org/MPL/2.0/.

package ShellySDK::Devices::EM;
use strict;
use warnings FATAL => 'all';

use ShellySDK::RPC;

sub get_status {
    my $ip = shift;

    my %resp = ShellySDK::RPC::send_rpc($ip, "EM.GetStatus", {id => "0"});
    if ($resp{'status'} == -1 || $resp{'status'} == -2) {
        return "Failed to send request";
    }
    my $data = $resp{'data'};

    my $current_watts = $data->{'total_act_power'};

    return {
        current_watts => $current_watts,
    };
}

1;