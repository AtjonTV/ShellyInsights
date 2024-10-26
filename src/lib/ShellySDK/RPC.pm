#  Software: ShellyInsights
#  File: ShellySDK/RPC.pm
#  Copyright: 2024 Thomas Obernosterer
#  SPDX-License-Identifier: MPL-2.0
#
#  This Source Code Form is subject to the terms of the Mozilla Public
#  License, v. 2.0. If a copy of the MPL was not distributed with this
#  file, You can obtain one at http://mozilla.org/MPL/2.0/.

package ShellySDK::RPC;

use strict;
use warnings FATAL => 'all';
use v5.34.0;

use HTTP::Request ();
use LWP::UserAgent;
use JSON::MaybeXS qw(encode_json decode_json);

our $rpc_id = 0;
sub send_rpc($$$) {
    my $ip = shift;
    my $method = shift;
    my $params = shift;

    my $url = "http://$ip/rpc";
    my $header = ['Content-Type' => 'application/json; charset=UTF-8'];
    # copy rpc_id and use it for the request
    my $this_id = $rpc_id;
    my $data = {id => $this_id, method => $method, params => $params};
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

            my $raw_result = $json->{'result'};
            foreach my $key (keys %$raw_result) {
                my $value = $raw_result->{$key};
                if (defined($value)) {
                    # print("Key: $key\n");
                    # print("Value: " . $raw_result->{$key} . "\n\n");
                    $result{'data'}{$key} = $raw_result->{$key};
                }
            }
            $result{'status'} = 0;
            return %result;
        } else {
            return {status => -1, error => "response id does not match request id"};
        }
    }
    my $http_status = $response->status_line();
    return {status => -2, error => "http response is $http_status"};
}

1;