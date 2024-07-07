USE sakila;

/* 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados. */
-- Usamos DISTINCT para evitar datos duplicados.
SELECT DISTINCT title AS TITULO
FROM film;

/* 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".*/
-- Muestro título y rating para verificar que todas son PG-13
SELECT title AS TITULO, rating
FROM film
WHERE rating = "PG-13";

/* 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.*/

SELECT title, description
FROM film
WHERE description LIKE ("%amazing");

SELECT title, description
FROM film
WHERE description IN ("amazing");

/* 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos. */
SELECT title AS TITULO, length AS DURACION
FROM film
WHERE length > 120;

/* 5. Recupera los nombres de todos los actores.*/
SELECT actor_id AS ID, first_name AS NOMBRE, last_name AS APELLIDO 
FROM actor;

/*6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.*/
SELECT actor_id AS ID, first_name AS NOMBRE, last_name AS APELLIDO 
FROM actor
WHERE last_name LIKE ("%GIBSON%");
-- Uso like porque el enunciado indica "apellidos que tengan Gibson", podría haber un apellido "Gibsone", por ejemplo. 

-- Si quiere decir "que el apellido sea exactamente Gibson, etonces usamos IN:
SELECT actor_id AS ID, first_name AS NOMBRE, last_name AS APELLIDO 
FROM actor
WHERE last_name IN ("GIBSON");

/*7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.*/
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

/*8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.*/
SELECT title AS TITULO, rating
FROM film
WHERE rating <> "PG-13" AND rating <> "R";

/*9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con
el recuento.*/
SELECT rating AS CLASIFICACION, COUNT(*) AS CANTIDAD_TOTAL_PELICULAS
FROM film
GROUP BY rating; 

/*10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y
apellido junto con la cantidad de películas alquiladas.*/
SELECT *
FROM rental
ORDER BY customer_id;

-- Tenemos toda la info que queremos en la tabla rental, menos nombre y apellido del customer, 
-- hacemos un join para coger estos datos a traves de la PK/FK customer_id

SELECT c.first_name, c.last_name, r.customer_id, COUNT(*) AS PELICULAS_TOTALES_ALQUILADAS
FROM rental AS r
LEFT JOIN customer AS c
ON r.customer_id = c.customer_id
GROUP BY customer_id; 



/*11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el
recuento de alquileres.*/
SELECT category_id, name
FROM category;

SELECT film_id, category_id
FROM film_category;

SELECT film_id, inventory_id
FROM inventory;

SELECT rental_id, inventory_id, customer_id
FROM rental;

SELECT c.name AS NOMBRE_CATEGORÍA, COUNT(r.rental_id) AS PELICULAS_TOTALES_ALQUILADAS
FROM rental AS r
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film_category AS fc ON i.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
GROUP BY c.name;


/*12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la
clasificación junto con el promedio de duración*/
SELECT rating, AVG(length) AS PROMEDIO_DURACION
FROM film
GROUP BY rating;

/*13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".*/

SELECT DISTINCT a.actor_id, a.first_name, a.last_name
FROM actor AS a 
LEFT JOIN film_actor AS fa 
ON a.actor_id = fa.actor_id
LEFT JOIN film AS f
ON fa.film_id = f.film_id
WHERE f.title = "Indian love";

/*14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.*/
SELECT title, description
FROM film
WHERE description LIKE "%dog%" OR description LIKE "%cat%";


/*15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla film_actor.*/
SELECT a.actor_id
FROM actor AS a
LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL;

-- usando subconsulta
SELECT a.actor_id, a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor AS fa);




/*16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.*/
SELECT title, release_year
FROM FILM
WHERE release_year BETWEEN 2005 AND 2010;

/*17. Encuentra el título de todas las películas de la categoría "Family".*/
SELECT f.film_id, f.title, c.name
FROM film AS f
LEFT JOIN film_category AS fc
ON f.film_id = fc.film_id
LEFT JOIN category AS c
ON fc.category_id = c.category_id
WHERE c.name = "Family";
-- No es necesario seleccionar el name pues siemre será Family, pero lo cogí para su verifiación

/*18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.*/
SELECT *
FROM film_actor;

