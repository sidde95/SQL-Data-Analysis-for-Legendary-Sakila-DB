-- Data Analysis with SQL for the Sakila Database
use sakila;

-- 1.	Countries where the services are provided.
select * from country;
-- The DVD rental service is provided in 109 countries

-- 2.	Countries having the highest cities.
select a.country_name, count(b.country_id) no_of_cities 
from country a 
join city b using(country_id) 
group by 1 
order by 2 desc limit 10;
-- India is the country where the rental service is provided and has the highest number of cities i.e., 60.


-- 3.	Countries with having the highest customers. 
select country_name, count(customer.customer_id) as no_of_customers
from customer 
join address using(address_id) 
join city using(city_id) 
join country using(country_id) 
group by 1
order by 2 desc; 

-- 4.	Cities having the highest number of customers.
select city_name, count(customer.customer_id) as no_of_customers,
sum(count(customer.customer_id)) over (order by count(customer.customer_id) desc, city_name ) as running_total
from customer 
join address using(address_id) 
join city using(city_id) 
group by 1
order by 2 desc;
-- Aurora has the highest number of customers.
 
-- 5.	Countries having the highest rental.
select country_name, count(rental_id) as number_of_rentals, 
sum(count(rental_id)) over (order by count(rental_id) desc, country_name ) as running_total
from country a
join city b on a.country_id = b.country_id
join address c on c.city_id = b.city_id
join customer d on d.address_id = c.address_id
join rental e on d.customer_id = e.customer_id
group by 1
order  by 2 desc;
-- India has the highest number of rentals 1572.

-- 6.	Country generating the highest revenue.
select country_name, round(sum(amount), 2) as rcv_payments, 
sum(round(sum(amount), 2)) over (order by round(sum(amount), 2) desc, country_name ) as running_total
from country a
join city b on a.country_id = b.country_id
join address c on c.city_id = b.city_id
join customer d on d.address_id = c.address_id
join payment e on d.customer_id = e.customer_id
group by 1
order  by 2 desc;
-- The highest received payment is from India 6630.27

-- 7.	Cities having the highest rental.
select city_name, count(rental_id) as number_of_rentals, 
sum(count(rental_id)) over (order by count(rental_id) desc, city_name ) as running_total
from city b 
join address c on c.city_id = b.city_id
join customer d on d.address_id = c.address_id
join rental e on d.customer_id = e.customer_id
group by 1
order  by 2 desc;
-- Aurora city in the USA has the highest amount of rentals, 50.

-- 8.	Cities having the highest revenue.
select city_name, round(sum(amount), 2) as rcv_payments, 
sum(round(sum(amount), 2)) over (order by round(sum(amount), 2) desc, city_name ) as running_total
from city b 
join address c on c.city_id = b.city_id
join customer d on d.address_id = c.address_id
join payment e on d.customer_id = e.customer_id
group by 1
order  by 2 desc;
-- Highest amount of payment has been received from Cape Coral, 221.55
 
-- 9.	Customers having the highest rental.
select b.full_name, count(a.rental_id) as no_of_rentals
from rental a 
inner join customer b on a.customer_id = b.customer_id
group by 1
order by 2 desc
limit 10;
-- Eleanor Hunt has the highest number of rentals, 46

-- 10.	Customer who produced the highest revenue(entire with address).
select full_name , round(sum(amount), 2) as rcv_amount
from customer a
join rental b using(customer_id)
join payment c using(rental_id)
group by 1
order by 2 desc;
-- Karl Seal has the highest amount paid 221.55

-- 11.	Store has the highest rental.
select store_id, count(store_id) as number_of_rentals 
from store a 
join inventory b using(store_id) 
join rental using (inventory_id) 
group by 1 order by 2 desc;
-- 2nd store has rented out the highest number of DVDs

-- 12.	Staff offering the highest rental.
select concat(a.first_name, " ", a.last_name) full_name, count(b.rental_id) as number_of_rentals 
from staff a 
join rental b on b.staff_id = a.staff_id
group by 1
order by 2 desc;
-- Mike Hillyer has rented out the highest number of DVDs


-- 13.	Store collecting the highest revenue.
select store_id, round(sum(amount), 2) as rcv_amount 
from store a 
join inventory b using(store_id) 
join rental using (inventory_id) 
join payment using(rental_id)
group by 1 order by 2 desc;
-- The 2nd store has collected the highest revenue for DVD rentals.
 
-- 14.	Staff collecting the highest payment.
select concat(a.first_name, " ", a.last_name) full_name, round(sum(z.amount), 2) as rcv_payment_amt 
from staff a 
join payment z on a.staff_id = z.staff_id
group by 1
order by 2 desc;
-- Jon Stephens has the highest received payment for DVD rent outs

-- 15.	Actor with the highest number of movies.
select a.full_name, count(b.film_id) as no_of_movies
from actor a 
join film_actor b using(actor_id)
group by 1 
order by 2 desc;
-- Susan Davis has the highest number of movies.

-- 16.	Movies with the highest rental.
select a.title, count(c.rental_id) as no_of_rentals
from film a
join inventory b using(film_id)
join rental c using(inventory_id)
group by 1 
order by 2 desc
limit 10;
-- BUCKET BROTHERHOOD has the highest rentals, 34.

-- 17.	Movies with the highest payment
select a.title, round(sum(d.amount), 2) as total_amt
from film a
join inventory b using(film_id)
join rental c using(inventory_id)
join payment d using(rental_id)
group by 1 
order by 2 desc
limit 10;
-- TELEGRAPH VOYAGE has produced the highest revenue -- 231.73

