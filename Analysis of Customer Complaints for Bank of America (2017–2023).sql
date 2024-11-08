select *
from Complaints

--summary of the data

select count(complaints_id) unique_complaints,
count(*) total_complaints,
count(distinct Product) distinct_product,
count(distinct Issue) distinct_issue
from Complaints



--trends overtime : count complaints by year

select date_part('year',Date_submitted) years, count(*) total_complaints 
from complaints
group by date_part('year',Date_submitted)
order by 2 DESC


--count complaints by month and year

select date_part('year',Date_received) years,
to_char(date_received, 'month') as months,
count(*) total_complaints 
from complaints
group by date_part('year',Date_received), to_char(date_received, 'month')
order by 1



--count of complaints by products

select Product, count(*) Product_Count
from Complaints
group by Product
order by 2 desc



-- recurring issue

select Issue, count(*) as issue_count
from Complaints
group by Issue
order by 2 desc
LIMIT 10

--identifing most common issues within each product

select Product, Issue, count(*) as Issue_Count
from Complaints
group by Product, Issue
order by 1, 3 desc



-- checking top 5 issues in each product

with recurring as
(select Product, Issue, count(*) as issue_count
from Complaints
group by product, Issue
--order by 1, 3 desc
), top_recurring as
(
select *,
ROW_NUMBER() over(partition by product order by issue_count desc) row_num
from recurring
)
select *
from top_recurring
where row_num <= 5



-- calculating the percentage of timely responses

select
sum(case when timely_response = 'Yes' then 1 else 0 end) Timely,
sum(case when timely_response = 'No' then 1 else 0 end) Untimely,
sum(case when timely_response = 'Pending' then 1 else 0 end) Pending,
(sum(case when timely_response = 'Yes' then 1 else 0 end)* 100/ count(*)) timely_response_percentage
from Complaints



-- timely response by year

select date_part('year',Date_received) years,
count(*) total_complaints,
sum(case when timely_response = 'Yes' then 1 else 0 end) Timely,
(sum(case when timely_response = 'Yes' then 1 else 0 end)* 100/ count(*)) timely_response_percentage
from Complaints
group by date_part('year',Date_received)
order by 1

-- product with untimely responses

select  product,
count(*) total_complaints,
sum(case when timely_response = 'No' then 1 else 0 end) Untimely,
(sum(case when timely_response = 'No' then 1 else 0 end)* 100/ count(*)) untimely_response_percentage
from Complaints
group by Product
order by 2 desc

-- company response to comsumers

select Complaints.company_response_to_consumer, count(complaints.company_response_to_consumer)
from complaints
group by Complaints.company_response_to_consumer
order by 2 DESC


-- company response to public

select Complaints.company_public_response, count(Complaints.company_public_response)
from complaints
group by Complaints.company_public_response
order by 2 DESC





-- complaints by state per year

select State, COUNT(*) as complaints_count
from Complaints
group by state
order by 2 desc

-- top 5 issues by state


with complaints_cte as
(
select State, Issue, COUNT(*) as complaints_count
from Complaints
group by state, Issue
), top_complaints as
(
select *, ROW_NUMBER() over(partition by state order by complaints_count desc) as row_num
from complaints_cte
)
select *
from top_complaints
where row_num <=5









