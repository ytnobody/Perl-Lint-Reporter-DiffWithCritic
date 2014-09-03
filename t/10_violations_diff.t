use strict;
use Test::More;
use Perl::Lint::Reporter::DiffWithCritic;
use Perl::Lint qw/lint/;

my $violations = lint([__FILE__]);
my @diff_list = violations_diff($violations, -severity => 1);

for my $diff (@diff_list) {
    isa_ok $diff, 'HASH';
    is_deeply [sort keys %$diff], [qw/description explanation filename line policy status/], 'keys = ["description", "explanation", "filename", "line", "policy", "status"]';
    like $diff->{line}, qr/^[0-9]+$/;
    if (defined $diff->{status}) {
        like $diff->{status}, qr/^(ins|del)$/;
    }
    else {
        is $diff->{status}, undef;
    }
}

done_testing;
