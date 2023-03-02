USE sakila;

# 1. Rank films by length (filter out the rows with nulls or zeros in length column). Select only columns title, length and rank in your output. 

SELECT title, length, DENSE_RANK() OVER (ORDER BY length DESC) AS "rank" # chose DENSE_RANK in the end as it gives the same ranking for all films with the same length which is how I understand the question
FROM film
WHERE length > 0; # filter out rows with zeros, but does this also actually work with nulls?

 
# 2. Rank films by length within the rating category (filter out the rows with nulls or zeros in length column). In your output, only select the columns title, length, rating and rank.
SELECT title, length, rating, DENSE_RANK() OVER (PARTITION BY rating ORDER BY length DESC) AS "rank" #rank the films according to lengthe, categorised by the rating
FROM film
WHERE length > 0; #same as above, this seems like the simplest solution, but does it work for nulls?


# 3. How many films are there for each of the categories in the category table? Hint: Use appropriate join between the tables "category" and "film_category".
 # Get a list of districts names ordered by the number of customers.
SELECT * # get overview of columns in table category
FROM category;

SELECT * # get overview of columns in table film_category
FROM film_category;

SELECT 
	C.name, 
    COUNT(F.film_id) AS num_films # get the names of the categories. Use COUNT to get the number of films
FROM category AS C # from table category
INNER JOIN film_category AS F # join with table film_category
ON C.category_id = F.category_id # join using column category_id
GROUP BY name #group by to group them by names i.e. categories
ORDER BY num_films DESC; 

 
 
# 4. Which actor has appeared in the most films? Hint: You can create a join between the tables "actor" and "film actor" and count the number of times an actor appears.
SELECT 
	A.first_name, 
    A.last_name, 
    COUNT(F.actor_id) AS Appearances # show columns of actors first and last names, count the actor ids to show who has been in most films
FROM actor AS A #from table actor
INNER JOIN film_actor AS F # join with table film_actor
ON A.actor_id = F.actor_id # join actor_id columns 
GROUP BY A.actor_id # group by the first and last names. I chose this instead of actor_id as I know of an called actress Susan Davis :)
ORDER BY COUNT(F.actor_id) DESC
LIMIT 1;

# 5. Which is the most active customer (the customer that has rented the most number of films)? Hint: Use appropriate join between the tables "customer" and "rental" and count the rental_id for each customer.
SELECT *
FROM customer;

SELECT *
FROM rental;

SELECT 
	C.customer_id, 
	C.first_name, C.last_name, 
    COUNT(R.rental_id) AS num_rentals #show the customer_id, first_name and last_name columns. Count the rental_id to show number of rentals
FROM customer AS C # from table customer
INNER JOIN rental AS R # from table rental
ON C.customer_id = R.customer_id #join customer_id tables
GROUP BY C.customer_id # group by the customer_id
ORDER BY num_rentals DESC #order in descending order as we're looking for person with the most
LIMIT 1; #limit to 1 so we can see who has the most

# Bonus: Which is the most rented film? (The answer is Bucket Brotherhood).

# This query might require using more than one join statement. Give it a try. We will talk about queries with multiple join statements later in the lessons.

# Hint: You can use join between three tables - "Film", "Inventory", and "Rental" and count the rental ids for each film.
SELECT 
	F.film_id,
	F.title, 
	COUNT(rental_id) AS num_rentals # show film_id, title and the COUNT of the rental_id
FROM film AS F # from table film
JOIN inventory AS I ON F.film_id = I.film_id # join table film with table inventory as they have common columns i.e. film_id
JOIN rental AS R ON I.inventory_id = R.inventory_id # join table rental as it has a comun column with table inventory i.e. inventory_id
GROUP BY F.film_id # group by the film_id 
ORDER BY num_rentals DESC #order by descending number as we are trying to get the highest number
LIMIT 1; # we only want the top 1, so limit it to 1


# another way of doing it
SELECT 
	F.film_id,
	F.title, 
	COUNT(rental_id) AS num_rentals # 
FROM film AS F
INNER JOIN inventory AS I USING (film_id) #using INNER JOIN has the same outcome. I aslo learnt that you can use USING if the column names are identicle 
INNER JOIN rental AS R USING (inventory_id)
GROUP BY F.film_id
ORDER BY num_rentals DESC
LIMIT 1;
