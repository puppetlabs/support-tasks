WITH
 tables
   AS (
     SELECT
       c.oid, pg_total_relation_size(c.oid) AS total_size, *
     FROM
       pg_catalog.pg_class AS c
       LEFT JOIN pg_catalog.pg_namespace AS n ON
           n.oid = c.relnamespace
     WHERE
       relkind = 'r'
       AND n.nspname NOT IN ('information_schema', 'pg_catalog')
   ),
 toast
   AS (
     SELECT
       c.oid, *
     FROM
       pg_catalog.pg_class AS c
       LEFT JOIN pg_catalog.pg_namespace AS n ON
           n.oid = c.relnamespace
     WHERE
       relkind = 't'
       AND n.nspname NOT IN ('information_schema', 'pg_catalog')
   ),
 indices
   AS (
     SELECT
       c.oid, *
     FROM
       pg_catalog.pg_class AS c
       LEFT JOIN pg_catalog.pg_namespace AS n ON
           n.oid = c.relnamespace
     WHERE
       relkind = 'i'
       AND n.nspname NOT IN ('information_schema', 'pg_catalog')
   )
SELECT
 'pe-puppetdb' || '.' || relname AS name,
 'table' AS type,
 pg_size_pretty(pg_relation_size(oid)) AS size,
 total_size
FROM
 tables
UNION
 SELECT
   'pe-puppetdb' || '.' || r.relname || '.' || t.relname AS name,
   'toast' AS type,
   pg_size_pretty(pg_relation_size(t.oid)) AS size,
   r.total_size AS total_size
 FROM
   toast AS t
   INNER JOIN tables AS r ON t.oid = r.reltoastrelid
UNION
 SELECT
   'pe-puppetdb' || '.' || r.relname || '.' || i.relname AS name,
   'index' AS type,
   pg_size_pretty(pg_relation_size(i.oid)) AS size,
   r.total_size AS total_size
 FROM
   indices AS i
   LEFT JOIN pg_catalog.pg_index AS c ON
       i.oid = c.indexrelid
   INNER JOIN tables AS r ON c.indrelid = r.oid
ORDER BY
 total_size DESC,
 name ASC;
