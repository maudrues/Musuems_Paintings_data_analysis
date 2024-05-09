-- Solve the below SQL problems using the Famous Paintings & Museum dataset:

SELECT * FROM artist;
SELECT * FROM canvas_size;
SELECT * FROM image_link;
SELECT * FROM museum_hours;
SELECT * FROM museum;
SELECT * FROM product_size;
SELECT * FROM subject;
SELECT * FROM work;


--1) Fetch all the paintings which are not displayed on any museums?
select *
from work where museum_id is null;


--2) Are there museuems without any paintings?

select * from museum m
	where not exists (select 1 from work w
					 where w.museum_id=m.museum_id)


--3) How many paintings have an asking price of more than their regular price? 
SELECT * FROM product_size 
where sale_price > regular_price;

--4) Identify the paintings whose asking price is less than 50% of its regular price
SELECT * FROM product_size 
where sale_price < (regular_price*0.5);

--5) Which canva size costs the most?
select cs.label as canva, ps.sale_price
	from (select *
		  , rank() over(order by sale_price desc) as rnk 
		  from product_size) ps
	join canvas_size cs on cs.size_id::text=ps.size_id
	where ps.rnk=1;					 


--6) Delete duplicate records from work, product_size, subject and image_link tables\
--ctid used when there is no unique identifier especially in rows ,it is hidden
delete  from work 
where exists (select *
			  from work  w2 
			  where w2.work_id = work .work_id and 
			        w2.name = work.name and 
			        w2.ctid >work.ctid  );

delete  from work 
where ctid not in (select   min(ctid)
						from work
						group by work_id );

--7) Identify the museums with invalid city information in the given dataset
select name from museum
where city ~ '^[0-9]';

--8) Museum_Hours table has 1 invalid entry. Identify it and remove it.
delete from museum_hours
where ctid not in (select min(ctid) from museum_hours
				  group by museum_id ,day);

--9) Fetch the top 10 most famous painting subject
--op1
select * from (select count(subject)as c ,subject
from subject
group by subject
order by c desc) limit 10;
 
--op2
select * 
	from (
		select s.subject,count(1) as no_of_paintings
		,rank() over(order by count(1) desc) as ranking
		from work w
		join subject s on s.work_id=w.work_id
		group by s.subject ) x
	where ranking <= 10;


--10 dentify the museums which are open on both Sunday and Monday. Display museum name, city.
  
 select m.name,m.city 
 from museum m
 join museum_hours mh on mh.museum_id=m.museum_id
 where mh.day = 'Sunday' 
  and exists (select * from museum_hours mh2
			  where  mh2.museum_id = mh.museum_id
			  and mh2.day = 'Monday')
  
--11) How many museums are open every single day?

select count(m.name) as number_of_museums
 from museum m
 join museum_hours mh on mh.museum_id=m.museum_id
 where mh.day = 'Sunday' 
  and exists (select * from museum_hours mh2
			  where  mh2.museum_id = mh.museum_id
			  and mh2.day = 'Monday')
			  
and exists (select * from museum_hours mh2
			  where  mh2.museum_id = mh.museum_id
			  and mh2.day = 'Tuesday')
--12 goes on till saturday buh it will be a repetition therfore we opt for this other option
select count(1)
	from (select museum_id, count(1)
		  from museum_hours
		  group by museum_id
		  having count(1) = 7) x;
			  
			  
--13) Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)

select museum_id, count(1) as c
from work
where museum_id is not null
group by museum_id
order by c desc
limit 5;

--opt2
select m.name as museum, m.city,m.country,x.no_of_painintgs
	from (	select m.museum_id, count(1) as no_of_painintgs
			, rank() over(order by count(1) desc) as rnk
			from work w
			join museum m on m.museum_id=w.museum_id
			group by m.museum_id) x
	join museum m on m.museum_id=x.museum_id
	where x.rnk<=5;


--14) Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)

SELECT * FROM artist;
SELECT * FROM work;

select a.full_name as artist, a.nationality,x.no_of_painintgs
	from (	select a.artist_id, count(1) as no_of_painintgs
			, rank() over(order by count(1) desc) as rnk
			from work w
			join artist a on a.artist_id=w.artist_id
			group by a.artist_id) x
	join artist a on a.artist_id=x.artist_id
	where x.rnk<=5;


--15) Display the 3 least popular canva sizes.
--NB size_id's dtype in canvas_size(int) and product size(text) are different so we use ::text to convert to text

