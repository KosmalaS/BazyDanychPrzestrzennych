CREATE TABLE buildings
(
    id_buildings SERIAL PRIMARY KEY,
    geometry     GEOMETRY,
    name         VARCHAR
);

CREATE TABLE roads
(
    id       SERIAL PRIMARY KEY,
    geometry GEOMETRY,
    name     VARCHAR
);

CREATE TABLE poi
(
    id       SERIAL PRIMARY KEY,
    geometry GEOMETRY,
    name     VARCHAR
);

INSERT INTO buildings(name, geometry)
VALUES ('BuildingA', ST_GeomFromEWKT('SRID=0;POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))')),
       ('BuildingB', ST_GeomFromEWKT('SRID=0;POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))')),
       ('BuildingC', ST_GeomFromEWKT('SRID=0;POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))')),
       ('BuildingD', ST_GeomFromEWKT('SRID=0;POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))')),
       ('BuildingF', ST_GeomFromEWKT('SRID=0;POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))'));

INSERT INTO poi(name, geometry)
VALUES ('G', ST_GeomFromEWKT('SRID=0;POINT(1 3.5)')),
       ('H', ST_GeomFromEWKT('SRID=0;POINT(5.5 1.5)')),
       ('I', ST_GeomFromEWKT('SRID=0;POINT(9.5 6)')),
       ('J', ST_GeomFromEWKT('SRID=0;POINT(6.5 6)')),
       ('K', ST_GeomFromEWKT('SRID=0;POINT(6 9.5)'));

INSERT INTO roads(name, geometry)
VALUES ('RoadX', ST_GeomFromEWKT('SRID=0;LINESTRING(0 4.5, 12 4.5)')),
       ('RoadY', ST_GeomFromEWKT('SRID=0;LINESTRING(7.5 10.5, 7.5 0)'));


-- a
SELECT SUM(ST_Length(geometry)) AS total_length
FROM roads;

-- b
SELECT ST_AsText(geometry) AS geometry, ST_Area(geometry) AS area, ST_Perimeter(geometry) AS perimeter
FROM buildings
WHERE name = 'BuildingA';

-- c
SELECT name, ST_Area(geometry) AS area
FROM buildings
ORDER BY name;

-- d
SELECT name, ST_Perimeter(geometry) AS perimeter
FROM buildings
ORDER BY ST_Area(geometry) DESC
LIMIT 2;

-- e
SELECT ST_Distance(
               (SELECT geometry FROM buildings WHERE name = 'BuildingC'),
               (SELECT geometry FROM poi WHERE name = 'K')
       ) AS distance;

-- f
SELECT ST_Area(
               ST_Difference(
                       (SELECT geometry FROM buildings WHERE name = 'BuildingC'),
                       ST_Buffer(
                               (SELECT geometry FROM buildings WHERE name = 'BuildingB'),
                               0.5
                       )
               )
       ) AS area;

-- g
SELECT name
FROM buildings
WHERE ST_Y(ST_Centroid(geometry)) > (SELECT ST_Y(ST_Centroid(geometry)) FROM roads WHERE name = 'RoadX');

-- h
SELECT ST_Area(
               ST_SymDifference(
                       (SELECT geometry FROM buildings WHERE name = 'BuildingC'),
                       ST_GeomFromEWKT('SRID=0;POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))')
               )
       ) AS area;