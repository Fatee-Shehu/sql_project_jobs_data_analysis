-- get jobs from january table
select 
     company_id,
     job_title_short,
     job_location
from janaury_jobs

union all

select 
     company_id,
     job_title_short,
     job_location
from february_job

union all
select 
      company_id,
      job_title_short,
      job_location
from march_job;


--practice problem 8
SELECT 
      quarter1_job_postings.job_title_short,
      quarter1_job_postings.job_via,
      quarter1_job_postings.job_location,
      quarter1_job_postings.job_posted_date:: date,
      quarter1_job_postings.salary_year_avg
FROM (
SELECT * 
from janaury_jobs
union ALL
select *
from february_job
UNION ALL
select *
FROM march_job
) as quarter1_job_postings
where quarter1_job_postings.salary_year_avg > 70000 and 
quarter1_job_postings.job_title_short ='Data Analyst'
ORDER BY quarter1_job_postings.salary_year_avg DESC

--assignment 2

-- job with skills
select quarter1_skill_types.job_id,
      quarter1_skill_types.job_title_short,
      quarter1_skill_types.job_posted_date::date,
      quarter1_skill_types.salary_year_avg,
      skills.skill_id,
      skills.skills as skills_name,
      skills.type as skills_type
from (
select*
from janaury_jobs

union all
select*
from february_job

union all
select *
from march_job
) as quarter1_skill_types
join skills_job_dim as skills_to_job
on quarter1_skill_types.job_id = skills_to_job.job_id
join skills_dim as skills
on skills_to_job.skill_id = skills.skill_id
