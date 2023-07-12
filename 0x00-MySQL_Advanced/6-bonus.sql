-- creates a PROCEDURE that adds data to tables
DELIMITER $ ;
CREATE PROCEDURE AddBonus(IN user_id INT, IN project_name VARCHAR(255), IN score INT)
BEGIN
  DECLARE new_project_id INT;
  -- check if project exists
  IF NOT EXISTS(SELECT name FROM projects WHERE name = project_name) THEN
    INSERT INTO projects (name) VALUES (project_name);
    SET @new_proj_id = LAST_INSERT_ID();
    INSERT INTO corrections (user_id, project_id, score) VALUES
      (user_id, @new_proj_id, score);
  ELSE
    SELECT id INTO new_project_id FROM projects WHERE name = project_name;
    INSERT INTO corrections (user_id, project_id, score) VALUES 
      (user_id, new_project_id, score);
  END IF;
END$
DELIMITER ; $
