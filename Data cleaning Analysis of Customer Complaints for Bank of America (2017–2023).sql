-- Data cleaning
-- looking for duolicates


select *
from Complaints

with duplicates_cte as
(
select*,
ROW_NUMBER() over(partition by complaints_id order by complaints_id) as row_num
from Complaints
)
select *
from duplicates_cte
where row_num >1



-- looking at null vaules

update complaints
SET timely_response = 'Pending'
where timely_response is NULL



update Complaints
set Company_public_response  = 'No Resonse'
where Company_public_response  is null

select sub_product
from complaints
where sub_product is null

update Complaints
set sub_product  = 'unspecified'
where sub_product is null


update Complaints
set sub_issue  = 'unspecified'
where sub_issue is null






