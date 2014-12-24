#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use Encode;
use Time::Piece;

my $MAIL_FROM = 'from@example.net';
my $SENDMAIL = '/usr/sbin/sendmail';
my $NKF = '/usr/bin/nkf';
my $MAIL_TO = shift;
my $MAIL_FILE = shift;

my @mail_line;
{
    open (my $fh_mail_file,'<',$MAIL_FILE) or die $!;
    @mail_line = <$fh_mail_file>;
    chomp @mail_line;
    for (@mail_line){
        my $t = localtime();
        s/%Y/$t->year/eg;
        s/%m/$t->mon/eg;
        s/%d/$t->mday/eg;
    }
    close $fh_mail_file;
}

open(my $pipe_sendmail,'|-',"$SENDMAIL -i -f $MAIL_FROM $MAIL_TO");
{
    my $date;
    {
        $ENV{'TZ'} = "JST-9";
        my ($sec,$min,$hour,$mday,$mon,$year,$wday) = localtime(time);
        my @week = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
        my @month = ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');
        $date = sprintf("%s, %d %s %04d %02d:%02d:%02d +0900 (JST)", $week[$wday],$mday,$month[$mon],$year+1900,$hour,$min,$sec);
    }
    my $message_id = time() . $MAIL_FROM;
    my $subject = `echo '$mail_line[0]' | $NKF -W -M -w`;
    shift @mail_line;
    chomp $subject;
    print $pipe_sendmail <<"HEADER";
From: $MAIL_FROM
To: $MAIL_TO
Content-Type: text/plain; charset=UTF-8
Message-Id: <$message_id>
Date: $date
Subject: $subject
Content-Transfer-Encoding: 8bit

HEADER
}
for (@mail_line){
    print $pipe_sendmail "$_\n";
}
