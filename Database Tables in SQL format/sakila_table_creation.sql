create database sakila;

use sakila;

create table actor (
	actor_id int ,
    first_name varchar(100),
    last_name varchar(100),
    last_update timestamp,
    primary key(actor_id)
);

create table category (
	category_id int,
    name varchar(50),
    last_update timestamp,
    primary key(category_id)
);

create table language (
	language_id int,
    name varchar(50),
    last_update timestamp,
    primary key (language_id)
);

create table country(
	country_id int,
    country_name varchar(255),
    last_update timestamp,
    primary key (country_id)
);

show tables;

create table city (
	city_id int,
    city_name varchar(255),
    country_id int,
    last_update timestamp,
    primary key (city_id),
    foreign key(country_id) references country(country_id)
);

create table film (
	film_id int,
	title varchar(255),
	description text,
	release_year year,
	language_id int,
	original_language_id int,
	rental_duration int,
	rental_rate float,
	length int,
	replacement_cost float,
	rating varchar(50),
	special_features text,
	last_update timestamp,
    primary key(film_id),
    foreign key(language_id) references language(language_id)
);

create table film_category(
	film_id int,
    category_id int,
    last_update timestamp,
    primary key (film_id),
    foreign key (category_id) references category(category_id)
);


