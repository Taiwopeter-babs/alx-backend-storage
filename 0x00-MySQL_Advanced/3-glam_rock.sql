-- ranks band whose name is 'Glam Rock' by their
-- longevity; year_split - year_formed
SELECT band_name, (IFNULL(split, 2022) - formed) AS lifespan
  FROM metal_bands
  WHERE style LIKE '%Glam rock%';
