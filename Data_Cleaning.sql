-- Data Cleaning

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data (If there are some issues with spellings we want to standardize it)
-- 3. NUll Values or blank values
-- 4. Remove Any Columns


-- 1. Removing Duplicates
-- We Don't want to edit the raw data at first so we created a staging data base
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;


INSERT  layoffs_staging
SELECT *
FROM  layoffs
;


SELECT *
FROM layoffs_staging; -- Staging data base has been created now we will check for the duplicates

SELECT COUNT(*)
FROM layoffs_staging;

WITH duplicate_CTE AS
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY
company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
) 						-- We created a CTE to check for duplicate values
SELECT *
FROM duplicate_CTE
WHERE row_num > 1; -- Now we would like to delete these Duplicates So Create a new table with a new column row_num because we cannot just delete from CTE

CREATE TABLE `layoffs_staging2` (`company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
ADD row_num INT; 				-- Added the new colummn row_num which will be used to check which are duplicates

INSERT INTO layoffs_staging2
SELECT * ,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;          -- Inserted the values with row_num column into the table 

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;				-- Now preparing which values need to go

DELETE
FROM layoffs_staging2
WHERE row_num > 1;				-- Deleting the duplicates


SELECT *
FROM layoffs_staging2;


-- 2. Standardizing Data 

SELECT company
FROM layoffs_staging2; 				-- Here we have unwanted spaces in company names we wanna get rid of them

SELECT company, TRIM(company)
FROM layoffs_staging2;				-- Trimmed the unwanted spaces now need to update the company column to this Trim company column

UPDATE layoffs_staging2
SET company = TRIM(company);		-- This updated the column for company and removed the spaces

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;     					-- Now we found that there are rows like Crypto, CryptoCurrency which are essentially the same so their name must be same too

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Till Now we have looked at company and industry now look at location

SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)		-- This just removes the '.' or period from the country name
WHERE country LIKE 'United States%';

-- If we want to do Exploratory Data Analyis, Time Series we would like to change the date from text tyoe to date column

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')						-- STR_TO_DATE is converting the date to the standard date format (The format must be same)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');		-- But still if you go to the Navigator and check for date its text only

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;							-- Now this has changed it to the date column the above query made it the correct format




-- 3. NULL values or Blank values



SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL ;					-- You should not use = NULL it is not valid IS NULL is valid We will look at these later

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 				-- Here we checking whether the idustry column is NUll or Blank
OR industry = '';					-- After executing this we found that company Airbnb and some others are blank, Now we try to populate it with data

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';			-- As we can see from other rows that Industry for Airbnb is Travel so we should be able to populate it 

SELECT t1.industry, t2.industry		-- Here we are using Self Join to populate the fields joining on the basis of company and searching for industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- Ok SO What happens is that sometimes update won't work because of blanks so you got to convert them to NULLS first

UPDATE layoffs_staging2
SET industry = null
WHERE industry = '';

SELECT t1.industry, t2.industry		
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL )
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL )
AND t2.industry IS NOT NULL;

-- looking at those laid off columns now

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL ;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL ;		-- We deleted the data it is risky but that data was not meaningful anyway

ALTER TABLE layoffs_staging2			-- Dropped the Useless Column that was used to detect the duplicates
DROP COLUMN row_num;

SELECT * 
FROM layoffs_staging2; 					-- Now our Cleaned Data is ready  !!


