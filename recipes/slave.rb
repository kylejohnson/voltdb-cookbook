voltdb_master = search(:node, 'role:voltdb_master').first
voltdb_master_ip = voltdb_master["cloud"]["local_ipv4"].to_s

bash "Join VoltDB Cluster" do
  user "root"
  cwd  "/media/voltdb"
  code "/opt/voltdb-ent-4.4/bin/voltdb create /media/voltdb/catalog.jar -B --deployment=/media/voltdb/deployment.xml --client=21212 --admin=21211 --host=#{voltdb_master_ip}"
  not_if "jps | grep VoltDB"
end
