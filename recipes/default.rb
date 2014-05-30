%w{python2.7 git ntp openjdk-7-jdk openjdk-7-jre-headless}.each do |pkg|
  package pkg
end

git "/opt/voltdb" do
  repository "https://github.com/VoltDB/voltdb.git"
  revision "master"
  action :sync
end

