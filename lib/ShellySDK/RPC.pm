#  Software: ShellyInsights
#  File: ShellySDK/RPC.pm
#  Copyright: 2024 Thomas Obernosterer
#  SPDX-License-Identifier: MPL-2.0
#
#  This Source Code Form is subject to the terms of the Mozilla Public
#  License, v. 2.0. If a copy of the MPL was not distributed with this
#  file, You can obtain one at http://mozilla.org/MPL/2.0/.

package ShellySDK::RPC 0.2;

use strict;
use warnings FATAL => 'all';
use v5.34.0;

use HTTP::Request 6.36 ();
use LWP::UserAgent 6.61;
use JSON::MaybeXS 1.004008 qw(encode_json decode_json);

sub payload_with_params($$) {
    my $method = shift;
    my $params = shift;

    return { id => 0, method => $method, params => $params };
}

sub payload_only_method($) {
    my $method = shift;
    return { id => 0, method => $method };
}

sub _rec_rewrite_hash {
    my $in_hash = shift;
    my $in_iter = shift;

    if ($in_iter > 10) {
        print("ShellySDK::RPC::rec_rewrite_hash reached recursion limit of 10 iterations.\n");
        exit(-1);
    }

    my %out_hash = ();

    foreach my $key (keys %$in_hash) {
        my $value = $in_hash->{$key};
        if (defined($value)) {
            if (UNIVERSAL::isa( $value, 'HASH' )) {
                # print("$in_iter Key: $key\n");
                $out_hash{$key} = _rec_rewrite_hash($value, $in_iter + 1);
            } else {
                # print("$in_iter Key: $key\n");
                # print("$in_iter Value: " . $value . "\n\n");
                $out_hash{$key} = $value;
            }
        }
    }
    return \%out_hash;
}

our $rpc_id = 0;
sub send_rpc($$) {
    my $ip = shift;
    my $data = shift;

    # copy rpc_id and use it for the request
    my $this_id = $rpc_id;
    $data->{'id'} = $this_id;

    my $url = "http://$ip/rpc";
    my $header = [ 'Content-Type' => 'application/json; charset=UTF-8' ];
    my $encoded_data = encode_json($data);

    my $request = HTTP::Request->new('POST', $url, $header, $encoded_data);
    # increment rpc_id for the next request.
    $rpc_id = $rpc_id + 1;

    my $ua = LWP::UserAgent->new();
    my $response = $ua->request($request);

    if ($response->is_success()) {
        my $decoded = $response->decoded_content();
        my $json = decode_json($decoded);

        # validate the response is for this request.
        if ($json->{'id'} == $this_id) {
            my %result = ();
            $result{'data'} = _rec_rewrite_hash($json->{'result'}, 0);
            $result{'status'} = 0;
            return %result;
        }
        else {
            return { status => -1, error => "response id does not match request id" };
        }
    }
    my $http_status = $response->status_line();
    return { status => -2, error => "http response is $http_status" };
}

1;