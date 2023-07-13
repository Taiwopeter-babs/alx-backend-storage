-- creates a PROCEDURE that computes the average weighted score
-- of a student and stores it in the appropriate column
DELIMITER $ ;
CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
  DECLARE avg_wgt_score FLOAT;
  DECLARE loop_count INT;
  DECLARE iteration_limit INT DEFAULT 0;
  DECLARE user_id INT;

  -- Get the number of rows in the users table
  SELECT COUNT(users.id) INTO iteration_limit FROM users;

  -- Iterate until the limit is reached
  SET loop_count = 1;
  WHILE loop_count <= iteration_limit DO
    -- compute the sum of weights and score by each respective weight
    SELECT SUM(res.score * res.weight) / SUM(res.weight) INTO avg_wgt_score FROM 
      (SELECT us.id, pr.id AS proj_id, pr.weight, cor.score FROM
        corrections cor LEFT JOIN
        projects pr ON pr.id = cor.project_id LEFT JOIN
        users us ON us.id = cor.user_id WHERE us.id = loop_count) AS res;
    
    -- store the computed score in the user's average_score column
    UPDATE users SET average_score = avg_wgt_score
    WHERE users.id = loop_count;
    -- increment count
    SET loop_count = loop_count + 1;
  END WHILE;
  
END$
DELIMITER ; $