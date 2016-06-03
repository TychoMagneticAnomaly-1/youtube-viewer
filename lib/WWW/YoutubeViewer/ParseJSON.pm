package WWW::YoutubeViewer::ParseJSON;

use utf8;
use 5.014;
use warnings;

=head1 NAME

WWW::YoutubeViewer::ParseJSON - Parse JSON content.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use WWW::YoutubeViewer::ParseJSON;
    my $obj = WWW::YoutubeViewer::ParseJSON->new(%opts);

=head1 SUBROUTINES/METHODS

=cut

=head2 parse_json_string($json_string)

Parse a JSON string and return a HASH ref.

=cut

sub parse_json_string {
    my ($self, $json) = @_;

    if (not defined($json) or $json eq '') {
        return {};
    }

    state $x = require JSON;
    my $hash = eval { JSON::decode_json($json) };
    return $@ ? do { warn "[JSON]: $@\n"; {} } : $hash;
}

=head2 make_json_string($ref)

Create a JSON string from a HASH or ARRAY ref.

=cut

sub make_json_string {
    my ($self, $ref) = @_;
    state $x = require JSON;
    my $str = eval { JSON::encode_json($ref) };
    return $@ ? do { warn "[JSON]: $@\n"; '' } : $str;
}

=head1 AUTHOR

Trizen, C<< <trizenx at gmail.com> >>


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::YoutubeViewer::ParseJSON


=head1 LICENSE AND COPYRIGHT

Copyright 2013-2015 Trizen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.

=cut

1;    # End of WWW::YoutubeViewer::ParseJSON
