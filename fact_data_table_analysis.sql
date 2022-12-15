-- View the available database in my local db 
show databases;

-- Cmd to start using the sakila schema 
use sakila;

-- To view the tables inside the schema 
show tables;

-- To count the number of tables inside the schema 
SELECT count(*) AS "Total Number of Tables"
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'sakila';
-- O/P: There are 15 tables inside the schema

-- Sanity check of the tables including the number of rows, unique count, Null Values etc.
-- ******************************************************************************************************************************--
-- Table Name: actor

select * from actor limit 100;  
-- Unique count of the number of actors present in the table
select count(distinct(actor_id)) as number_of_actors from actor;
-- There exists 200 actors in the actor table

-- Sorting the entire table on the basis of last update
select * from actor order by last_update desc; 
-- O/P: It can be seen that all the rows are updated on the exact date and the same timings 

-- The name column is split into two individual entity first name and last name this can be merged to a single column as full name.
-- Before making any changes in the actual production database table lets create a temporary table and make the changes there. 
create temporary table actors_dupl
select * from actor; 

select *, substring(first_name, 2) from actors_dupl;

select *, concat(substring(first_name,1, 1), lower(substring(first_name, 2)), 
			" ", concat(substring(last_name,1, 1), lower(substring(last_name, 2)))) as full_name from actors_dupl;

alter table actors_dupl add  full_name varchar(100);

select * from actors_dupl limit 100;

-- Populating full_name column with the merged data of first and last name.  
update actors_dupl set  full_name = concat(substring(first_name,1, 1), lower(substring(first_name, 2)), 
							" ", concat(substring(last_name,1, 1), lower(substring(last_name, 2)))); 
 
-- Checking out for Duplicate Data in the table. Lets check out if there exists any duplicate name or not.
select first_name, last_name, count(first_name), count(last_name)
from actors_dupl
group by 1, 2
having count(first_name)> 1 or count(last_name)>1
order by 3, 4;

-- There exists one duplicate record by the name of Susan Davis
select * from actors_dupl where full_name like '%susan%';
-- At this moment we will keep the duplicate data instead of deleting it.

-- Now adding the full_name column in the production table.

alter table actor add column full_name varchar(100); 

update actor set  full_name = concat(substring(first_name,1, 1), lower(substring(first_name, 2)), 
							" ", concat(substring(last_name,1, 1), lower(substring(last_name, 2)))); 
                            
select * from actor limit 10;
-- ******************************************************************************************************************************--

-- Category Table 
select * from category limit 100;

select count(distinct(name)) as no_of_countries from category;
-- There exists 16 countries

-- ******************************************************************************************************************************--

-- Country Table
select * from country limit 100; 
select count(*) as number_of_countries from country;

-- Unique countries the country table consists
select count(distinct(country_name))as number_of_countries from country;
-- There exists total of 109 countries

-- ******************************************************************************************************************************--

--  Language Table
select * from language limit 100;




