cookbook_file "schema" do
  path "/media/voltdb/"
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

bash "Compile VoltDB Catalog" do
  user "root"
  cwd "/media/voltdb"
  code "/opt/voltdb-ent-4.4/bin/voltdb compile /media/voltdb/schema.sql"
  creates "/media/voltdb/catalog.jar"
end

bash "Start VoltDB" do
  user "root"
  cwd "/media/voltdb"
  code "/opt/voltdb-ent-4.4/bin/voltdb create /media/voltdb/catalog.jar -B --host=`ifconfig eth0|grep 'inet addr'|awk '{print $2}'|cut -f 2 -d ':'` --deployment=/media/voltdb/deployment.xml"
  not_if 'jps | grep VoltDB'
end
