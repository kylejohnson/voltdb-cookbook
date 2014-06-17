bash "Update apt" do
  user "root"
  code "apt-get update"
end

%w{ ant build-essential ant-optional openjdk-7-jdk openjdk-7-jre-headless python valgrind ntp ccache git-arch git-completion git-core git-svn git-doc git-email python-httplib2 python-setuptools python-dev apt-show-versions wget }.each do |pkg|
  package pkg
end

cookbook_file "schema" do
  path "/media/voltdb/schema.sql"
  source "schema.sql"
end

template "/media/voltdb/deployment.xml" do
  variables(
    :hostcount => 3,
    :sitesperhost => 4,
    :kfactor => 1,
    :httpd_enabled => 'true',
    :httpd_port => 8080,
    :jsonapi_enabled => 'true',
    :snapshot_prefix => 'snapshot',
    :snapshot_freq => '30m',
    :snapshot_retain => 3,
    :commandlog_logsize => 3072,
    :path_command_log => '/media/voltdb/cmdlog',
    :path_command_log_snapshot => '/media/voltdb/cmdsnaps',
    :path_snapshot => '/media/voltdb/autosnaps',
    :path_voltdb_root => '/media/voltdb'
  )
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
  creates "/opt/voltdb-ent-4.4"
end

bash "Use java 7" do
  user "root"
  code "rm /etc/alternatives/java && sudo ln -s /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java /etc/alternatives/java"
  not_if 'readlink /etc/alternatives/java|grep java-7'
end

bash "Disable swap" do
  user "root"
  code "swapoff -a"
end

bash "Enable Virtual Memory Overcommit" do
  user "root"
  code "sysctl -w vm.overcommit_memory=1"
  not_if 'sysctl vm.overcommit_memory|grep 1'
end

bash "Compile VoltDB Catalog" do
  user "root"
  cwd "/media/voltdb"
  code "/opt/voltdb-ent-4.4/bin/voltdb compile /media/voltdb/schema.sql"
  creates "/media/voltdb/catalog.jar"
end

