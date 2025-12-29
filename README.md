## INTRODUCTION
This project dives into the data job market, focusing specifically on Data Analyst roles.
The goal is to uncover insights about:

- The top-paying Data Analyst jobs 🏆

- The skills required for top-paying roles 

- The most in-demand skills in the industry 💼

- Top Skills Associated with High Salaries

- Finally, the optimal skills — where high demand meets high salary ⚡

Through this analysis, I gained a deeper understanding of what employers value most and which skills can help data professionals stand out in a competitive market.
SQL Queries? check them out here: [project_sql folder](/project_sql/)
## BACKGROUND
The demand for Data Analysts continues to grow across industries, with companies seeking professionals who can turn raw data into actionable insights. However, navigating the data job market can be challenging — especially when trying to identify which skills, tools, and roles lead to better opportunities and higher pay.

This project explores these questions using data from Luke Barousse’s SQL for Data Analytics course. The dataset contains detailed information about job postings for data-related roles, including job titles, salaries, locations, and required skills.

Using SQL, I answered key questions such as:

-What are the top-paying jobs for Data Analysts?

-What are the top skills required for top-paying roles?

-Which skills are most in demand for Data Analysts?

-What skills are associated with high salaries?

-What are the optimal skills to learn 

## TOOLS I USED 
To complete this project, I used a combination of SQL tools, databases, and version control platforms to clean, query, and analyze the dataset:

*PostgreSQL* – for writing and executing SQL queries.  
*SQL* – the core tool for data extraction, transformation, and analysis.  
*Git & GitHub* – for version control and project sharing.  
*VS Code* – as the primary code editor for writing and managing SQL scripts  
These tools provided hands-on experience with database querying, data analysis, and collaborative project management.

## THE ANALYSIS
Each SQL query in this project was designed to investigate key aspects of the Data Analyst job market. Below is a breakdown of how each question was approached.

# 1.  Top paying Data Analyst roles
 To identify the highest-paying opportunities for Data Analysts, I filtered job postings based on average yearly salary and locations focusing on remote jobs, highllighting roles that offers high pay and flexibility.
```sql
 select job_id,
       job_title,
       job_location,
       job_schedule_type,
       job_posted_date,
       salary_year_avg,
       company_dim.company_id,
       name as company_name
from job_postings_fact
left JOIN company_dim on job_postings_fact.company_id = company_dim.company_id
WHERE
      job_title_short = 'Data Analyst' AND
      job_location = 'Anywhere' AND
      salary_year_avg is NOT NULL
order by salary_year_avg desc
limit 10;
```
### breakdown
The dataset includes a mix of mid-level and senior roles such as Data Analyst, Marketing Data Analyst, Hybrid/Remote Data Analyst, Director of Analytics, and Associate Director of Data Insights. Salaries show a wide range, stretching from about ₦217,000 to as high as ₦650,000 per year, depending on the role level and company. Top-paying companies in the list include Mantys, Meta, AT&T, Pinterest, and UCLA Healthcare Careers.

![Top paying roles](assets\top_pj_1.png)

*bar graph visualizing the salary of the top ten salaries of Data Analysts. Graph was generated using chatgpt by uploading the SQL query results*

## 2. Skills for top paying jobs
To do this, i joined job posting with the skills data, providing an insights into what employers value for high compensation
```sql
with top_paying_jobs as (
      select job_id,
            job_title,
            salary_year_avg,
            company_dim.company_id,
            name as company_name
      from job_postings_fact
      left JOIN company_dim on job_postings_fact.company_id = company_dim.company_id
      WHERE
            job_title_short = 'Data Analyst' AND
            job_location = 'Anywhere' AND
            salary_year_avg is NOT NULL
      order by salary_year_avg desc
      limit 10
      )
      SELECT 
            top_paying_jobs.*,
            skills
      from top_paying_jobs
      INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
      inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id;
```
Breakdown
| Rank  | Skill       | Count | Why It Matters                                       |
| ----- | ----------- | ----- | ---------------------------------------------------- |
| **1** | **SQL**     | 7     | Universal requirement for querying and managing data |
| **2** | **Python**  | 6     | Analytics, automation, modeling, data pipelines      |
| **3** | **Tableau** | 4     | High-end data visualization tool for dashboards      |
| **4** | **R**       | 3     | Statistical modeling, experimentation, analytics     |
| **5** | **Excel**   | 2     | Fundamental analysis, reporting, modeling            |


