-- Exploratory Data Analysis

SELECT MAX(total_laid_off), MAX(percentage_laid_off) 			-- The 1 will signify 100% 
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)									-- To find off when the layoffs started
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)							-- The industries from where most layoffs were there
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country , SUM(total_laid_off)							-- The countries from where most layoffs were there
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC; 

SELECT `date` , SUM(total_laid_off)								-- The Dates on which most layoffs were there
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 1 DESC;  

SELECT YEAR(`date`) , SUM(total_laid_off)								-- The Year in which most layoffs were there
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;  

-- Now we will look at the progression of layoffs or the rolling sum 

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
;																		-- This gives us the data now we want to do the rolling sum

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`,total_off,  SUM(total_off) OVER(ORDER BY `MONTH`) AS Rolling_total 	-- Here we are sort of doing aggregation of an aggregation which can't be done wihtout CTE
FROM ROlling_Total;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
)
SELECT *, 
DENSE_RANK() OVER(partition by years ORDER BY total_laid_off DESC) AS Ranking -- Partition BY: Starts a new numbering whenever new year starts
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY Ranking ASC;

-- Now we want to filter on the ranking to filter out 5 companies per year and for that we would add another CTE 

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC
), Company_Year_Rank AS
(
SELECT *, 
DENSE_RANK() OVER(partition by years ORDER BY total_laid_off DESC) AS Ranking -- Partition BY: Starts a new numbering whenever new year starts
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <=5
;


