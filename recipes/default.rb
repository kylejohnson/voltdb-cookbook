%w{python2.7 git ntp openjdk-7-jdk openjdk-7-jre-headless}.each do |pkg|
  package pkg
end

git "/opt/voltdb" do
  repository "https://github.com/VoltDB/voltdb.git"
  revision "master"
  action :sync
end

cookbook_file "/tmp/voltdb.sql"

bash "compile voltdb db" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  /opt/voltdb/bin/voltdb compile voltdb.sql
  EOH
end

bash "Start VoltDB" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  /opt/voltdb/bin/voltdb create catalog.jar
  EOH
end