SELECT * FROM canvas_size;
SELECT * FROM product_size;
SELECT * FROM work;

select label,ranking,no_of_paintings
	from (
		select cs.size_id,cs.label,count(1) as no_of_paintings
		, dense_rank() over(order by count(1) ) as ranking
		from work w
		join product_size ps on ps.work_id=w.work_id
		join canvas_size cs on cs.size_id::text = ps.size_id
		group by cs.size_id,cs.label) x
	where x.ranking<=3;
	
	
--16) Which museum is open for the longest during a day. Display museum name, state and hours open and which day?
SELECT * FROM museum_hours;
SELECT * FROM museum;

select name, state, day, hours_open
from  (select m.name,m.state,day
	  , to_timestamp(open,'HH:MI AM') 
			, to_timestamp(close,'HH:MI PM') 
			, to_timestamp(close,'HH:MI PM') - to_timestamp(open,'HH:MI AM') as hours_open
	  , rank() over(order by ( (to_timestamp(close,'HH:MI PM') - to_timestamp(open,'HH:MI AM'))) desc) as rank
	   from  museum_hours mh   
	   join museum m  on m.museum_id=mh.museum_id)x
where x.rank=1
--opt2
select museum_name,state as city,day, open, close, duration
	from (	select m.name as museum_name, m.state, day, open, close
			, to_timestamp(open,'HH:MI AM') 
			, to_timestamp(close,'HH:MI PM') 
			, to_timestamp(close,'HH:MI PM') - to_timestamp(open,'HH:MI AM') as duration
			, rank() over (order by (to_timestamp(close,'HH:MI PM') - to_timestamp(open,'HH:MI AM')) desc) as rnk
			from museum_hours mh
		 	join museum m on m.museum_id=mh.museum_id) x
	where x.rnk=1;


--17) Which museum has the most no of most popular painting style?

SELECT * FROM work;
SELECT * FROM museum;

select museum_name , style ,no_of_paintings
from ( select m.name as museum_name ,w.style, rank () over (order by (count(w.style))desc)as rank ,count(1) as no_of_paintings
	 from museum m
	 join work w on w.museum_id=m.museum_id
	 group by m.name ,w.style )x
where x.rank=1
 
 --opt 2
with pop_style as 
			(select style
			,rank() over(order by count(1) desc) as rnk
			from work
			group by style),
		cte as
			(select w.museum_id,m.name as museum_name,ps.style, count(1) as no_of_paintings
			,rank() over(order by count(1) desc) as rnk
			from work w
			join museum m on m.museum_id=w.museum_id
			join pop_style ps on ps.style = w.style
			where w.museum_id is not null
			and ps.rnk=1
			group by w.museum_id, m.name,ps.style)
	select museum_name,style,no_of_paintings
	from cte 
	where rnk=1;


--18) Identify the artists whose paintings are displayed in multiple countries
SELECT * FROM artist;
SELECT * FROM museum;
SELECT * FROM work;

--with cte as 
--(select *
 -- from (work w
--  join artist a on a.artist_id=w.artist_id) )
	 
				select artist_name  ,count(1) as no_of_countries
				from ( select distinct a.full_name as artist_name  
					 from  work w
					 join artist a on a.artist_id=w.artist_id
					 join museum m on m.museum_id=w.museum_id
					 )
				group by artist_name
				having count(1)>1
				order by 2 desc;

	  
--opt2	  
with cte as
		(select distinct a.full_name as artist
		--, w.name as painting, m.name as museum
		, m.country
		from work w
		join artist a on a.artist_id=w.artist_id
		join museum m on m.museum_id=w.museum_id)
	select artist,count(1) as no_of_countries
	from cte
	group by artist
	having count(1)>1
	order by 2 desc;	  

 	  

--19) Display the country and the city with most no of museums. Output 2 seperate columns to mention the city and country.
--If there are multiple value, seperate them with comma.

SELECT * FROM museum;


select string_agg(distinct m.country,', '), string_agg(m.city,', ')
from (select country, city,rank() over(order by count(1) desc) as rank
      from museum 
	  group by country, city
      )m
where rank =1;


--opt2
with cte_country as 
			(select country, count(1)
			, rank() over(order by count(1) desc) as rnk
			from museum
			group by country),
		cte_city as
			(select city, count(1)
			, rank() over(order by count(1) desc) as rnk
			from museum
			group by city)
	select string_agg(distinct country.country,', '), string_agg(city.city,', ')
	from cte_country country
	cross join cte_city city
	where country.rnk = 1
	and city.rnk = 1;

