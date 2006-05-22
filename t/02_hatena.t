# ----------------------------------------------------------------
    use strict;
    use Test::More tests => 4;
    BEGIN { use_ok('WebService::Hatena::BookmarkCount') };
# ----------------------------------------------------------------
    my $url = "http://www.hatena.ne.jp/info/webservices";
    my $hash = WebService::Hatena::BookmarkCount->getCount( $url );
    ok( ref $hash, 'response hash' );
    my $count = $hash->{$url};
    ok( defined $count, 'response value' );
    $count ||= 0;
    ok( (0 < $count), "$url $count" );
# ----------------------------------------------------------------
;1;
# ----------------------------------------------------------------