-- 18.	Which actors movie is the highest grossing.
select a.title, group_concat(f.full_name) "Actors/Actresses acted",  round(sum(d.amount), 2) as total_amt
from actor f
join film_actor e using(actor_id)
join film a using(film_id)
join inventory b using(film_id)
join rental c using(inventory_id)
join payment d using(rental_id)
group by 1 
order by 3 desc
limit 10;
-- TITANIC BOONDOCK by actors/actress amounted the highest 1857.24 in rentals.

-- 19. Write a query to find the full names of customers who have rented sci-fi, comedy, action and drama movies highest times.
select a.full_name,
		g.address, 
        h.city_name, 
        i.country_name,  
        count(f.category_id) as no_of_times_rented
from customer a 
	join rental b on a.customer_id = b.customer_id
	join inventory c on b.inventory_id = c.inventory_id
	join film d on d.film_id = c.film_id
	join film_category e on d.film_id = e.film_id
	join category f on f.category_id = f.category_id
	join address g on g.address_id = a.address_id
	join city h on g.city_id = g.city_id
	join country i on h.country_id = i.country_id
where f.name in ('Sci-Fi', 
				'Comedy', 
                'Action', 
                'Drama') 
group by 1, 2, 3, 4
having count(f.category_id) > 2
order by 2 desc, 1
limit 5;

-- 20. Film Category by Language
select distinct Title, category.name, language.name
from category 
join film_category using(category_id) 
join film using(film_id)
join language using(language_id);

-- 21. Rentals each month
select monthname(rental_date) as month_no, count(rental_id) no_of_rentals 
from rental
group by 1
order by 2 desc;
-- July has the highest rental 6709

-- 22. Revenue per month
select monthname(payment_date) as month_no, round(sum(amount), 2) no_of_rentals
from payment
group by 1
order by 2 desc;
-- July had the highest revenue 28373.89

-- 23. Highest grossing year
select year(payment_date) year, round(sum(amount), 2) revenue
from payment
group by 1
order by 2 desc;
-- 2005 produced the highest revenue

-- 24. Revenue between July, 2005 and January, 2006.
select round(sum(amount), 2) revenue_amt
from payment
where payment_date>= '2005-07-01'and payment_date <= '2006-01-31';

-- 25. Distinct renters per month.
select monthname(rental_date) as month_no, count(distinct(customer_id)) no_of_rentals 
from rental a 
join customer b using(customer_id)
group by 1 
order by 2 desc;
-- August and July has the highest distinct renters 

-- 26. Rentals which encountered no gain.
select a.rental_id, b.amount from rental a left join payment b using(rental_id) where b.amount = 0;

-- 27. Active and Inactive Customers.
select active, count(active) from customer group by active;

-- 28. Customers who bought DVDs instead of renting.
select * from payment where rental_id is null;

-- 29. In which quater was the highest revenue reported.
select 
	case 
		when (date(payment_date) between '2005-01-01' and '2005-03-31') or (date(payment_date) between '2006-01-01' and '2006-03-31') then 'Quarter 1'
        when (date(payment_date) between '2005-04-01' and '2005-06-30') or (date(payment_date) between '2006-04-01' and '2006-06-30') then 'Quarter 2'
        when (date(payment_date) between '2005-07-01' and '2005-09-30') or (date(payment_date) between '2006-07-01' and '2006-09-30') then 'Quater 3'
        when (date(payment_date) between '2005-10-01' and '2005-12-31') or (date(payment_date) between '2006-10-01' and '2006-12-31') then 'Quarter 4'
	end year_quater,
    round(sum(amount), 2) as revenue
 from payment 
 group by 1
 order by 2 desc;
 -- 3rd Quarter reported the maximum revenue of 52446.02
 
 -- 30. In which quater was the highest revenue reported.
 select quarter(rental_date) quarters, count(rental_id) as no_of_rental
 from rental
 group by 1
 order by 2 desc;
 -- 3rd quarter has been reported to have highest rentals with 12395 count
 
 -- 31. Which movie was rented more than 9 days.
 select title, datediff(return_date, rental_date) as rented_days
 from rental 
 join inventory using(inventory_id) 
 join film using(film_id) 
 where datediff(return_date, rental_date)>=10
 group by 1
 order by 2 desc;
 
-- 32. Which customer rented more than 9 days.
select full_name, datediff(return_date, rental_date) as rental_days
from rental 
join customer using(customer_id)
where datediff(return_date, rental_date)>=10
group by 1
order by 2 desc; 

-- 33. Which is the most popular genres.
select a.name , count(e.rental_id) as no_of_rentals
from category a
join film_category b on a.category_id = b.category_id
join film c on c.film_id = b.film_id
join inventory d on c.film_id = d.film_id
join rental e on d.inventory_id = e.inventory_id
group by 1
order by 2 desc;
-- Sports genre has the highest number of rentals.

-- 34. Which is the highest grossing genre.
select a.name , count(e.rental_id) as no_of_rentals, round(sum(f.amount), 2) as revenue
from category a
join film_category b on a.category_id = b.category_id
join film c on c.film_id = b.film_id
join inventory d on c.film_id = d.film_id
join rental e on d.inventory_id = e.inventory_id
join payment f on e.rental_id = f.rental_id
group by 1
order by 2 desc;
-- Sports is the highest grossing genre