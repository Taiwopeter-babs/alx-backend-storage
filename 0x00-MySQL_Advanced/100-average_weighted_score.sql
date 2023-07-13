-- creates a PROCEDURE that computes the average weighted score
-- of a student and stores it in the appropriate column
DELIMITER $ ;
CREATE PROCEDURE ComputeAverageWeightedScoreForUser(IN user_id INT)
BEGIN
  DECLARE avg_wgt_score FLOAT;

  -- compute the sum of weights and score by each respective weight
  SELECT SUM(res.score * res.weight) / SUM(res.weight) INTO avg_wgt_score FROM 
    (SELECT us.id, pr.id AS proj_id, pr.weight, cor.score FROM
      corrections cor LEFT JOIN
      projects pr ON pr.id = cor.project_id LEFT JOIN
      users us ON us.id = cor.user_id WHERE us.id =2) AS res;
  
  -- store the computed score in the user's average_score column
  UPDATE users SET average_score = avg_wgt_score
  WHERE users.id = user_id;
  
END$
DELIMITER ; $
