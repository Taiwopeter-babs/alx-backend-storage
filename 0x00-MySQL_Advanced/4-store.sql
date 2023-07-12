-- creates a trigger that updates, in this case decreases,
-- the amount of items when an order is placed
DELIMITER $ ;
CREATE TRIGGER decrease_item
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
  UPDATE items SET quantity = quantity - NEW.number
  WHERE name = NEW.item_name;
END$
DELIMITER ; $
