WITH filter_this AS (
  -- must be a common table expression, as we can't reference derived columns in a where clause
  SELECT DISTINCT
  CASE
    WHEN customer.customer_id = payment.customer_id AND payment.amount > 11
        THEN customer.customer_id
  END AS "id",
  CASE
      WHEN customer.customer_id = payment.customer_id AND payment.amount > 11
        THEN customer.first_name
  END AS "first_name"
  FROM customer, payment
  ORDER BY 1 ASC
)
SELECT *
FROM filter_this
WHERE id IS NOT NULL;