cookbook_file "/tmp/voltdb.sql"

template "/tmp/deployment.xml" do
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

bash "Compile VoltDB Catalog" do
  user "root"
  cwd "/tmp"
  code "/opt/voltdb-ent-4.4/bin/voltdb compile /tmp/voltdb.sql"
  creates "/tmp/catalog.jar"
end

bash "Start VoltDB" do
  user "root"
  cwd "/tmp"
  code "nohup /opt/voltdb-ent-4.4/bin/voltdb create /tmp/catalog.jar --host=`ifconfig eth0|grep 'inet addr'|awk '{print $2}'|cut -f 2 -d ':'` --deployment=/tmp/deployment.xml &"
  not_if '/opt/voltdb-ent-4.3/bin/sqlcmd --query="select * from artists"'
end
