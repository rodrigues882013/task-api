CREATE KEYSPACE task_keyspace
  WITH REPLICATION = { 
   'class' : 'SimpleStrategy', 
   'replication_factor' : 1 
  };

CREATE TABLE IF NOT EXISTS task_keyspace.tasks(
    id text PRIMARY KEY,
    definition text,
    metadata blob);
