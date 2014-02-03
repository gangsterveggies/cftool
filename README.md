CodeForces Helper Tool: cftool
======

   ______          __     ______                         ______            __    
  / ____/___  ____/ /__  / ____/___  _____________  ____/_  __/___  ____  / /____
 / /   / __ \/ __  / _ \/ /_  / __ \/ ___/ ___/ _ \/ ___// / / __ \/ __ \/ / ___/
/ /___/ /_/ / /_/ /  __/ __/ / /_/ / /  / /__/  __(__  )/ / / /_/ / /_/ / (__  ) 
\____/\____/\__,_/\___/_/    \____/_/   \___/\___/____//_/  \____/\____/_/____/  

	---- A Tool for Codeforces Contests by GangsterVeggies


A CodeForces helper tool for regular rounds in Ruby.

To run the code you must have Ruby installed (2.0.0 recommended but 1.9.3 should be fine).

## How to use

Usage: ./cftool [options]
    -h, --help                       Displays this help text
    -g, --generate                   Generates A, B, C, D and E templated cpp files
    -p, --prepare <contest>          Prepares the test cases of <contest> (needs to be done before -r or -t)
    -r, --run <code_file>,<problem>  Runs the <code_file> cpp file to the test cases of <problem> [A, B, C, D, E] from the prepared contest
    -t <code_file>,<problem>,<case>, Runs the <code_file> cpp file to the test case <case> of <problem> [A, B, C, D, E] from the prepared contest
        --runtest
    -l, --[no-]long                  Code contains a long long int %64d to convert to %lld on local system (to use with -r)
    -s, --reset                      Delete any cftools configuration files present

IMPORTANT NOTICE: The <contest>s require the contest number, not the round number!
(for example round 227 div2 is contest 387)