*Table visualizing top salaries of the top five skills of Data Analysts. Table was generated using chatgpt by uploading the SQL query results*

# 3. In_demand skills for Data Analyst
This query  helped identify skills most frequently request in job posting directing focusing on areas with high demand
```Sql
select 
       skills,
       count(skills_job_dim.job_id) as demand_count
 from job_postings_fact
      INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
      inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where job_title_short = 'Data Analyst' and 
      job_work_from_home = 'true'
group by skills
order by demand_count desc      
limit 5;
```
### Breakdown

Summary of Why These Skills Dominate

**SQL** → Foundation for all data retrieval

**Excel** → Universal business analysis tool

**Python** → Automation + ML + advanced analytics

**Tableau / Power BI** → Visualization & business intelligence

| Skill        | Demand Count |
| ------------ | ------------ |
| **SQL**      | 7,291        |
| **Excel**    | 4,611        |
| **Python**   | 4,330        |
| **Tableau**  | 3,745        |
| **Power BI** | 2,609        |

# 4. Skills based on Salaries
This query explores the average salaries associated with different skills, revealed which skills are the highest paying 
```sql
select 
       skills,
       round (avg(salary_year_avg), 0) as avg_salary
 from job_postings_fact
      INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
      inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where job_title_short = 'Data Analyst' 
      and job_work_from_home = 'true'
      and salary_year_avg is not null
group by skills
order by avg_salary desc    
limit 25;
```
### Breakdown 
Salary Analysis Breakdown
The data shows a clear hierarchy in compensation, which can be categorized into three main tiers:

1. **Top Tier (Above $160k)** The highest-paying skills are specialized data processing and niche enterprise tools.

**Leader**: PySpark is the significant outlier, commanding the highest salary at $208,172.

**Runners-up:** Bitbucket ($189k), Couchbase, and IBM Watson (both at ~$160k).

2. **High-Mid Tier ($140k - $160k)** This tier is dominated by Data Science tools, DevOps, and modern backend languages.

**Data Science:** Pandas, Jupyter, and NumPy all sit comfortably in this bracket, averaging around $150k.

**DevOps/Infra:** GitLab ($154k) and Databricks ($142k).

**Languages:** Swift and Golang are strong performers here.

3.**Standard Tier ($121k - $140k)** The baseline for these technical skills remains very high (over $120k). This group includes widely used infrastructure tools and core backend technologies.

**Infrastructure:** Linux, Kubernetes, Jenkins, and GCP.

**Data Engineering:** Airflow, PostgreSQL, and Scala.

![skills based on salary](assets\4_skills_based_on_salaries.png)
*Bar chart was used to visualize skills based on average salary.ChatGPT was used  to generate the graph* 

# 5. Optimal skills
 This query target skills that give job security(high demand skills) and finacial benefits (high salaries)
