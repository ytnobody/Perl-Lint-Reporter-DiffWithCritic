use strict;
use warnings;
use Perl::Lint qw/lint/;
use Perl::Lint::Reporter::DiffWithCritic;

my $violations = lint([__FILE__]);
report_violations_diff($violations, -severity => 1);
