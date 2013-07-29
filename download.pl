#!/opt/bin/perl -w
use strict;
use XML::DOM;
use XML::Parser;
use LWP::UserAgent;
use LWP::Simple;
use DBI;
use File::Basename qw(basename);

# Hello


my $download_dir = "/volume1/watchfolder/";

sub get_rss_items{
	my $parser = new XML::DOM::Parser;
	my $ua = LWP::UserAgent->new;
	my $can_accept = HTTP::Message::decodable;
	my $response = $ua->get($_[0], 'Accept-Encoding' => $can_accept);
	my $decoded_rss = $response->decoded_content;

	my @result = ();
	my $doc = $parser->parse($decoded_rss);
	for my $item ($doc->getElementsByTagName('item', 1)){
		my $title = $item->getElementsByTagName('title')->item(0)->getFirstChild->getNodeValue;
		my $link = $item->getElementsByTagName('link')->item(0)->getFirstChild->getNodeValue;

		my $item = {
			title => $title,
			link => $link
		};
		
		push(@result, $item);
		
	}
	return @result;
}

sub get_wishes{
	my $dbh = DBI->connect('DBI:mysql:script', 'script', 'PfmySQL!'
				   ) || die "Could not connect to database: $DBI::errstr";

	my $db_wish = $dbh->selectall_arrayref('SELECT id, wish, quality FROM wishlist', { Slice => {}});

	my @result = ();
	for my $row (@$db_wish){
		
		my $row = {
			id => $row->{id},
			wish => $row->{wish},
			quality => $row->{quality}
		};
		push(@result, $row);
	}

	$dbh->disconnect();

	return @result;
}


my @items = &get_rss_items('http://www.torrentday.com/torrents/rss?download;|11;|7;u=428237;tp=887f3b1d10049f24d6fddf65d2139b22');
my @wishlist = &get_wishes();



for my $wish (@wishlist) {
	for my $item (@items){
		if ($item->{title} =~ m/^$wish->{wish}.*$wish->{quality}/i){
			print "$item->{title} matched by $wish->{wish} \n";
			my $file_name = basename $item->{link};
			(my $local_filename, my $auth) = split(/\?/, $file_name); 
			my $dest = $download_dir.$local_filename;
			print "$local_filename $auth  --\n";
			getstore($item->{link}, $dest);
		}
	}
}


