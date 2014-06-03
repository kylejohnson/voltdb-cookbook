cookbook_file "/tmp/voltdb.sql"

bash "Update apt" do
  user "root"
  code "apt-get update"
end

%w{ ant build-essential ant-optional openjdk-7-jdk openjdk-7-jre-headless python valgrind ntp ccache git-arch git-completion git-core git-svn git-doc git-email python-httplib2 python-setuptools python-dev apt-show-versions}.each do |pkg|
  package pkg
end

bash "Download VoltDB" do
  user "root"
  cwd "/tmp"
  code "wget 'http://voltdb.com/downloads/loader.php?kit=LinuxEnterpriseServer&j=' -O voltdb-linux.tgz"
  creates "/tmp/voltdb-linux.tgz"
end

bash "Extract VoltDB" do
  user "root"
  code "tar -zxf /tmp/voltdb-linux.tgz -C /opt/"
  creates "/opt/voltdb-ent-4.3"
end

bash "Use java 7" do
  user "root"
  code "rm /etc/alternatives/java && sudo ln -s /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java /etc/alternatives/java"
end

bash "Compile VoltDB Catalog" do
  user "root"
  cwd "/tmp"
  code "/opt/voltdb-ent-4.3/bin/voltdb compile /tmp/voltdb.sql"
  creates "/tmp/catalog.jar"
end

bash "Start VoltDB" do
  user "root"
  cwd "/tmp"
  code "nohup /opt/voltdb-ent-4.3/bin/voltdb create /tmp/catalog.jar &"
end
