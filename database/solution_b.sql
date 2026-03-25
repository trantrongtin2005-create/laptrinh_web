-- 1
SELECT u.user_id, u.user_name, o.order_id
FROM users u
JOIN orders o ON u.user_id = o.user_id;

-- 2
SELECT u.user_id, u.user_name, COUNT(o.order_id) AS total_orders
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id;

-- 3
SELECT o.order_id, COUNT(od.product_id) AS total_products
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id;

-- 4
SELECT u.user_id, u.user_name, o.order_id, p.product_name
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
ORDER BY o.order_id;

-- 5
SELECT u.user_id, u.user_name, COUNT(o.order_id) AS total_orders
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id
ORDER BY total_orders DESC
LIMIT 7;

-- 6
SELECT u.user_id, u.user_name, o.order_id, p.product_name
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
WHERE p.product_name LIKE '%Samsung%'
OR p.product_name LIKE '%Apple%'
LIMIT 7;

-- 7
SELECT u.user_id, u.user_name, o.order_id,
SUM(p.product_price) AS total_price
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY o.order_id;

-- 8 (đơn hàng giá cao nhất mỗi user)
SELECT *
FROM (
    SELECT u.user_id, u.user_name, o.order_id,
    SUM(p.product_price) AS total_price,
    ROW_NUMBER() OVER (PARTITION BY u.user_id ORDER BY SUM(p.product_price) DESC) AS rn
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY o.order_id
) t
WHERE rn = 1;

-- 9 (giá thấp nhất)
SELECT *
FROM (
    SELECT u.user_id, u.user_name, o.order_id,
    SUM(p.product_price) AS total_price,
    COUNT(p.product_id) AS total_products,
    ROW_NUMBER() OVER (PARTITION BY u.user_id ORDER BY SUM(p.product_price) ASC) AS rn
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY o.order_id
) t
WHERE rn = 1;

-- 10 (nhiều sản phẩm nhất)
SELECT *
FROM (
    SELECT u.user_id, u.user_name, o.order_id,
    SUM(p.product_price) AS total_price,
    COUNT(p.product_id) AS total_products,
    ROW_NUMBER() OVER (PARTITION BY u.user_id ORDER BY COUNT(p.product_id) DESC) AS rn
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY o.order_id
) t
WHERE rn = 1;
