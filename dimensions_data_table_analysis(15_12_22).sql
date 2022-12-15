-- Table Name City 
select * from city limit 100;

select distinct(count(*))  as number_of_countries from city;
-- There are 600 cities in the city table

-- Finding if any city has duplicate entry 
select city_name, count(city_name) as frequency from city group by 1 having count(city_name) > 1;
-- London has 2 entries
 
select * from city where city_name = 'London';
-- At this moment we will keep the duplicate data instead of deleting it.
-- ******************************************************************************************************************************--

-- film table
select * from film limit 100; 

-- In this column there exists a column original_language_id which has NULL values filled, let's check out the unique value of this column.
select original_language_id 
from film group by 1;
-- There exists only one column i.e., NULL and no other values, hence we can eliminate this column.

create temporary table film_temp
select * from film;

select * from film_temp; 

alter table film_temp drop column original_language_id;

-- Now making the same change of eliminating the column original_language_id in the production table.
alter table film drop column original_language_id; 

select * from film;

-- Lets see the unique count of movies in this table.
select count(distinct(film_id))  no_of_films from film;  -- 1000 films

-- comparing the above the result with the number of film name to see if there still exists any duplicate
select title, count(title)
from film group by 1 having count(title)>1; -- No duplicates exists

-- films which have special features
select * from film where special_features is null; -- not any

-- films which has no ratings
select * from film where rating is null; -- not any

-- film which no description
select * from film where description is null; -- not any

-- film whose realease year is missing
select * from film where release_year is null; -- not any

-- film whose running lenght is missing.
select * from film where length is null; -- not any

-- ******************************************************************************************************************************--

-- Customers Table
select * from customer limit 100; 

select count(distinct(customer_id)) no_of_customers from customer; 

-- Here it is visible that customers first name and last are parted in two different column, so for convinience we can merge them into a single column
create temporary table cust_temp
select * from  customer;

select * from cust_temp;

alter table cust_temp add column full_name varchar(100);
 
update cust_temp set full_name = concat(substring(first_name, 1, 1), lower(substring(first_name, 2)), " ", 
												substring(last_name, 1, 1), lower(substring(last_name, 2)));
                                                
-- Adding the column full_name in the production table
 alter table customer add column full_name varchar(100);
 
 update customer set full_name = concat(substring(first_name, 1, 1), lower(substring(first_name, 2)), " ", 
												substring(last_name, 1, 1), lower(substring(last_name, 2)));
                                                
select * from customer;

select customer_id, full_name from customer group by 1, 2 having count(full_name)>1;
-- No Duplicate Values present 

-- customers whose address_id is missing
select * from customer where address_id is null; -- not any

-- ******************************************************************************************************************************--
-- Staff Table
select * from staff; 
-- There are only 2 staffs present

-- ******************************************************************************************************************************--

-- Payment Table 
select * from payment;
select count(distinct(payment_id)) as no_of_payment_records from payment; -- 16049 records

-- payments whose rental_id is missing
select * from payment where rental_id is null;

-- sum of the payment_ids categorically
select 
	case 
		when rental_id is not null then 'rental_id_present' 
		when rental_id is null then 'rental_id_not_present'
	end as status,
	case 
		when rental_id is not null then round(sum(amount), 2)
		when rental_id is null then round(sum(amount), 2)
	end as collection
from payment
group by 1 
order by 2 desc;

-- ******************************************************************************************************************************--
-- Film Actor table
select * from film_category; 

-- number of records in this table
select count(*) as no_of_records from film_category; -- 1000 records

-- ******************************************************************************************************************************--

-- Inventory Table
select * from inventory limit 100;

select count(distinct(inventory_id)) as no_of_records from inventory; -- 4581 records

-- ******************************************************************************************************************************--

-- Address Table
select * from address limit 100; 

-- Here in the top 100 rows it is observed that columns address2, district, phone are having NULL values so lets check the unique values in these columns.
select address2, district, phone
from address
group by 1;
-- All these three rows are having NULL values so we can eliminate these rows from the table
create temporary table add_temp
select * from address; 

select * from add_temp;

alter table add_temp drop column address2, 
						drop column district, 
                        drop column phone;
                        
-- making the same changes in the production table
alter table address drop column address2,
					drop column district,
                    drop column phone;
                    
select * from address limit 100;

-- Number of NULL values in the postal code
select * from address where postal_code is NULL; -- Only 4 records i.e., 0.66% of the entire table

-- ******************************************************************************************************************************--
-- Store Table
select * from store limit 100; -- 2 records

-- ******************************************************************************************************************************--
-- Rental Table
select * from rental limit 100; 

select Count(distinct(rental_id)) as no_of_records from rental;

-- Checking if any records in rental table is having blank value in either inventory or customer column or return_date or three are blank
select * from rental
where inventory_id is NULL or customer_id is NULL or return_date is null or 
		(inventory_id is NULL and customer_id is NULL and return_date is null);
-- There are records present where return_date is null.

-- Count the records where return_date is null.
select case when return_date is null then "No return dates"
			when return_date is not null then "Return Dates present" 
		end as status, 
		case when return_date is null then count(rental_id)
			when return_date is not null then count(rental_id)
		end as count_of_null_records
from rental
group by 1
order by 2 desc;





