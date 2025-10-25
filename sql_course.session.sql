--create company_dim table with primary key
create table public.company_dim
(
    company_id int primary key,
    name text,
    link text,
    link_goggle text,
    thumbnail text
);
--create skills_dim table with primary key
create table public.skills_dim
(
    skill_id int primary key,
    skills text,
    type TEXT
);
--create job_postings_fact table with primary key
create table public.job_postings_fact
(
job_id int primary key,
company_id int,
job_title_short varchar(255),
job_title text,
job_location text,
job_via text,
job_schedule_type text,
job_work_from_home boolean,
search_location text,
job_posted_date timestamp,
job_no_degree_mention boolean,
job_health_insurance boolean,
job_country text,
salary_rate text,
salary_year_avg numeric,
salary_hour_avg numeric,
foreign key (company_id) references public.company_dim (company_id)
);

--create skills_job_dim table with a composite primary key and foreign key
create table skills_job_dim 
(
job_id int,
skill_id int,
primary key (job_id,skill_id),
foreign key (job_id) references public.job_postings_fact (job_id),
foreign key (skill_id) references public.skills_dim (skill_id)
);
--set ownership of the table to the postgres user
ALTER TABLE public.company_dim OWNER to postgres;
alter table public.skills_dim OWNER to postgres;
alter table public.job_postings_fact OWNER to postgres;
alter TABLE public.skills_job_dim OWNER to postgres;

--create indexes on foreign keys columns for better performance
create index idx_company_dim on public.job_postings_fact (company_id);
create index idx_skill_id on public.skills_job_dim (skill_id);
create index idx_job_id on public.skills_job_dim (job_id);

--test run
select * from job_postings_fact
limit 100;

select 
       job_title_short,
       job_location,
       job_posted_date::date as job_date
from job_postings_fact
limit 10;

select 
       job_title_short,
       job_location,
       job_posted_date at time zone 'utc' at time zone 'est'
from job_postings_fact
limit 10;

select 
       job_title_short,
       job_location,
       job_posted_date at time zone 'est' at time zone 'utc'
from job_postings_fact
limit 10;


select count (job_id) as count_job_posted,
      extract (month from job_posted_date) as month
from job_postings_fact
where job_title_short ='Data Analyst'
group by month
ORDER BY count_job_posted desc
limit 10;

