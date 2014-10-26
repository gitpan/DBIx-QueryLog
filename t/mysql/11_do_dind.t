use strict;
use warnings;
use Test::Requires qw(DBD::mysql Test::mysqld);
use Test::More;
use Test::mysqld;
use t::Util;
use DBIx::QueryLog ();
use DBI;

my $mysqld = Test::mysqld->new(my_cnf => {
    'skip-networking' => '',
}) or plan skip_all => $Test::mysqld::errstr;

my $dbh = DBI->connect(
    $mysqld->dsn(dbname => 'mysql'), '', '',
    {
        AutoCommit => 1,
        RaiseError => 1,
    },
) or die $DBI::errstr;

DBIx::QueryLog->begin;

my $res = capture {
    $dbh->do('SELECT * FROM user WHERE User = ?', undef, 'root');
};

like $res, qr/SELECT \* FROM user WHERE User = 'root'/;

done_testing;
