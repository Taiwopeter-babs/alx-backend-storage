-- Updates 'valid_email' column only when
-- email attribute is changed
DELIMITER $ ;

CREATE TRIGGER update_validity_OnChange BEFORE
UPDATE
  ON users FOR EACH ROW 
  BEGIN 
    IF NEW.email != OLD.email THEN
      SET NEW.valid_email = 0;
    END IF;
  END$

DELIMITER ; $
