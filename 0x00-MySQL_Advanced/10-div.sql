-- creates a function that divides two values
DELIMITER $ ;
CREATE FUNCTION SafeDiv(a INT, b INT) RETURNS FLOAT
DETERMINISTIC
BEGIN
  DECLARE result_of_div FLOAT;

  IF b = 0 THEN
  SET result_of_div = 0;
  ELSE
    SET result_of_div = a / b;
  END IF;
  RETURN (result_of_div);
END$
DELIMITER ; $
