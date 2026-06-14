SELECT TOP 1
P.CookieName,
SUM(OP.Quantity) AS TotalQuantitySold
FROM Product P
INNER JOIN Order_Product OP
ON P.CookieID = OP.CookieID
GROUP BY P.Cookiename
ORDER BY TotalQuantitySold DESC;