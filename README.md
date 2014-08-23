# NAME

Perl::Lint::Reporter::DiffWithCritic - Reporter tool for Perl::Lint with differences to Perl::Critic

# SYNOPSIS

    use Perl::Lint qw/lint/;
    use Perl::Lint::Reporter::DiffWithCritic;
    my $violations = lint(['/path/to/target.pl']);
    report_violations_diff($violations, -severity => 1);

# DESCRIPTION

Perl::Lint::Reporter::DiffWithCritic is a reporter tool for Perl::Lint with differences to Perl::Critic

# EXAMPLE IMAGE

<div>
    <img src="http://i.gyazo.com/616b84e8d7e9b9beaf045eac5918a2f7.png">
</div>

# EXPORTS

## report\_violations\_diff($violations, %perl\_critic\_options);

Output a report that about differences of violation among Perl::Lint and Perl::Critic

# LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

ytnobody <ytnobody@gmail.com>
