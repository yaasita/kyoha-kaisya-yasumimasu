#!/usr/bin/perl
use strict;
use warnings;

use FindBin;
chdir $FindBin::Bin;

my @data;
{
    open (my $fh,'<','schedule.txt') or die $!;
    @data = <$fh>;
    close $fh;
}

open (my $wr, '>', 'schedule.txt') or die $!;
for (@data){
    if (
        /^\d{2}
        (?<year>\d{2})\/
        (?<month>\d{1,2})\/
        (?<day>\d{1,2})\s+
        (?<hhmm>\d{1,2}:\d{1,2})\s+
        (?<to>\S+)\s+
        (?<mail>\S+)/x
    ){
        open (my $at,'|-',"at '$+{hhmm} $+{month}/$+{day}/$+{year}'") or die $!;
        print $at "perl bin/sendmail.pl $+{to} $+{mail}";
        close $at;
        next;
    }
    print $wr $_;
}
close $wr;
