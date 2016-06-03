package WWW::YoutubeViewer::Channels;

use utf8;
use 5.014;
use warnings;

=head1 NAME

WWW::YoutubeViewer::Channels - Channels interface.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use WWW::YoutubeViewer;
    my $obj = WWW::YoutubeViewer->new(%opts);
    my $videos = $obj->channels_from_categoryID($category_id);

=head1 SUBROUTINES/METHODS

=cut

sub _make_channels_url {
    my ($self, %opts) = @_;
    return $self->_make_feed_url('channels', %opts);
}

=head2 channels_from_categoryID($category_id)

Return the YouTube channels associated with the specified category.

=head2 channels_info($channel_id)

Return information for the comma-separated list of the YouTube channel ID(s).

=head1 Channel details

For all functions, C<$channels->{results}{items}> contains:

    [
       {
        id => "....",
        kind => "youtube#channel",
            snippet => {
            description => "...",
            publishedAt => "2010-06-24T23:15:37.000Z",
            thumbnails => {
                default => { url => "..." },
                high    => { url => "..." },
                medium  => { url => "..." },
            },
            title => "...",
          },  # end of snippet
       },
        ...
    ];

=cut

{
    no strict 'refs';

    foreach my $method (
                        {
                         key  => 'categoryId',
                         name => 'channels_from_guide_category',
                        },
                        {
                         key  => 'id',
                         name => 'channels_info',
                        },
                        {
                         key  => 'forUsername',
                         name => 'channels_from_username',
                        },
      ) {
        *{__PACKAGE__ . '::' . $method->{name}} = sub {
            my ($self, $id) = @_;
            return $self->_get_results($self->_make_channels_url($method->{key} => $id));
        };
    }

    foreach my $part (qw(id contentDetails statistics topicDetails)) {
        *{__PACKAGE__ . '::' . 'channels_' . $part} = sub {
            my ($self, $id) = @_;
            return $self->_get_results($self->_make_channels_url(id => $id, part => $part));
        };
    }
}

=head2 my_channel()

Returns info about the channel of the current authenticated user.

=cut

sub my_channel {
    my ($self) = @_;
    return $self->_get_results($self->_make_channels_url(part => 'snippet', mine => 'true'));
}

=head2 channels_my_subscribers()

Retrieve a list of channels that subscribed to the authenticated user's channel.

=cut

sub channels_my_subscribers {
    my ($self) = @_;
    $self->get_access_token() // return;
    return $self->_get_results($self->_make_channels_url(mySubscribers => 'true'));
}

=head2 channel_id_from_username($username)

Return the channel id for an username.

=cut

sub channel_id_from_username {
    my ($self, $username) = @_;
    my $channel = $self->channels_from_username($username) // return;
    $channel->{results}{items}[0]{id} // return;
}

=head2 channels_contentDetails($channelID)

  {
    items    => [
                  {
                    contentDetails => {
                      relatedPlaylists => {
                        likes   => "LLwiIs5V6-zX8xaYgwhRhsHQ",
                        uploads => "UUwiIs5V6-zX8xaYgwhRhsHQ",
                      },
                    },
                    etag => "...",
                    id => "UCwiIs5V6-zX8xaYgwhRhsHQ",
                    kind => "youtube#channel",
                  },
                ],
    kind     => "youtube#channelListResponse",
    pageInfo => { resultsPerPage => 1, totalResults => 1 },
  },

=head2 channels_statistics($channelID);

  {
    items    => [
                  {
                    etag => "...",
                    id => "UCwiIs5V6-zX8xaYgwhRhsHQ",
                    kind => "youtube#channel",
                    statistics => {
                      commentCount    => 14,
                      subscriberCount => 313823,
                      videoCount      => 474,
                      viewCount       => 1654024,
                    },
                  },
                ],
    kind     => "youtube#channelListResponse",
    pageInfo => { resultsPerPage => 1, totalResults => 1 },
  },

=head2 channels_topicDetails($channelID)

    items    => [
                  {
                    etag => "...",
                    id => "UCwiIs5V6-zX8xaYgwhRhsHQ",
                    kind => "youtube#channel",
                    topicDetails => {
                      topicIds => [
                        "/m/027lnzs",
                        "/m/0cp07v2",
                            ...
                      ],
                    },
                  },
                ],
    kind     => "youtube#channelListResponse",
    pageInfo => { resultsPerPage => 1, totalResults => 1 },

=cut

=head1 AUTHOR

Trizen, C<< <trizenx at gmail.com> >>


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::YoutubeViewer::Channels


=head1 LICENSE AND COPYRIGHT

Copyright 2013-2015 Trizen.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See L<http://dev.perl.org/licenses/> for more information.

=cut

1;    # End of WWW::YoutubeViewer::Channels
