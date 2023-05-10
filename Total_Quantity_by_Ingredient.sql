-- checking how many orders and then cost of each pizza, total cost = order*cost 
-- create order quantity per pizza
CREATE OR REPLACE VIEW stock1 AS
(select 
s1.item_name,
s1.ing_id,
s1.ing_name,
s1.ing_price,
s1.ing_weight,
s1.recipe_quantity,
s1.order_quantity,
s1.order_quantity * s1.recipe_quantity as ordered_weight,
s1.ing_price/s1.ing_weight as unit_cost,
(s1.order_quantity * s1.recipe_quantity/ s1.ing_price/s1.ing_weight) as ingredient_cost


from (select
o.item_id,
i.sku,
i.item_name,
r.ing_id,
ing.ing_name,
r.quantity as recipe_quantity,
ing.ing_weight,
ing.ing_price,
sum(o.quantity) as order_quantity
FROM orders o 
LEFT JOIN item i on i.item_id = o.item_id
-- we also need to add the recepie table to get the ingredients in each pizza
LEFT JOIN recipe r on i.sku = r.recipe_id
-- adding ingredient name
LEFT JOIN ingredient ing ON ing.ing_id = r.ing_id
GROUP BY o.item_id,i.sku, i.item_name, r.ing_id,r.quantity, ing.ing_name, ing.ing_weight,
ing.ing_price) s1)
