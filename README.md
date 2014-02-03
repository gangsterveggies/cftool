CodeForces Helper Tool: cftool
======

	A Tool for Codeforces Contests by GangsterVeggies


A CodeForces helper tool for regular rounds in Ruby.

To run the code you must have Ruby installed (2.0.0 recommended but 1.9.3 should be fine).

## How to use

Usage:

	./cftool [options]

List of Arguments:

	-h, --help

Displays the help text

	-g, --generate

Generates A, B, C, D and E templated cpp files

	-p, --prepare <contest>
	
Prepares the test cases of <contest> (needs to be done before -r or -t)

	-r, --run <code_file>,<problem>

Runs the <code_file> cpp file to the test cases of <problem> [A, B, C, D, E] from the prepared contest

	-t, --runtest <code_file>,<problem>,<case>
	
Runs the <code_file> cpp file to the test case <case> of <problem> [A, B, C, D, E] from the prepared contest

	-l, --[no-]long
	
Code contains a long long int %64d to convert to %lld on local system (to use with -r)

	-s, --reset
	
Delete any cftools configuration files present

IMPORTANT NOTICE: The 'contest's require the contest number, not the round number!
(for example round 227 div2 is contest 387)