--20) Identify the artist and the museum where the most expensive and least expensive painting is placed.
--Display the artist name, sale_price, painting name, museum name, museum city and canvas label


SELECT * FROM artist; --artist name
SELECT * FROM museum;--museum name, museum city
SELECT * FROM product_size;  --sale_price ;workid,size id
SELECT * FROM work;--painting name ;artistid,museumid,workid
SELECT * FROM canvas_size; --canvas label ;sizeid


with cte_work_artist_museum as
     (select a.full_name as artist_name,m.name as museum_name ,m.city ,w.name as painting_name,w.work_id
	 from work w
	 join artist a on a.artist_id=w.artist_id
	  join museum m on m.museum_id=w.museum_id
     ),
	 
	 cte_PC as
	 ( select p.sale_price,c.label,p.work_id
	  from product_size p
	  join canvas_size c on c.size_id::text=p.size_id
	 ),
	 
	final as 
	(select * , rank() over(order by sale_price desc) as rnk
		, rank() over(order by sale_price ) as rnk_asc
	 from cte_work_artist_museum y
	 join  cte_PC z on z.work_id=y.work_id
	)
	 
select  artist_name,museum_name,city,painting_name,sale_price,label 
from final
where rnk=1 or rnk_asc=1;
	 
--opt2	 
with cte as 
		(select *
		, rank() over(order by sale_price desc) as rnk
		, rank() over(order by sale_price ) as rnk_asc
		from product_size )
	select w.name as painting
	, cte.sale_price
	, a.full_name as artist
	, m.name as museum, m.city
	, cz.label as canvas
	from cte
	join work w on w.work_id=cte.work_id
	join museum m on m.museum_id=w.museum_id
	join artist a on a.artist_id=w.artist_id
	join canvas_size cz on cz.size_id = cte.size_id::NUMERIC
	where rnk=1 or rnk_asc=1;


--21) Which country has the 5th highest no of paintings?
SELECT * FROM museum;
SELECT * FROM work;


select country,number_of_paintings
from (select country, rank()over(order by count(1)desc)as rank,count(1) as number_of_paintings
	 from work w
	 join museum m on m.museum_id=w.museum_id
	 group by country
	 )
where rank=5;


--opt2
with cte as 
		(select m.country, count(1) as no_of_Paintings
		, rank() over(order by count(1) desc) as rnk
		from work w
		join museum m on m.museum_id=w.museum_id
		group by m.country)
	select country, no_of_Paintings
	from cte 
	where rnk=5;

--22) Which are the 3 most popular and 3 least popular painting styles?
SELECT * FROM work;

select style, number_of_work ,  pop_rank,case when pop_rank <=3 then 'Most Popular' else 'Least Popular' end as remarks 
from (select style,count(1) as number_of_work , rank()over(order by count(1) desc) as pop_rank, rank()over(order by count(1) asc) as notpop_rank
	  from work
	  where style is not null
	 group by style)
where pop_rank<=3 
or notpop_rank<=3;


--opt2
with cte as 
		(select style, count(1) as cnt
		, rank() over(order by count(1) desc) rnk
		, count(1) over() as no_of_records
		from work
		where style is not null
		group by style)
	select style
	, case when rnk <=3 then 'Most Popular' else 'Least Popular' end as remarks 
	from cte
	where rnk <=3
	or rnk > no_of_records - 3;


--23) Which artist has the most no of Portraits paintings outside USA?. Display artist name, no of paintings and the artist nationality.
SELECT * FROM artist;--name,nationality.....artistid
SELECT * FROM museum;-- outside usa,country.....museumid
SELECT * FROM work;--numuber of paintings.....artistid,workid,museumid
SELECT * FROM subject;--potrait....subject,workid

select artist_name,no_of_paintings,artist_nationality
from (select  a.full_name as artist_name,count(1) as no_of_paintings,a.nationality as artist_nationality ,rank() over(order by count(1)desc) as rank
	 from work w
	 join artist a on a.artist_id=w.artist_id
	  join subject s on s.work_id=w.work_id
	 join museum m on m.museum_id=w.museum_id
	 
	 where s.subject = 'Portraits'
     and m.country != 'USA'
	 group by a.full_name,a.nationality )x
     
where rank =1;



