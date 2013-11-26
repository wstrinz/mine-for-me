require 'yaml'
require 'childprocess'
settings = YAML.load_file("settings.yml")
user = settings["user"]
pass = settings["pass"]
dir = settings["cgminer_directory"]
temp_target = settings["temp_target"]
max_temp = settings["max_temp"]

cmd = "#{File.join(dir,"cgminer.exe")}"
args = "--scrypt -u #{user} -p #{pass} -o stratum+tcp://pool1.us.multipool.us:7777 --gpu-platform 0 -d 0 -w 256 -v 1 -I 19 -g 1 -l 1 -T --temp-target #{temp_target} --temp-overheat #{max_temp} --thread-concurrency 12404 --gpu-engine 1100 --gpu-memclock 1200 --gpu-powertune 5 --auto-fan --auto-gpu"
puts "#{cmd} #{args}"
@p = ChildProcess.build cmd, *args.split(" ")

@p.start
# Process.wait()