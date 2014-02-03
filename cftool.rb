#!/usr/bin/env ruby

require 'securerandom'
require 'fileutils'
require 'open-uri'
require 'nokogiri'
require 'cgi'
require 'json'
require 'net/http'
require 'optparse'
require 'rbconfig'

class String
  def red;            "\033[31m#{self}\033[0m" end
  def green;          "\033[32m#{self}\033[0m" end
  def magenta;        "\033[35m#{self}\033[0m" end
end

def os
  @os ||= (
    host_os = RbConfig::CONFIG['host_os']
    case host_os
    when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
      :windows
    when /darwin|mac os/
      :macosx
    when /linux/
      :linux
    when /solaris|bsd/
      :unix
    else
      raise Error::WebDriverError, "unknown os: #{host_os.inspect}"
    end
  )
end

def get_title(contest)
  url = "http://codeforces.com/contest/#{contest}"
  CGI.unescape_html Nokogiri::HTML(open(url)).at("title").text rescue "Contest Not Found"
end

def generate
  puts "Generating .cpp files...\n\n"
  ('A'..'E').each do |let|
    filename = let + ".cpp"
    unless File.exists? filename
      puts "Creating #{let}.cpp file...\n"
      cfile = File.open(filename, "w")
      cfile.puts "#include <stdio.h>
#include <string.h>
#include <vector>
#include <algorithm>

using namespace std;

int main()
{
  int n, m;
  return 0;
}
"
      cfile.close
    end
  end
  puts "Done!"
end

def prepared?
  (File.exists? ".cfconfig") || (File.directory? "test_cases")
end

def prepare_problem(contest, problem)
  url = "http://codeforces.com/contest/#{contest}/problem/#{problem}"
  page = Nokogiri::HTML(open(url))

  inputs = page.css("div.input pre")
  inputs.css('br').each do |br|
    br.replace("\n")
  end

  outputs = page.css("div.output pre")
  outputs.css('br').each do |br|
    br.replace("\n")
  end

  @var = 1
  inputs.each do |tcase|
    ifile = File.open("test_cases/#{problem}#{@var}.in", "w")
    ifile.puts tcase.text
    ifile.close
    @var += 1
  end

  @var = 1
  outputs.each do |tcase|
    ofile = File.open("test_cases/#{problem}#{@var}.out", "w")
    ofile.puts tcase.text
    ofile.close
    @var += 1
  end

  outputs.length
end

def prepare(contest)
  contest_title = get_title contest
  if contest_title == "Codeforces"
    puts "Contest Unexistent...\n"
    puts "Maybe you wrote the incorrect contest number. Remember, it's not the round number, it's the contest number!\n"
    puts "(for example round 227 div2 is contest 387)"
  else
    puts "Preparing #{contest_title}\n"
    Dir.mkdir("test_cases")

    problems = {}
    ('A'..'E').each do |prob|
      puts "Preparing problem #{prob}\n"
      result = prepare_problem contest, prob
      if result > 0
        problems[prob] = result
      else
        puts "There was an error preparing problem #{prob}...\n"
        puts "Make sure it is a regular CodeForces Round and that your internet connection is active.\n"
        puts "Please run ./cftool -s to reset the directory and then rerun the prepare command.\n"
      end
    end

    File.open(".cfconfig","w") do |f|
      f.write(problems.to_json)
    end

    puts "All problems prepared!\n"
  end
end

def compile(filename, long)
  tmpname = SecureRandom.hex(3) + ".cpp"
  FileUtils.copy(filename, tmpname)

  if long
    cfile = File.open(tmpname, "r")
    code = cfile.read
    code = code.gsub("%I64d", "%lld")
    cfile.close
    cfile = File.open(tmpname, "w")
    cfile.puts code
    cfile.close
  end

  result = system("g++ #{tmpname}")
  File.delete tmpname
  result
end

def run(problem, test_case)
  outfile = SecureRandom.hex(3) + ".txt"
  if os == :linux || os == :unix
    result = system("./a.out < test_cases/#{problem}#{test_case}.in > #{outfile}")
  elsif os == :windows
    result = system("a.exe < test_cases/#{problem}#{test_case}.in > #{outfile}")
  else
    print "OS not supported...\n"
  end
  if result
    resfile = File.open(outfile, "r")
    output = resfile.read
    resfile.close
    File.delete outfile
    expfile = File.open("test_cases/#{problem}#{test_case}.out", "r")
    expected = expfile.read
    expfile.close
    if expected == output
      puts "Test #{test_case}: Correct!".green
      true
    else
      puts "Test #{test_case}: Output doesn't match...".red
      puts "Your code outputed:\n"
      puts output
      puts "The correct result should be:\n"
      puts expected
      puts "\n"
      false
    end
  else
    File.delete outfile
    puts "Test #{test_case}: Error running code...".magenta
    false
  end
end

def reset
  puts "Deleting current test cases..."
  if File.directory? "test_cases"
    Dir.foreach("test_cases/") do |f|
      unless f == '.' || f == '..'
        File.delete "test_cases/#{f}"
      end
    end
    Dir.delete "test_cases"
  end

  puts "Deleting config file..."
  if File.exists? ".cfconfig"
    File.delete ".cfconfig"
  end

