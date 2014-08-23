package Perl::Lint::Reporter::DiffWithCritic;
use 5.014;
use strict;
use warnings;

use parent 'Exporter';
use Perl::Critic;
use List::MoreUtils qw/uniq/;
use Text::WordDiff;

our $VERSION = 0.01;
our @EXPORT = qw/report_violations_diff/;

sub report_violations_diff {
    my ($violations, %critic_options) = @_;

    my @lint_vio_list = @$violations;
    my @files = uniq sort map {$_->{filename}} @lint_vio_list;

    my @critic_vio_list = _critic_violations([@files], %critic_options);

    _report_differences([@lint_vio_list], [@critic_vio_list]);
}

sub _critic_violations {
    my ($files, %critic_options) = @_;

    my $critic = Perl::Critic->new(%critic_options);

    my @violations = ();
    for my $file (@$files) {
        push @violations, $critic->critique($file);
    }

    return map {_transform_violation_lintstyle($_)} @violations;
}

sub _transform_violation_lintstyle {
    my $critic_vio = shift;
    +{
        explanation => $critic_vio->{_explanation},
        filename    => $critic_vio->filename,
        policy      => $critic_vio->policy =~ s/^Perl::Critic::/Perl::Lint::/r,
        line        => $critic_vio->line_number,
        description => $critic_vio->description,
    };
}

sub _report_differences {
    my ($lint_vio_list, $critic_vio_list) = @_;

    my $lint = _report_violations($lint_vio_list);
    my $critic = _report_violations($critic_vio_list);
    my $diff = word_diff \$lint, \$critic, {STYLE => 'ANSIColor'};
    print $diff;
}

sub _report_violations {
    my ($violations) = @_;

    my $report = '';

    my $line;
    for my $vio (sort {$a->{filename} cmp $b->{filename}} sort {$a->{line} <=> $b->{line}} @$violations) {
        $line = sprintf(
            "%s:%s\n  %s (%s)\n  [%s]\n\n", 
            $vio->{filename}, 
            $vio->{line}, 
            $vio->{description}, 
            $vio->{policy} =~ s/^Perl::Lint:://r, 
            ref $vio->{explanation} eq 'ARRAY' ? sprintf("See page %s of PBP", join(",", @{$vio->{explanation}})) : $vio->{explanation}
        );
        $report .= $line;
    }

    return $report;
}

1;
__END__

=encoding utf-8

=head1 NAME

Perl::Lint::Reporter::DiffWithCritic - Reporter tool for Perl::Lint with differences to Perl::Critic

=head1 SYNOPSIS

    use Perl::Lint qw/lint/;
    use Perl::Lint::Reporter::DiffWithCritic;
    my $violations = lint(['/path/to/target.pl']);
    report_violations_diff($violations, -severity => 1);

=head1 DESCRIPTION

Perl::Lint::Reporter::DiffWithCritic is a reporter tool for Perl::Lint with differences to Perl::Critic

=head1 EXAMPLE IMAGE

=begin html

<img src="http://i.gyazo.com/616b84e8d7e9b9beaf045eac5918a2f7.png">

=end html

=head1 EXPORTS

=head2 report_violations_diff($violations, %perl_critic_options);

Output a report that about differences of violation among Perl::Lint and Perl::Critic

=head1 LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ytnobody E<lt>ytnobody@gmail.comE<gt>

=cut

