SELECT products.product_id,
	products.name AS products_name,
	products.manufacturing_cost,
	categories.name AS category_name,
	categories.market
	
FROM manufacturing.products JOIN manufacturing.categories 
	ON categories.category_id = products.category_id
WHERE market = 'industrial';