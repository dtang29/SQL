USE sakila;

SELECT * FROM actor;

#1a. Display the first and lASt names of all actors FROM the table actor. 
SELECT first_name, last_name FROM actor;

#1b. Display the first and lASt name of each actor IN a sINgle column IN upper cASe letters. Name the column Actor Name. 
SELECT UPPER(CONCAT(first_name, " ", last_name))  AS 'Actor name' FROM actor;

#2a. You need to fINd the ID number, first name, and lASt name of an actor, of whom you know ONly the first name, "Joe." What is ONe query would you use to obtaIN this INformatiON?
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = "Joe";

#2b. FINd all actors whose lASt name cONtaIN the letters GEN:
SELECT first_name, last_name FROM actor WHERE last_name like '%GEN%';

#2c. FINd all actors whose lASt names cONtaIN the letters LI. This time, order the rows by lASt name and first name, IN that order:
SELECT first_name, last_name FROM actor WHERE last_name like '%LI%' ORDER BY last_name, first_name ;

#2d. UsINg IN, display the country_id and country columns of the followINg countries: Afghanistan, Bangladesh, and ChINa:
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'ChINa');

#3a. Add a middle_name column to the table actor. PositiON it between first_name and last_name. HINt: you will need to specify the data type.
ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(100) AFTER first_name;

#3b. You realize that some of these actors have tremendously lONg lASt names. Change the data type of the middle_name column to blobs.
ALTER TABLE actor
MODIFY middle_name BLOB;

#3c. Now delete the middle_name column.
ALTER TABLE actor
DROP COLUMN middle_name;

#4a. List the lASt names of actors, AS well AS how many actors have that lASt name.
SELECT last_name, count(last_name) num_actors_with_last_name FROM actor GROUP BY last_name;

#4b. List lASt names of actors and the number of actors who have that lASt name, but ONly for names that are shared by at leASt two actors
SELECT last_name, count(last_name) num_actors_with_last_name FROM actor GROUP BY last_name having num_actors_with_last_name >= 2;


#4c. Oh, no! The actor HARPO WILLIAMS wAS accidentally entered IN the actor table AS GROUCHO WILLIAMS, the name of Harpo's secONd cousIN's husband's yoga teacher. Write a query to fix the record.
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' and last_name = 'WILLIAMS';

#4d. Perhaps we were too hASty IN changINg GROUCHO to HARPO. It turns out that GROUCHO wAS the correct name after all! IN a sINgle query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, AS that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (HINt: update the record usINg a unique identifier.)
UPDATE actor
SET first_name = CASE
		WHEN first_name = 'HARPO' THEN 'GROUCHO'
		ELSE 'MUCHO GROUCHO'
END
WHERE actor_id = 172 ;

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it? 
#HINt: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
DESCRIBE address;

#6a. Use JOIN to display the first and lASt names, AS well AS the address, of each staff member. Use the tables staff and address:
SELECT first_name, last_name, address FROM staff INNER JOIN address ON staff.address_id = address.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member IN August of 2005. Use tables staff and payment. 
SELECT 
	staff.staff_id AS staff_id,
    first_name,
	sum(amount) total_amount_per_member
FROM
	staff
INNER JOIN
	payment ON staff.staff_id = payment.staff_id
WHERE year(payment_date) = 2005 and mONth(payment_date) = 08
GROUP BY staff_id, first_name;
    
#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use INNER JOIN.
SELECT
	film.film_id,
    title,
    count(actor_id) num_actors
FROM
	film_actor
INNER JOIN
	film ON film_actor.film_id = film.film_id
GROUP BY film.film_id, title;

#6d. How many copies of the film Hunchback Impossible exist IN the inventory system?
SELECT
	film.film_id,
    title,
    count(inventory_id) num_copies
FROM
	film
INNER JOIN
	inventory ON film.film_id = inventory.film_id
WHERE
	title = "Hunchback Impossible"
