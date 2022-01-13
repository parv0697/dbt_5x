SELECT * FROM "FIVETRAN_INTERVIEW_DB"."GOOGLE_SHEETS"."COVID_19_INDONESIA_PARV_AGARWAL";

SELECT distinct location, AVG(GROWTH_FACTOR_OF_NEW_DEATHS) FROM "FIVETRAN_INTERVIEW_DB"."GOOGLE_SHEETS"."COVID_19_INDONESIA_PARV_AGARWAL" group by location order by AVG(GROWTH_FACTOR_OF_NEW_DEATHS) desc;

SELECT *,Round(total_new_cases_recovered / total_new_cases * 100, 1) AS recovery_rate
FROM   (SELECT island,
               Avg(GROWTH_FACTOR_OF_NEW_CASES) as GROWTH_FACTOR_OF_NEW_CASES,
               Case when Avg(GROWTH_FACTOR_OF_NEW_CASES) > 1 Then 'Increasing Concern' else 'Can Control' END AS Condition,
               Sum(new_active_cases) AS total_new_active_cases,
               Sum(new_cases)        AS total_new_cases,
               Sum(new_deaths)       AS total_new_deaths,
               Sum(new_recovered)    AS total_new_cases_recovered
        FROM
       "FIVETRAN_INTERVIEW_DB"."GOOGLE_SHEETS"."COVID_19_INDONESIA_PARV_AGARWAL"
        WHERE  island != 'NULL' OR island IS NOT NULL
        GROUP  BY island);
				
SELECT location,
       Sum(new_active_cases) AS total_new_active_cases,
       Sum(new_cases)        AS total_new_cases,
	   Sum(new_deaths)       AS total_new_deaths,
       Sum(total_cases)      AS overall_cases,
       Sum(total_deaths)     AS total_deaths,
       Sum(new_recovered)    AS total_new_cases_recovered,
       Round(total_new_cases_recovered / total_new_cases * 100, 1)  AS overall_recovery_rate
FROM   "FIVETRAN_INTERVIEW_DB"."GOOGLE_SHEETS"."COVID_19_INDONESIA_PARV_AGARWAL"
GROUP  BY location order by overall_recovery_rate desc;

SELECT Concat('DATE: ',To_varchar(To_date(date, 'MM/DD/YYYY'),'YYYYMMDD')) as date_time,
               location,
               Round(AVG(GROWTH_FACTOR_OF_NEW_CASES),2) AS GROWTH_FACTOR_OF_NEW_CASES,
               Sum(DISTINCT total_districts) as number_of_districts,
               Sum(DISTINCT total_cities) as number_of_cities,
               Sum(new_active_cases) AS total_new_active_cases,
               Sum(new_cases)        AS total_new_cases,
               Sum(new_deaths)       AS total_new_deaths,
               Sum(new_recovered)    AS total_new_cases_recovered
        FROM
       "FIVETRAN_INTERVIEW_DB"."GOOGLE_SHEETS"."COVID_19_INDONESIA_PARV_AGARWAL"
        GROUP  BY 1,2;		
		
SELECT continent,country,location,coalesce(island,'Not Island') as island,coalesce(time_zone,'NA') as time_zone,
CASE
                 WHEN Lower(island) != 'null'
                       OR island IS NOT NULL THEN 'yes'
                 ELSE 'no'
               END                   AS is_island,
               Sum(DISTINCT total_districts) as number_of_districts,
               Sum(DISTINCT total_cities) as number_of_cities,
               Sum(new_active_cases) AS total_new_active_cases,
               Sum(new_cases)        AS total_new_cases,
               Sum(total_cases)      AS overall_cases,
               Sum(total_deaths)     AS total_deaths,
               Sum(new_deaths)       AS total_new_deaths,
               Sum(new_recovered)    AS total_new_cases_recovered,
               Sum(total_recovered)  AS overall_recovered
        FROM
       "FIVETRAN_INTERVIEW_DB"."GOOGLE_SHEETS"."COVID_19_INDONESIA_PARV_AGARWAL"
        GROUP  BY continent,country,location,island,time_zone ORDER  BY island ASC,overall_cases desc;