puts "Directory successfully reseted!"
end

def print_banner
  puts "   ______          __     ______                         ______            __    
  / ____/___  ____/ /__  / ____/___  _____________  ____/_  __/___  ____  / /____
 / /   / __ \\/ __  / _ \\/ /_  / __ \\/ ___/ ___/ _ \\/ ___// / / __ \\/ __ \\/ / ___/
/ /___/ /_/ / /_/ /  __/ __/ / /_/ / /  / /__/  __(__  )/ / / /_/ / /_/ / (__  ) 
\\____/\\____/\\__,_/\\___/_/    \\____/_/   \\___/\\___/____//_/  \\____/\\____/_/____/  

\t---- A Tool for Codeforces Contests by GangsterVeggies\n\n"
end

if __FILE__ == $0
  print_banner
  options = {:generate=>false, :prepare=>false, :run=>false, :long=>false, :reset=>false}
  OptionParser.new do |opts|
    opts.banner = "Usage: ./cftool [options]"

    opts.on('-h', '--help', 'Displays this help text') do
      puts opts
      puts "\nIMPORTANT NOTICE: The <contest>s require the contest number, not the round number!\n(for example round 227 div2 is contest 387)\n"
      exit
    end
    
    opts.on("-g", "--generate", "Generates A, B, C, D and E templated cpp files") do
      options[:generate] = true
    end

    opts.on("-p", "--prepare <contest>", Integer, "Prepares the test cases of <contest> (needs to be done before -r or -t)") do |contest|
      options[:prepare] = true
      options[:contest] = contest
    end

    opts.on("-r", "--run <code_file>,<problem>", Array, "Runs the <code_file> cpp file to the test cases of <problem> [A, B, C, D, E] from the prepared contest") do |code, problem|
      options[:run] = true

      if options[:problem].nil?
        options[:code_file] = code + ".cpp"
        options[:problem] = code
      else
        options[:code_file] = code
        options[:problem] = problem
      end
    end

    opts.on("-t", "--runtest <code_file>,<problem>,<case>", Array, "Runs the <code_file> cpp file to the test case <case> of <problem> [A, B, C, D, E] from the prepared contest") do |code, problem, test_case|
      options[:run] = true
      options[:code_file] = code
      options[:problem] = problem
      options[:test_case] = Integer(test_case)
    end

    opts.on("-l", "--[no-]long", "Code contains a long long int %64d to convert to %lld on local system (to use with -r)") do |long|
      options[:long] = long
    end

    opts.on("-s", "--reset", "Delete any cftools configuration files present") do
      options[:reset] = true
    end
  end.parse!

  if options[:generate]
    generate
  elsif options[:prepare]
    unless prepared?
      prepare options[:contest]
    else
      puts "This directory already has a cftools configuration file...\n"
      puts "Try running ./cftool -d to reset the directory first and then run prepare again."
    end
  elsif options[:run]
    if prepared?
      if !options[:problem].nil? && options[:problem] >= 'A' && options[:problem] <= 'E'
        if compile options[:code_file], options[:long]
          puts "Compilation completed successfully...\n\n"
          tests = JSON.parse(IO.read(".cfconfig"))
          if options[:test_case].nil?
            counter = 0
            (1..tests[options[:problem]]).each do |tcase|
              if (File.exists? "test_cases/#{options[:problem]}#{tcase}.in") && (File.exists? "test_cases/#{options[:problem]}#{tcase}.out")
                if run options[:problem], tcase
                  counter += 1
                end
              else
                puts "The test cases directory or the config file is corrupted...\nTry reseting the directory with ./cftool -s and then prepare the contest again\n"
              end
            end

            if counter < tests[options[:problem]]
              puts "\nResult: #{counter} out of #{tests[options[:problem]]} correct.".red
              puts "There were incorrect test cases!\n"
            else
              puts "\nResult: #{counter} out of #{tests[options[:problem]]} correct.".green
              puts "Everything seems alright. Submit it!\n"
            end
          else
            if (File.exists? "test_cases/#{options[:problem]}#{options[:test_case]}.in") && (File.exists? "test_cases/#{options[:problem]}#{options[:test_case]}.out")
              run options[:problem], options[:test_case]
            else
              puts "Invalid test case number...\nIf you think this is a problem with the config please run ./cftool -s to reset the directory and then prepare the contest again\n"
            end
          end
        else
          puts "\nThere was a compilation error...\nPlease check your code.\n"
        end
      else
        puts "Invalid Problem name!\nIt has to be either A, B, C, D or E!\n"
        puts "NOTICE: The correct command should be ./cftool -r <code_file>,<problem> with no spaces!\n"
      end
    else
      puts "This directory doesn't have a cftools configuration file...\n"
      puts "You have to run ./cftool -p <contest> to prepare it first\n"
    end
  elsif options[:reset]
    if prepared?
      reset
    end
  end
end
