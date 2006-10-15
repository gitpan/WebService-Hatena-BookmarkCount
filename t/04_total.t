# ----------------------------------------------------------------
    use strict;
    use Test::More;
# ----------------------------------------------------------------
    plan tests => 4;
    use_ok('WebService::Hatena::BookmarkCount');
    my $list = [qw(
        http://d.hatena.ne.jp/naoya/
        http://japan.cnet.com/
        http://www.itmedia.co.jp/
    )];
    foreach my $url ( @$list ) {
        chomp $url;
        my $cnt = WebService::Hatena::BookmarkCount->getTotalCount( $url );
        ok( ($cnt > 0), "$url => $cnt" );
    }
# ----------------------------------------------------------------
;1;
