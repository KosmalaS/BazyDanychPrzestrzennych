-- 1
CREATE TABLE objects (
	id SERIAL PRIMARY KEY,
	geometry geometry,
	name VARCHAR(32)
);

INSERT INTO objects("name", geometry) 
VALUES
('object1', 
	ST_CollectionExtract(
		ST_CurveToLine(
			ST_GeomFromEWKT(
	 			'SRID=0;GEOMETRYCOLLECTION(
					 LINESTRING(0 1, 1 1),
				 	 CIRCULARSTRING(1 1, 2 0, 3 1),
				 	 CIRCULARSTRING(3 1, 4 2, 5 1),
				 	 LINESTRING(5 1, 6 1)
	 			)'
 			)
		)
	)
),

('object2', 
	ST_SetSRID(
		ST_BuildArea(
			ST_Collect(
				ARRAY[
					'LINESTRING(10 6, 14 6)',
					'CIRCULARSTRING(14 6, 16 4, 14 2)',
					'CIRCULARSTRING(14 2, 12 0, 10 2)',
					'LINESTRING(10 2, 10 6)',
					ST_Buffer(ST_POINT(12, 2), 1, 6000)
				]
			)
		), 0
	)
),

('object3', 
	ST_GeomFromEWKT(
		'SRID=0;POLYGON((10 17, 12 13, 7 15, 10 17))'
	)
),
-- na pewno nie poligon, bo nie ma zamkniętego loopa
('object4', 
	ST_GeomFromEWKT(
		'SRID=0;LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)'
	)
),
('object5', 
	ST_GeomFromEWKT(
		'SRID=0;MULTIPOINT((30 50 59), (38 32 234))'
	)
),
('object6', 
	ST_SetSRID(
		ST_Collect(
			'LINESTRING(1 1, 3 2)',
			'POINT(4 2)'
		), 0
	)
);

-- 2
WITH object3_geometry AS (
	SELECT geometry FROM objects WHERE "name" = 'object3'
),
object4_geometry AS (
	SELECT geometry FROM objects WHERE "name" = 'object4'
)

SELECT ST_Area(ST_Buffer(ST_ShortestLine(l.geometry, r.geometry), 5))
FROM object3_geometry AS l
CROSS JOIN object4_geometry AS r;

-- 3
WITH polygon_geometry AS (
	SELECT ST_MakePolygon(ST_AddPoint(geometry, ST_StartPoint(geometry)))
	FROM objects
	WHERE "name" = 'object4'
)

UPDATE objects
SET geometry = (SELECT * FROM polygon_geometry)
WHERE "name" = 'object4';

-- 4
INSERT INTO objects ("name", geometry)
SELECT 'object7', ST_Collect(geometry)
FROM objects
WHERE "name" = 'object3' OR "name" = 'object4'

-- 5
SELECT ST_Area(ST_Buffer(ST_Union(ST_Force3D(geometry)), 5)) 
FROM objects
WHERE NOT ST_HasArc(geometry)