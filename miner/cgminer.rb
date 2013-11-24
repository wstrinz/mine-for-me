require 'yaml'
require 'childprocess'
settings = YAML.load_file("settings.yml")
user = settings["user"]
pass = settings["pass"]
dir = settings["directory"]
temp_target = settings["temp_target"]
max_temp = settings["max_temp"]

@p = ChildProcess.build "#{File.join(dir,"cgminer.exe")}", *("--scrypt -u #{user} -p #{pass} -o stratum+tcp://pool1.us.multipool.us:7777 --gpu-platform 0 -d 0 -w 256 -v 1 -I 13 -g 1 -l 1 -T  --temp-target #{temp_target} --temp-overheat #{max_temp} --thread-concurrency 8192 --gpu-engine 1100 --gpu-memclock 1200 --gpu-powertune 5 --auto-fan --auto-gpu".split(" "))

@p.start
# Process.wait()