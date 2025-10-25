select
    job_schedule_type,
   avg(salary_year_avg) as yearly_salary_avg,
   avg( salary_hour_avg) as hourly_salary_avg
from job_postings_fact 
where job_posted_date > '2023-06-01'
GROUP BY job_schedule_type; 

select 
   extract (month from job_posted_date at time zone 'utc' at time zone 'america/new_york') as month,
   count(*) as job_count
from job_postings_fact
where extract (year from job_posted_date at time zone 'utc' at time zone 'america/new_york') = '2023'
group by month
order by month desc;   

select job_postings.company_id,
       companies.name
from job_postings_fact as job_postings
left join company_dim as companies
on job_postings.company_id = companies.company_id
where job_postings.job_posted_date between '2023-04-01' and '2023-06-30'
and job_postings.job_health_insurance = true 
GROUP BY job_postings.company_id, companies.name;   