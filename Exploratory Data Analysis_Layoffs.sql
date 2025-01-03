-- Exploratory Data Analysis

select *
from layoffs_staging2;

select MAX(total_laid_off), MAX(percentage_laid_off)
from layoffs_staging2; 

select *
from layoffs_staging2
where percentage_laid_off = 1                       -- the companies that completly went under
order by funds_raised_millions desc;


select company,sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select MIN(`date`), MAX(`date`)
from layoffs_staging2;                   


select industry,sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;                          -- consumer industry got the highest number of laids off 

select country,sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;                        -- United States had the most sum of laid offs, dramatically bigger than other countries
                                        -- 256556 within 3 years

select *
from layoffs_staging2;

select year (`date`),sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;                        -- in 2022 the most people were laid off(160661), comparing to the only three first months of 2023 (125677) the number will be much higher than 2022


select stage,sum(total_laid_off)
from layoffs_staging2
group by stage
order by 1 desc;

select country,sum(percentage_laid_off)
from layoffs_staging2
group by country
order by 2 desc;                               -- we do not have hard numbers of how large these companies are so the percentage laid off is not really usefull information or relevant

select substring(`date`,1,7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc;                               -- progression of the laid offs during these 3 years

with rolling_total as
(select substring(`date`,1,7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)
select `month`, total_off
,sum(total_off) over (order by `month`) as rolling_total
from rolling_total;                         -- shows month to month progression of how many there were laid offs around the world during this time
											-- 2020(9628->80998) progression was worse than 2021(87811->96821), there were way less laid offs in 2021
                                            -- in 2022 number of total laid offs start increasing dramatically from 97331->257482, over 160 150 people
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select company, year(`date`), sum(total_laid_off)    -- to rank in which years companies laid off the most employees
from layoffs_staging2
group by company,year(`date`)
order by 3 desc; 

with company_year (company, years, total_laid_off) as
(select company, year(`date`), sum(total_laid_off)    -- to rank in which years and what companies laid off the most employees
from layoffs_staging2
group by company,year(`date`)
), company_year_rank as
(select *, 
dense_rank() over(partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null                                   -- in 2020 Uber, Booking.com, Groupon were at the forefront of the largest number of layoffs
)
select *
from company_year_rank
where ranking  <= 5;                                     -- ranking of 5 top companies who had the biggest number of laid offs by each year 
													     
    
    
    
    
    
    
    
    





