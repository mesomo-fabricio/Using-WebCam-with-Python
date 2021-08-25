select substr(a.tablespace_name,
              1,
              20) "Tablespaces",
       (b.bytes / 1048576) as "TotalMB",
       (b.bytes / 1048576) - (c.bytes / 1048576) as "UsedMB",
       (c.bytes / 1048576) as "FreeMB"
  from dba_tablespaces a,
       (select tablespace_name,
               sum(bytes) as "BYTES"
          from dba_data_files
         group by tablespace_name) b,
       (select tablespace_name,
               sum(bytes) as "BYTES"
          from dba_free_space
         group by tablespace_name) c
 where a.tablespace_name = b.tablespace_name(+)
   and b.tablespace_name = c.tablespace_name(+)
 order by a.tablespace_name;
