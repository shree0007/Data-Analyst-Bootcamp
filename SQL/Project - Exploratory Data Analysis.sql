-- Exploratey Data Analysis (EDA) :  an analysis approach that identifies general patterns in the data
-- These patterns include outliers and features of the data that might be unexpected.
-- EDA is an important first step in any data analysis.
-- Sometimes Data Cleaning and EDA can be carried out together

SELECT *
FROM layoffs_staging2;

-- # BASIC EXPLORATION:

-- checking the max and min number of layoffs
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- checking the data where the layoff was 100%
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- checking which company had the largest lay offs
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- checking the date range from when layoffs started and ended
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- checking which industry had the largest lay offs
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- checking which country had the largest lay offs
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT *
FROM layoffs_staging2;

-- checking largest lay offs by date in year-only
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- checking largest lay offs by stage of the company
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- -- checking average percentage_laid_off by company
SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- # LOOKING AT THE PROGESSION OF LAYOFFS,
-- OR lets call it as a rolling sum: start at the very earliest layoffs and do a rolling sum until the very end of the layoffs

-- checking total laid-off by the year and month in ascending order
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

## ROLLING_NUMBER USE CASE:

-- First creating CTE using above query:
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
-- Using CTE to calculate rolling total
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;


-- ## RANK USE CASE:

-- checking which company had the largest lay offs
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- checking largest lay offs by company and date-year
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Creating CTE(Company_Year) using above query and adding one new CTE(Company_Year_Rank) from first CTE(Company_Year)for Calculating the rank based on total_laid_off descending order and partition by years
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(
SELECT *,
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
-- Calculating the rank based on total_laid_off descending order and partition by years where the rank is less and equal to 5
-- Below basically we filter the rank that is less and equal to 5
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;

