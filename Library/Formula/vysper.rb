require 'formula'

class Vysper < Formula
  url 'http://archive.apache.org/dist/mina/vysper/0.7/vysper-0.7-bin.tar.gz'
  homepage 'http://mina.apache.org/vysper/'
  md5 '5d39a931c94bf46e259d8bb0a4ce385b'

  skip_clean :all


  def install
    # Remove Windows scripts
    rm_rf Dir['bin/*.bat']

    # install the files
    prefix.install %w{ NOTICE.txt LICENSE.txt ABOUT.txt }
    libexec.install Dir['*']    
  
    bin.mkpath

    # create a start script that understands the brew path
    (bin+"vysper").write <<-EOS.undent
        #!/bin/bash
        REPO=#{libexec}
        #{libexec}/bin/run.sh $@
      EOS
    chmod 0755, bin+"vysper"

    # rewrite the log file locations
    logFile = "#{libexec}/config/log4j.xml" 
    logConfig = File.read(logFile)
    File.open(logFile, "w") {|file| file.puts logConfig.gsub(/log\//, "#{libexec}/log/")}

    # set access to log files
    %w{ vysper_server.log stanza.log }.each do |f|
      touch "#{libexec}/log/#{f}"
      chmod 0666, "#{libexec}/log/#{f}" 
    end
  end
end
