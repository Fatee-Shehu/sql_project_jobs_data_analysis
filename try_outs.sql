-- case expression:
select COUNT(Job_id) as number_of_jobs,
       case 
           when job_location = 'Anywhere' then 'Remote'
           when job_location = 'New York, NY' THEN 'Local'
           else 'onsite'
        end as location_category   
from job_postings_fact
where job_title_short = 'Data Analyst'
group by location_category;    

--assignment
select  
      count(salary_year_avg),
      case 
          when salary_year_avg > '500000' then 'high'
          when salary_year_avg between '100000' and '400000' then 'standard'
          else 'low'
        end as salary_category
from job_postings_fact
where job_title_short = 'Data Analyst'
group by salary_category;

--Subqueries and CTEs
select *
from (--subQuery starts here
      select *
      from job_postings_fact
      where extract (month from job_posted_date) = 1
)as january_jobs;      
--SubQuery ends here

with january_jobs as (--CTEs starts here)
      select *
      from job_postings_fact
      where extract(month from job_posted_date) = 1
)-- CTEs ends here      
select *
from january_jobs;

select company_id,
       name as company_name
from 
       company_dim
where company_id in (
select 
      company_id
from 
     job_postings_fact 
where 
     job_no_degree_mention = true 
)

/* fin companies with the most job openings
- get  total number of job postings per company (job postings fact table)
- return total number of jobs with company name. company im table.
*/
with company_job_counts as (
select company_id,
      count (*) total_jobs
from job_postings_fact
group by company_id
)
select company_dim.name as company_name,
      company_job_counts.total_jobs
from company_dim
left join company_job_counts 
on company_job_counts.company_id = company_dim.company_id
order by total_jobs desc

/* find the count number of remote jobs postings per skills
- display the top 5 skills of remote jobs
- display their skill id, skills type  and count rrequiring per skill.
*/
with remote_job_skills as (
select skill_id,
      count (*) as skills_count
from skills_job_dim as skills_to_job
inner join job_postings_fact as job_postings
on skills_to_job.job_id = job_postings.job_id
where job_postings.job_work_from_home = true and
      job_postings.job_title_short = 'Data Analyst'
GROUP BY skill_id
)
select skills.skill_id,
       skills as skill_name,
       skills_count
from remote_job_skills
inner join skills_dim as skills
on skills.skill_id = remote_job_skills.skill_id
order by skills_count desc
limit 5;

--assignment on subquery
select skills.skill_id,
       skills.skills AS skills_names,
       skills_counted
from (       
select skill_id,
       count(*) as skills_counted
from skills_job_dim
group by skill_id
ORDER BY skills_counted desc
)
as top_skills
join skills_dim as skills on skills.skill_id = top_skills.skill_id
order by skills_counted desc
limit 5;   

--assignment 2
select companies.company_id,
      companies.name as company_name,
       total_jobs_opening,
     case 
         when company_job_counts.total_jobs_opening < 10 then 'small'
         when company_job_counts.total_jobs_opening between 10 and 50 then 'medium'
         else 'large'
      end as size_category
from (
select company_id,
       count(*) as total_jobs_opening
from job_postings_fact
where job_title_short = 'Data Analyst'
group by company_id      
)
as company_job_counts
join company_dim as companies
on companies.company_id = company_job_counts.company_id
ORDER BY total_jobs_opening desc;
 