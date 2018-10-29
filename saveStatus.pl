#!/usr/bin/perl
#use strict;
#use warnings;
use File::Find;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use Digest::file qw(digest_file_hex);

my $DB_Name = 'save.ini';
my %map_digest;
my @fileList;

my $foldername = $ARGV[0];
saveFolderStatus($foldername);

sub saveFolderStatus {
    my $directory = shift(@_);
    opendir (DIR, $directory) or die $!;
    open(my $DBFILE, '>', $DB_Name);
    find(\&getFile,  $directory);

    foreach my $filename (@fileList){
        print $DBFILE "$filename:", digest_file_hex($filename, "MD5"),"\n" ; 
    }
    close($DBFILE);
    print "Luu Trang Thai Thanh Cong\n";
}
sub getFile {
    if (-d){
    }else{
        push @fileList, $File::Find::name;
    }
}
# Print out a file change in a consistent format
sub doPrint {
	my $fn = shift(@_);
	my $t = shift(@_);
	print $fn."\t\t".$t."\n";
}