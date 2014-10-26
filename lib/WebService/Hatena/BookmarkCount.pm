# ----------------------------------------------------------------
    package WebService::Hatena::BookmarkCount;
    use strict;
    use Carp;
    use XML::TreePP;
# ----------------------------------------------------------------
    use vars qw( $VERSION $XMLRPC_URL );
    $VERSION = "0.04";
    $XMLRPC_URL = 'http://b.hatena.ne.jp/xmlrpc';
# ----------------------------------------------------------------

=head1 NAME

WebService::Hatena::BookmarkCount -- Interface for Hatena::Bookmark's getCount XML-RPC API

=head1 SYNOPSIS

    use WebService::Hatena::BookmarkCount;
    my @list = (
	    "http://www.hatena.ne.jp/info/webservices",
	    "http://www.kawa.net/works/perl/hatena/bookmarkcount.html",
    );
    my $hash = WebService::Hatena::BookmarkCount->getCount( @list );
    foreach my $url ( @list ) {
        printf( "%5d   %s\n", $hash->{$url}, $url );
    }

=head1 DESCRIPTION

WebService::Hatena::BookmarkCount is a interface for 
"bookmark.getCount" method provided by Hatena::Bookmark XML-RPC API.

=head1 METHODS

=head2 $bgc = WebService::Hatena::BookmarkCount->new();

This constructor method creates a instance.

=head3 $hash = $bgc->getCount( @list );

This method make a call to "bookmark.getCount" method of the Hatena Web 
Services. The arguments is list of URLs to get a number of registrations 
in Hatena::Bookmark. This method returns a reference for a hash, which keys 
are URLs and which values are counts returned by the Hatena Web Services.

=head3 $hash = WebService::Hatena::BookmarkCount->getCount( @list );

You can call this method directly without creating a instance.

=head1 MODULE DEPENDENCIES

XML::TreePP  LWP::UserAgent

=head1 AUTHOR

Yusuke Kawasaki, E<lt>u-suke [at] kawa.netE<gt>
http://www.kawa.net/works/perl/treepp/treepp-e.html

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2006 Yusuke Kawasaki.  All rights reserved.  This program 
is free software; you can redistribute it and/or modify it under the same
terms as Perl itself.

=cut
# ----------------------------------------------------------------
    my $TREEPP_OPTIONS = { force_array => [qw( member )] };
# ----------------------------------------------------------------
sub new {
    my $package = shift;
    my $self = {@_};
    bless $self, $package;
    $self->{treepp} = XML::TreePP->new( %$TREEPP_OPTIONS );
    $self;
}
# ----------------------------------------------------------------
sub getCount {
    my $self = shift;
    $self = $self->new() unless ref $self;
    my $list = \@_;
    my $reqtree = {
      methodCall => {
        methodName => "bookmark.getCount",
        params => {
          param => [ map { {value=>{string =>$_}}; } @$list ]
        }
      }
    };
    my $reqxml = $self->{treepp}->write( $reqtree );
    my( $restree, $resxml ) = $self->{treepp}->parsehttp( POST => $XMLRPC_URL, $reqxml );
    my $outhash;
    if ( ref $restree &&
         ref $restree->{methodResponse} &&
         ref $restree->{methodResponse}->{params} &&
         ref $restree->{methodResponse}->{params}->{param} &&
         ref $restree->{methodResponse}->{params}->{param}->{value} &&
         ref $restree->{methodResponse}->{params}->{param}->{value}->{struct} &&
         ref $restree->{methodResponse}->{params}->{param}->{value}->{struct}->{member} ) {
        $outhash = {};
        foreach my $member ( @{$restree->{methodResponse}->{params}->{param}->{value}->{struct}->{member}}) {
            $outhash->{$member->{name}}= 0+$member->{value}->{int};
        }
    }
    wantarray ? ( $outhash, $reqxml, $resxml ) : $outhash;
}
# ----------------------------------------------------------------
;1;
# ----------------------------------------------------------------
