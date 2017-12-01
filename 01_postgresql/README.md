# [Day 1](http://adventofcode.com/2017/day/1) in PostgreSQL

I've been doing some SQL recently, so this seems like a good exercise. I'm not
sure if SQL is even Turing-complete, but it should be possible to crack this
simple nut, before the puzzles get too complex. I'm using PostgreSQL 10.1 for
this, and I'm not going to bother checking whether my solution is actually
standard SQL – I'm sure it could be made so, if needed (which is never).

First problem: how to read from stdin (as per my house rules)? There is
[`pg_read_file`](https://www.postgresql.org/docs/8.2/static/functions-admin.html)
(obviously nonstandard) but it reads from files only. Let's use `/dev/stdin`
then, to make this even more platform-specific:

    SELECT pg_read_file('/dev/stdin', 0, 999999);

But no:

    $ psql -f 01a.sql 
    psql:01a.sql:1: ERROR:  must be superuser to read files

Okay, okay:

    $ psql -U postgres -f 01a.sql
    psql:01a.sql:1: ERROR:  absolute path not allowed

Turns out I should have read the docs better:

> The functions shown in Table 9-49 provide native file access to files on the
> machine hosting the server. Only files within the database cluster directory
> and the log_directory may be accessed.

Because the server is the process that actually reads the file, using stdin is
going to be difficult, if not impossible. So I'll just copy the input file:

    $ sudo cp input /var/lib/postgres/data/
    $ psql -U postgres -f 01a.sql 
    ... output!

After these hurdles, it was a fairly simple matter to split the input into a
numbered table (using another PostgreSQLism, `WITH ORDINALITY`), shift it by
one, join it, and sum the matches.

On to part two, which was mercifully not very different and a one-line change.
