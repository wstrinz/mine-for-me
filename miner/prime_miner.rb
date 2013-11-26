# require 'childprocess'

if ARGV[0]
  addr = ARGV[0]
else
  puts "primecoin address?"
  addr = gets()
end

if ARGV.include? "--install"
  puts "attempting to install (will only work on linux)"

  # Requirements
  `sudo apt-get update`
  `sudo apt-get install yasm -y git make g++ build-essential libminiupnpc-dev`
  `sudo apt-get install -y libboost-all-dev libdb++-dev libgmp-dev libssl-dev dos2unix`

  # Swap space for install
  `sudo dd if=/dev/zero of=/swapfile bs=64M count=16`
  `sudo mkswap /swapfile`
  `sudo swapon /swapfile`

  # clone and build
  `git clone https://github.com/thbaumbach/primecoin`
  `cd primecoin/src && make -f makefile.unix`
end

# make -f makefile.unix
`cd primecoin/src && ./primeminer -poolip=54.200.248.75 -poolport=1337 -pooluser=#{addr} -poolpassword=PASSWORD -genproclimit=4`