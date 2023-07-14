-- ranks countries origins of bands
-- by the number of their non-unqiue fans
SELECT origin, SUM(fans) AS 'nb_fans'
  FROM metal_bands
  GROUP BY origin
  ORDER BY nb_fans DESC;
