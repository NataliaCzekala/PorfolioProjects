SELECT *            -- Removing Duplicates
FROM layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *,
ROW_NUMBER() OVER(
partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
FROM layoffs_staging;

WITH duplicate_cte as
(SELECT *,
ROW_NUMBER() OVER(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)
 as row_num
FROM layoffs_staging
)
select * 
from duplicate_cte
where row_num > 1;

SELECT *
FROM layoffs_staging
where company = 'Casper';

WITH duplicate_cte as
(SELECT *,
ROW_NUMBER() OVER(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)
 as row_num
FROM layoffs_staging
)
delete 
from duplicate_cte
where row_num > 1;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2
where row_num > 1;
insert into layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions)
 as row_num
FROM layoffs_staging;

SET SQL_SAFE_UPDATES = 0;

DELETE
FROM layoffs_staging2
where row_num > 1;

SELECT *
FROM layoffs_staging2;

-- standardizing data
SELECT company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);

SELECT distinct industry
from layoffs_staging2;


update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

SELECT distinct country, trim(trailing'.' from country) -- to delete '.' from the name of the country
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing'.' from country)
where country like 'United States%';

SELECT `date`
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');



alter table layoffs_staging2          -- changing from text to date                    
modify column `date` date;

SELECT *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

update layoffs_staging2
set industry = null
where industry = '';


SELECT *
from layoffs_staging2
where industry is null
or industry = '';

SELECT *
from layoffs_staging2
where company like 'Bally%';

select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null;

SELECT *
from layoffs_staging2;

SELECT *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;             -- deleting the data with 'null', we do not need this information in this data analyst

delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;   

SELECT *
from layoffs_staging2;

alter table layoffs_staging2
drop column row_num;
