-- creates a PROCEDURE that computes the average weighted score
-- of a student and stores it in the appropriate column
DELIMITER $ ;
CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
  DECLARE avg_wgt_score FLOAT;
  DECLARE finished INT DEFAULT 0;

  -- declare variable to store current user id
  DECLARE user_id INT DEFAULT 0;

  -- declare the cursor
  DECLARE cur_cursor_id CURSOR FOR
    SELECT id FROM users;

  -- declare not found handler
  DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET finished = 1;
  
  -- open cursor
  OPEN cur_cursor_id;
  get_user_id: LOOP
    -- fetch current cursor user id into the variable
    FETCH cur_cursor_id INTO user_id;

    -- check if loop is still valid
    IF finished = 1 THEN
      LEAVE get_user_id;
    END IF;

    -- compute the sum of weights and score by each respective weight
    SELECT SUM(res.score * res.weight) / SUM(res.weight) INTO avg_wgt_score FROM 
      (SELECT us.id, pr.id AS proj_id, pr.weight, cor.score FROM
        corrections cor LEFT JOIN
        projects pr ON pr.id = cor.project_id LEFT JOIN
        users us ON us.id = cor.user_id WHERE us.id = user_id) AS res;
    
    -- store the computed score in the user's average_score column
    UPDATE users SET average_score = avg_wgt_score
    WHERE users.id = user_id;

  END LOOP get_user_id;

  -- CLOSE CURSOR
  CLOSE cur_cursor_id;
  
END$
DELIMITER ; $
