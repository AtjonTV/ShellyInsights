#  Software: ShellyInsights
#  File: ShellySDK/Util.pm
#  Software: ShellyInsights
#  File: Util.pm
#  Copyright: 2024 Thomas Obernosterer
#  SPDX-License-Identifier: MPL-2.0
#
#  This Source Code Form is subject to the terms of the Mozilla Public
#  License, v. 2.0. If a copy of the MPL was not distributed with this
#  file, You can obtain one at http://mozilla.org/MPL/2.0/.

package Util 0.1;
use strict;
use warnings FATAL => 'all';
use v5.34.0;

use DateTime::Duration 1.65;
use DateTime::Format::Duration 1.04;

sub format_uptime($) {
    my $uptime = shift;

    my $duration = DateTime::Duration->new(seconds => $uptime);

    my $formatter = DateTime::Format::Duration->new(
        pattern     => "%e days %H:%M:%S",
        normalize   => 1,
    );

    return $formatter->format_duration($duration);
}

1;