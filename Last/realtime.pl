#!/usr/bin/perl
use strict;
use warnings;
use File::Find;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use Digest::file qw(digest_file_hex);


my $DB_Name = "/usr/lib/nagios/plugins/save.ini";
my %map_digest;
my @fileList;
#my $foldername = $ARGV[0];  
my $foldername = "/usr/lib/nagios/plugins/ParentFolder";
my $is_first = 1;

#print "OK ";exit(0);
monitorFolder($foldername);



sub monitorFolder {
    my $directory = shift(@_);


    ReadDB();

    opendir (DIR, $directory) or die $!;

    find(\&getFile,  $directory);
    foreach my $filename (@fileList){ 
        # New file
        if (!scalar($map_digest{$filename})) { doPrint($filename, "Created."); }
        # Change File
        elsif ($map_digest{$filename} ne digest_file_hex($filename, "MD5")) {
			my $text = "Changed ";
			&doPrint($filename, $text);
		}
    }

    closedir(DIR);
    
    foreach my $filename (keys %map_digest) {
        if (!-e $filename) { 
			&doPrint($filename, "Deleted.");
		}
	}
    if($is_first){
        print "All file is OK";
        exit(0);
    }else{
        exit(2);    
    }
}
sub ReadDB {

    open(my $fh, '<', $DB_Name) or print  "Could not open file '$DB_Name' $!";

    while(my $line = <$fh>){
        chomp($line);
        my ($key,$digest) = split(':', $line);
        $map_digest{$key} = $digest;
    }

     close($fh);
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
    $is_first = 0;
}
root@parallels-vm:/usr/lib/nagios/plugins# 