GROUP BY film.film_id, title;


#6e. UsINg the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by lASt name:
SELECT
	first_name,
    last_name,
    sum(amount) AS 'Total Amount Paid'
FROM
	customer
INNER JOIN
	payment ON customer.customer_id = payment.customer_id
GROUP BY first_name, last_name
ORDER BY last_name asc;
    
#7a. The music of Queen and Kris KristoffersON have seen an unlikely resurgence. AS an unINtended cONsequence, films startINg with the letters K and Q have also soared IN popularity. Use subqueries to display the titles of movies startINg with the letters K and Q whose language is English. 
SELECT 
	title
FROM
	film
WHERE 
	language_id IN (SELECT language_id FROM language WHERE name = "English")
    and title LIKE "K%" or title LIKE  "Q%";
    
#7b. Use subqueries to display all actors who appear IN the film AlONe Trip.
SELECT
	first_name,
    last_name
FROM
	actor
WHERE actor_id IN (SELECT actor_id FROM film_actor WHERE film_id IN (SELECT film_id FROM film WHERE title = "AlONe Trip"));

#7c. You want to run an email marketINg campaign IN Canada, for which you will need the names and email addresses of all Canadian customers. Use joINs to retrieve this INformatiON.

SELECT
	first_name,
    last_name,
    email
FROM
	customer
INNER JOIN
	address ON customer.address_id = address.address_id
INNER JOIN 
	city ON address.city_id = city.city_id
INNER JOIN
	country ON city.country_id = country.country_id
WHERE country = 'Canada';

#7d. Sales have been laggINg amONg young families, and you wish to target all family movies for a promotiON. Identify all movies categorized AS famiy films.
SELECT
	title
FROM
	film_category
INNER JOIN
	film ON film_category.film_id = film.film_id WHERE category_id IN (SELECT category_id FROM category WHERE name = "Family") ;

#7e. Display the most frequently rented movies IN descendINg order.
SELECT
    title,
    inventory.film_id,
    count(inventory.film_id) num_times_rented
FROM
	rental
INNER JOIN
	inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN
	film ON inventory.film_id = film.film_id
GROUP BY title, inventory.film_id
ORDER BY num_times_rented desc
;
    
#7f. Write a query to display how much busINess, IN dollars, each store brought IN.
SELECT
	s.store_id, 
    SUM(amount) AS Gross 
FROM 
	payment p 
JOIN rental r ON (p.rental_id = r.rental_id)
JOIN inventory i ON (i.inventory_id = r.inventory_id)
JOIN store s ON (s.store_id = i.store_id)
GROUP BY s.store_id;

#7g. Write a query to display for each store its store ID, city, and country.
SELECT 
	store_id,
    city,
    country
FROM 
	store
INNER JOIN
	address ON store.address_id = address.address_id
INNER JOIN
	city ON address.city_id = city.city_id
INNER JOIN
	country ON city.country_id = country.country_id;
    

#7h. List the top five genres IN gross revenue IN descendINg order. (HINt: you may need to use the followINg tables: category, film_category, inventory, payment, and rental.)
SELECT category.name, sum(payment.amount) AS revenue
FROM rental
INNER JOIN payment ON rental.rental_id = payment.rental_id
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film_category ON inventory.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY revenue desc 
LIMIT 5;

#8a. IN your new role AS an executive, you would like to have an eASy way of viewINg the Top five genres by gross revenue. Use the solutiON FROM the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW Top_Five_Genres AS 
SELECT category.name, sum(payment.amount) AS revenue
FROM rental
INNER JOIN payment ON rental.rental_id = payment.rental_id
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film_category ON inventory.film_id = film_category.film_id
INNER JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY revenue desc 
LIMIT 5;

#8b. How would you display the view that you created IN 8a?
SELECT * FROM top_five_genres;

#8c. You fINd that you no lONger need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_genres;




