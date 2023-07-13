-- creates a PROCEDURE that computes the average score
-- of a student and stores it in the appropriate column
DELIMITER $ ;
CREATE PROCEDURE ComputeAverageScoreForUser(IN user_id INT)
BEGIN
  DECLARE computed_score FLOAT;
  -- compute the score
  SELECT AVG(cor.score) INTO computed_score FROM users us
    JOIN corrections cor
    ON us.id = cor.user_id
    WHERE us.id = user_id
    GROUP BY us.name;
  
  -- store the computed score
  UPDATE users SET average_score = computed_score
  WHERE users.id = user_id;
  
END$
DELIMITER ; $