SELECT actor_id, COUNT(film_id)
FROM film_actor
GROUP BY actor_id;

SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS PELICULAS_TOTALES
FROM actor AS a
LEFT JOIN film_actor AS fa
ON a.actor_id = fa.actor_id
GROUP BY actor_id
HAVING PELICULAS_TOTALES > 10;
-- Usamos having porque WHERE no puede usarse en agrupaciones, solo en esultados individuales.

/*19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.*/
SELECT title AS TITULO, length, rating
FROM film
WHERE rating = "R" AND length > 120
ORDER BY length ASC;
-- Otra vez, seleccionar RATING no es necesario.

/*20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el
nombre de la categoría junto con el promedio de duración.*/
SELECT c.category_id, AVG(f.length) AS PROMEDIO_DURACION
FROM film AS f
LEFT JOIN film_category AS fc
ON f.film_id = fc.film_id
LEFT JOIN category AS c
ON fc.category_id = c.category_id
GROUP BY c.category_id
HAVING PROMEDIO_DURACION > 120;


-- DUDA, POR KE NO PUEDO PONER SELECT fc.category_id en lugar de SELECT c.category_id?

/*21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la
cantidad de películas en las que han actuado.*/
SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS PELICULAS_TOTALES
FROM actor AS a
LEFT JOIN film_actor AS fa
ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING PELICULAS_TOTALES >= 5;


/*22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para
encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.*/
SELECT title, rental_duration
FROM film
WHERE rental_duration > 5;

SELECT DISTINCT f.title, f.rental_duration, r.rental_id
FROM film AS f
INNER JOIN inventory AS i
ON f.film_id = i.film_id
INNER JOIN rental AS r
ON i.inventory_id = r.inventory_id
WHERE f.rental_duration > 5;

-- Ahora lo hacemos con una subconsulta

SELECT DISTINCT f.title, f.rental_duration, r.rental_id
FROM film AS f
INNER JOIN inventory AS i
ON f.film_id = i.film_id
INNER JOIN rental AS r
ON i.inventory_id = r.inventory_id
WHERE r.rental_id IN (
	SELECT rental_id 
    FROM rental
    WHERE rental_duration > 5);
    -- Otra forma de encontrar la fecha es:  DATEDIFF(return_date, rental_date) > 5);

/*23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror".
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego
exclúyelos de la lista de actores.*/

SELECT actor_id, first_name, last_name
FROM actor;

SELECT actor_id, film_id
FROM film_actor;

SELECT film_id, category_id
FROM film_category;

SELECT category_id, name
FROM category;

SELECT a.first_name, a.last_name
FROM actor AS a
WHERE a.actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor AS fa
    JOIN film AS f 
    ON fa.film_id = f.film_id
    JOIN film_category AS fc 
    ON f.film_id = fc.film_id
    JOIN category AS c 
    ON fc.category_id = c.category_id
    WHERE c.name = "Horror")
ORDER BY a.last_name;


-- No he conseguido hacerlo in subconsulta pero me gustaría
SELECT DISTINCT a.first_name, a.last_name -- , a.actor_id, fa.film_id, fc.category_id
FROM actor AS a
INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
INNER JOIN film_category AS fc ON fa.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
WHERE a.actor_id NOT IN (c.name = "Horror")
ORDER BY a.last_name;

SELECT DISTINCT a.actor_id, a.first_name, a.last_name
FROM actor AS a
LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id
LEFT JOIN film_category AS fc ON fa.film_id = fc.film_id
LEFT JOIN category AS c ON fc.category_id = c.category_id AND c.name = 'Horror'
WHERE c.category_id IS NULL
ORDER BY a.last_name;

-- todos los generos de las pelis en las que ha participado christian akroyd id 58
SELECT a.first_name, a.last_name, a.actor_id, c.name, fc.category_id
FROM actor AS a
INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
INNER JOIN film_category AS fc ON fa.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
WHERE a.actor_id = 58;

/*24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la
tabla film.*/
SELECT f.title
FROM film AS f
LEFT JOIN film_category AS fc ON f.film_id = fc.film_id
LEFT JOIN category AS c ON fc.category_id = c.category_id
WHERE c.name = "Comedy" AND f.length > 180;




