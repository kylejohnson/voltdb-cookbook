bash "Start VoltDB" do
  user "root"
  cwd "/media/voltdb"
  code "/opt/voltdb-ent-4.4/bin/voltdb create /media/voltdb/catalog.jar -B --deployment=/media/voltdb/deployment.xml --client=21212 --admin=21211"
  not_if 'jps | grep VoltDB'
end
