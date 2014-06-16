voltdb_master = search(:node, 'role:voltdb_master').first
voltdb_master_ip = voltdb_master["cloud"]["local_ipv4"].to_s

bash "Join VoltDB Cluster" do
  user "root"
  cwd  "/tmp"
  code "/opt/voltdb-ent-4.4/bin/voltdb add --host=#{voltdb_master_ip} -B"
  not_if "jps | grep VoltDB"
end
