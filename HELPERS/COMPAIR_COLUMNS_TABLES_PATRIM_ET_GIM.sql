	
	
	
	
	
	
	
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'PATRIMOINE_GIM' AND column_name NOT IN (
    SELECT column_name
    FROM information_schema.columns
    WHERE table_name = 'PATRIMOINE'
)
UNION
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'PATRIMOINE_GIM' AND column_name NOT IN (
    SELECT column_name
    FROM information_schema.columns
    WHERE table_name = 'PATRIMOINE'
);

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'PATRIMOINE_GIM' AND column_name IN (
    SELECT column_name
    FROM information_schema.columns
    WHERE table_name = 'PATRIMOINE'
);
	
-- Columnas que están en una tabla pero no en la otra, con el nombre de la tabla
SELECT 'PATRIMOINE_GIM' AS tabla, column_name
FROM information_schema.columns
WHERE table_name = 'PATRIMOINE_GIM' AND column_name NOT IN (
    SELECT column_name
    FROM information_schema.columns
    WHERE table_name = 'PATRIMOINE'
)
UNION ALL
SELECT 'PATRIMOINE' AS tabla, column_name
FROM information_schema.columns
WHERE table_name = 'PATRIMOINE_GIM' AND column_name NOT IN (
    SELECT column_name
    FROM information_schema.columns
    WHERE table_name = 'PATRIMOINE'
);




-- Columnas que están en una tabla pero no en la otra, con el nombre de la tabla y la descripción de la columna
SELECT 'PATRIMOINE_GIM' AS tabla,
       c.column_name,
       g.Desc_Champ AS descripcion
FROM information_schema.columns c
LEFT JOIN CATALOG_GIM g ON c.column_name = g.Nom_Champ
WHERE c.table_name = 'PATRIMOINE_GIM' AND c.column_name NOT IN (
    SELECT column_name
    FROM information_schema.columns
    WHERE table_name = 'PATRIMOINE'
)
UNION ALL
SELECT 'PATRIMOINE' AS tabla,
       c.column_name,
       g.Desc_Champ AS descripcion
FROM information_schema.columns c
LEFT JOIN CATALOG_GIM g ON c.column_name = g.Nom_Champ
WHERE c.table_name = 'PATRIMOINE' AND c.column_name NOT IN (
    SELECT column_name
    FROM information_schema.columns
    WHERE table_name = 'PATRIMOINE_GIM'
);


-- Contar el número de columnas en la tabla 1
SELECT COUNT(*) AS num_columnas_tabla1
FROM information_schema.columns
WHERE table_name = 'PATRIMOINE_GIM';

-- Contar el número de columnas en la tabla 2
SELECT COUNT(*) AS num_columnas_tabla2
FROM information_schema.columns
WHERE table_name = 'PATRIMOINE';


-- Obtener el nombre de la columna y su descripción
SELECT Nom_Champ AS nombre_columna,
       Desc_Champ AS descripcion_columna,
       'PATRIMOINE_GIM' AS tabla_presente
FROM CATALOG_GIM
WHERE Nom_Champ IN (
    SELECT column_name
    FROM information_schema.columns
    WHERE table_name = 'PATRIMOINE_GIM'
)
UNION
SELECT Nom_Champ AS nombre_columna,
       Desc_Champ AS descripcion_columna,
       'PATRIMOINE' AS tabla_presente
FROM CATALOG_GIM
WHERE Nom_Champ IN (
    SELECT column_name
    FROM information_schema.columns
    WHERE table_name = 'PATRIMOINE'
);




SELECT DISTINCT * 
FROM (
    -- Tu consulta original para obtener todas las columnas
    SELECT 
        cg.Nom_Champ AS nombre_columna,
        cg.Desc_Champ AS descripcion_columna,
        CASE 
            WHEN it1.column_name IS NOT NULL AND it2.column_name IS NOT NULL THEN 'PATRIMOINE_GIM Y PATRIMOINE'
            WHEN it1.column_name IS NOT NULL THEN 'PATRIMOINE_GIM'
            WHEN it2.column_name IS NOT NULL THEN 'PATRIMOINE'
            ELSE 'NINGUNA'
        END AS tabla_presente
    FROM 
        CATALOG_GIM cg
    LEFT JOIN 
        information_schema.columns it1 ON cg.Nom_Champ = it1.column_name AND it1.table_name = 'PATRIMOINE_GIM'
    LEFT JOIN 
        information_schema.columns it2 ON cg.Nom_Champ = it2.column_name AND it2.table_name = 'PATRIMOINE'

    UNION ALL

    -- Obtener las columnas de la tabla 2 que no están en la tabla 1
    SELECT 
        it2.column_name AS nombre_columna,
        '' AS descripcion_columna,
        'PATRIMOINE' AS tabla_presente
    FROM 
        information_schema.columns it2
    LEFT JOIN 
        information_schema.columns it1 ON it1.column_name = it2.column_name AND it1.table_name = 'PATRIMOINE_GIM'
    WHERE 
        it2.table_name = 'PATRIMOINE' AND it1.column_name IS NULL
) AS subconsulta
WHERE 
    tabla_presente != 'NINGUNA';

   
   
   SELECT 
    nombre_columna,
    MAX(descripcion_columna) AS descripcion_columna,
    MAX(tabla_presente) AS tabla_presente
FROM (
    -- Tu consulta original para obtener todas las columnas
    SELECT 
        cg.Nom_Champ AS nombre_columna,
        cg.Desc_Champ AS descripcion_columna,
        CASE 
            WHEN it1.column_name IS NOT NULL AND it2.column_name IS NOT NULL THEN 'PATRIMOINE_GIM Y PATRIMOINE'
            WHEN it1.column_name IS NOT NULL THEN 'PATRIMOINE_GIM'
            WHEN it2.column_name IS NOT NULL THEN 'PATRIMOINE'
            ELSE 'NINGUNA'
        END AS tabla_presente
    FROM 
        CATALOG_GIM cg
    LEFT JOIN 
        information_schema.columns it1 ON cg.Nom_Champ = it1.column_name AND it1.table_name = 'PATRIMOINE_GIM'
    LEFT JOIN 
        information_schema.columns it2 ON cg.Nom_Champ = it2.column_name AND it2.table_name = 'PATRIMOINE'

    UNION ALL

    -- Obtener las columnas de la tabla 2 que no están en la tabla 1
    SELECT 
        it2.column_name AS nombre_columna,
        '' AS descripcion_columna,
        'PATRIMOINE' AS tabla_presente
    FROM 
        information_schema.columns it2
    LEFT JOIN 
        information_schema.columns it1 ON it1.column_name = it2.column_name AND it1.table_name = 'NombreTabla1'
    WHERE 
        it2.table_name = 'PATRIMOINE' AND it1.column_name IS NULL
) AS subconsulta
WHERE 
    tabla_presente != 'NINGUNA'
GROUP BY 
    nombre_columna;