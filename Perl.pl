use strict;
use warnings;
use File::Find;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use Digest::file qw(digest_file_hex);

my $DB_Name = 'save.ini';
my %map_digest;
my @fileList;

Menu();
sub Menu {
    while (1){
        print "Enter 1:  Giam Sat File. \n";
        print "Enter 2:  Kiem Tra Giam Sat Thu Muc. \n";
        print "Enter 3:  Luu Trang Thai Thu Muc. \n";
        print "Enter 0: Thoat.\n";
        
        my $menu = <STDIN>;
        chomp $menu;

        if ($menu == 1) {
            monitorFile();
        }elsif ($menu == 2){
            my $foldername = InputFolder();            
            monitorFolder($foldername);
        }if ($menu == 3) {
            my $foldername = InputFolder();
            saveFolderStatus($foldername);
        }elsif ($menu == 0){
            exit;
        }
    }
}

sub monitorFile {
    print "Nhap File Theo Can Giam Sat: ";
    my $fileinput = <STDIN>;
    chomp $fileinput;

    open DATA, "<$fileinput" or die "File Not Exit";

    my $olddigest = md5_hex(<DATA>);
    close(DATA);

    writeDB("$fileinput:$olddigest");

    while (1) {
        open (DATAFILE, "<$fileinput") or die ("error initial File");
        my $newdigest = md5_hex(<DATAFILE>);
        close(DATAFILE);
        if ($newdigest eq $olddigest){
            sleep 1;
        } else {
            print "File changed \n";
            exit;
        }
    }
}
sub ReadDB {
    open(my $fh, '<', $DB_Name) or die "Could not open file '$DB_Name' $!";;
    while(my $line = <$fh>){
        chomp($line);
        my ($key,$digest) = split(':', $line);
        $map_digest{$key} = $digest;
    }
    close($fh);
}

sub InputFolder {
    print "Nhap Thu Muc Can Giam Sat: ";
    my $directory = <STDIN>;
    chomp $directory;
    opendir (DIR, $directory) or die $!;

    return $directory
}
sub monitorFolder {
    my $directory;
    foreach (@_) {
        $directory = $_;
    } 

    ReadDB();
    opendir (DIR, $directory) or die $!;
    find(\&getFile,  $directory);
    #print @fileList;
    foreach my $filename (@fileList){ 
        if (exists $map_digest{$filename}) { 
            if ($map_digest{$filename} ne digest_file_hex($filename, "MD5")){
                print "File $filename changed! \n";
            }
            else{
                print "File $filename not changed! \n";
            }
        }else{
            print "File $filename changed name! \n";
            if(-e $directory.'/'.$filename){
                print "File $filename changed name!!! \n";
            }else{
                print "File $filename is not exist!";
            }
        }
    }
    
}

sub saveFolderStatus {
    my $directory;
    foreach (@_) {
        $directory = $_;
    }  
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

sub getFile {
        push @fileList, $File::Find::name;
}