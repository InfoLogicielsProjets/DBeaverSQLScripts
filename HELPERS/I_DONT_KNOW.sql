DECLARE @table_name varchar(55)
SET @table_name = 'FAP_AGR_PC  ' -- Cambia esto a tu nombre de tabla
 
CREATE TABLE #colcount (
  colname varchar(55),
  dct int,
  tot int,
  is_unique bit
)
 
DECLARE @col_name varchar(max), @sql nvarchar(max)
DECLARE c CURSOR FOR
SELECT name FROM sys.columns WHERE [object_id] = object_id(@table_name)
 
OPEN c
FETCH NEXT FROM c INTO @col_name
 
WHILE @@FETCH_STATUS = 0
BEGIN
  SET @sql = 'INSERT INTO #colcount (colname, dct, tot, is_unique) SELECT ''' + @col_name + ''', COUNT(DISTINCT ' + @col_name + '), COUNT(' + @col_name + '), CASE WHEN COUNT(DISTINCT ' + @col_name + ') = COUNT(' + @col_name + ') THEN 1 ELSE 0 END FROM ' + @table_name
  EXEC sp_executesql @sql
  FETCH NEXT FROM c INTO @col_name
END
 
CLOSE c
DEALLOCATE c
 
SELECT * FROM #colcount
DROP TABLE #colcount