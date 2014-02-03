CodeForces Helper Tool: cftool
======

	A Tool for Codeforces Contests by GangsterVeggies


A CodeForces helper tool for regular rounds in Ruby.

To run the code you must have Ruby installed (2.0.0 recommended but 1.9.3 should be fine).

Runs in Linux and Windows (tested) and should run in other unix system like Mac (untested). Linux is prefered obviously.

## Features

It only works with C++ code (sorry, no Java). It generates templated files (currenlty static) for all problems, gets the test cases, compiles the code and runs it with all test cases or with one in particular. Another cool feature is that CodeForces enforces the use of "%I64d" in reading or writing long long int variables, which doesn't compile in a lot of local systems. The tool has an option (-l) that when compiling code it automatically converts the "%I64d" to "%lld" and compiles it like so, leaving the original file untouched.

## How to use

Usage:

	./cftool [options]

List of Arguments:

	-h, --help

Displays the help text

	-g, --generate

Generates A, B, C, D and E templated cpp files

	-p, --prepare <contest>
	
Prepares the test cases of 'contest' (needs to be done before -r or -t)

	-r, --run <code_file>,<problem>

Runs the <code_file> cpp file to the test cases of 'problem' [A, B, C, D, E] from the prepared contest

	-r, --run <problem>

Assumes the code file is 'problem'.cpp and runs it to the test cases of 'problem' [A, B, C, D, E] from the prepared contest

	-t, --runtest <code_file>,<problem>,<case>
	
Runs the 'code_file' cpp file to the test case 'case' of 'problem' [A, B, C, D, E] from the prepared contest

	-l, --[no-]long
	
Code contains a long long int %64d to convert to %lld on local system (to use with -r)

	-s, --reset
	
Delete any cftools configuration files present

IMPORTANT NOTICE: The 'contest's require the contest number, not the round number!
(for example round 227 div2 is contest 387)