```sql
 select skills_dim.skill_id,
        skills_dim.skills,
        count(skills_job_dim.job_id) as demand_count,
        round (avg(salary_year_avg), 0) as avg_salary
 from job_postings_fact
      INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
      inner join skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where job_title_short = 'Data Analyst' 
      and job_work_from_home = 'true'
      and salary_year_avg is not null
group by skills_dim.skill_id
having count(skills_job_dim.job_id) > 10
order  by
        avg_salary desc,
        demand_count desc
limit 25;   
```     
#Breakdown
| Skill          | Demand | Salary   | Reason                              |
| -------------- | ------ | -------- | ----------------------------------- |
| **Python**     | 236    | $101,397 | Universal data language             |
| **Tableau**    | 230    | $99,288  | Core BI tool across industries      |
| **R**          | 148    | $100,499 | Statistics & analytics heavy fields |
| **SAS**        | 63     | $98,902  | Finance & healthcare powerhouse     |
| **Looker**     | 49     | $103,795 | Modern BI stack                     |
| **Snowflake**  | 37     | $112,948 | Cloud data engineering premium      |
| **Azure**      | 34     | $111,225 | Cloud computing demand surge        |
| **AWS**        | 32     | $108,317 | Industry leading cloud platform     |
| **Oracle**     | 37     | $104,534 | Enterprise databases                |
| **SQL Server** | 35     | $97,786  | Common backend tech                 |

*Table was generated using Chat GPT highlighting where high demand skills meet high salaries, hence optimal skills.*
## WHAT I LEARNED
Throughout this journey, I significantly strengthened my SQL skills by working through real-world puzzle problems and transforming raw tables into meaningful, insightful queries.

I learned how to effectively summarize data using functions like COUNT() and AVG(), and how to combine information across multiple tables using different types of joins. I also gained confidence using WITH clauses for cleaner query structure and CASE expressions for conditional logic

## CONCLUSIONS
# Insights

High-paying data roles require specialized technical depth.
The top salary ranges are dominated by roles that demand advanced engineering or architecture skills—such as Data Engineers, Machine Learning Engineers, and Analytics Architects. These roles typically involve managing complex systems, large datasets, and high-value business infrastructure.

Certain technical skills consistently command higher salaries.
Tools like PySpark, Bitbucket, Couchbase, Databricks, Kubernetes, and Linux were among the highest-paying skills. These are heavily tied to big data processing, distributed systems, cloud environments, and production-level data workflows—areas where expertise is scarce but extremely valuable.

Demand and salary don’t always align.
Many of the highest-paying skills are not the most widely demanded. For example, PySpark and Bitbucket pay very well but appear less frequently in job listings. On the other hand, SQL, Excel, Python, Tableau, and Power BI appear thousands of times—showing that foundational analytics skills drive high demand, even if the salaries vary.

The best “optimal skills” balance both demand and compensation.
Skills like Python, SQL, Tableau, AWS, Spark, and Hadoop offer the strongest intersection between frequency in job postings and competitive salaries. They create versatility across multiple data roles, from analysis to engineering.

Core analytics tools remain non-negotiable.
Despite the growth of specialized technologies, traditional tools—Excel, SQL Server, R, SAS, and Oracle—still maintain strong demand across industries. This confirms that foundational skills still anchor employability in data careers.

Visualization and BI tools are essential for data storytelling.
Tableau, Power BI, Looker, and Qlik appear prominently in demand rankings. This indicates that companies value not only data processing but also the ability to communicate insights effectively.

The market favors candidates who can work end-to-end.
High-value roles combine data engineering (e.g., Spark, Hadoop, cloud platforms) with analytical and visualization capabilities. This reinforces the importance of being able to manage data pipelines, analyze results, and present insights cohesively

## Concluding Thoughts

This analysis provided a comprehensive view of the data analytics landscape—from the top-paying roles to the skills driving both salary and demand. By examining salary-ranked skills, highly sought-after tools, and the optimal overlap between high demand and high compensation, I gained a clearer picture of what truly shapes employability and earning potential in data-focused careers
Overall, this journey not only highlighted which technical skills matter most in today’s data job market but also helped me build the analytical foundation needed to work with such information. Bridging salary trends, skill demand, and practical SQL experience has made the findings both relevant and personally impactful, reinforcing the path toward becoming a stronger, more strategic data professional.                                                                                                                                                                                                                                                                                                      