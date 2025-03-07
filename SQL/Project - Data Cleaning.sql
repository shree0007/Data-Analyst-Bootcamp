-- Data Cleaning : fixing issues in raw data to obtain more useable and useful format that can be used for instance for data visualization
-- 

SELECT *
FROM layoffs;

-- Data Cleaning Steps:
-- 1. Remove Duplicates : if there are any repetative unnecessary duplicates
-- 2. Standardize the Data: if there are any issues such as spelling, unnecessary spaces etc.
-- 3. Null Values or Blank values: check if you can populate those data based on the situation: should and should not 
-- 4. Remove Any Columns Or Rows: There are instances where you can and there are instances where you should not
     -- if you are working with massive data set and there is column that is completely irrelevant/blank then you can remove the column that can save time
     -- However in real work place, often time there are processes from which data is atuomatically imported from different data sources, if you remove the column from raw dataset , that is BIG problem  
     -- Therefore it is always good idea to make a copy of raw data set so that we can protect raw data set incase of any mistakes


-- 1. REMOVE DUPLICATES:

-- creating copy of raw table and giving name layoffs_staging so that the raw table will be preserved incase of mistakes
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- checking row number for the repetative data
SELECT *,
ROW_NUMBER() OVER (PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- creating cte that gives row number
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)

-- checking rows greater than 1. Greater than 1 row means data is definitely repeating
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- just checking manulaly if it is true that this data is repetative
SELECT *
FROM layoffs_staging
WHERE company = "Casper";

-- same cte that we created above
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)

-- trying to delete this way, but its not possible because row_num is not a permanent column in the table
DELETE
FROM duplicate_cte
WHERE row_num > 1;

-- thats why we create new table using layoffs_staging table where we add new row_num column to it. Below table is created by:
--  right click layoffs_staging table in GUI -> copy to clipboard -> create statement--> paste it here in the editor --> just add the row_num column with int data type
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
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

-- Inserting everything along with row_number into new table
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (PARTITION BY company,location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- Now deleting all the data that has row number greater than 1 coz they are repetative
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;


-- 2. STANDARDIZING DATA : finding issues and fixing it

-- Triming the company name, meaning removing unnecessary white spaces before or after the name
 SELECT company, TRIM(company)
 FROM layoffs_staging2;

-- updating the table by triming company name
UPDATE layoffs_staging2
SET company = TRIM(company);

-- checking errors in the industry names. Found that some industry type is used by multiple name for example Crypto and Crypto Currency
-- It is always important to make same label for  same specific industry because later during data visualization same things will be plotted in different rows as different data which we dont want
-- So we want to group them together in a single lable so that we can accurately look at the data
 SELECT DISTINCT industry
 FROM layoffs_staging2
 ORDER BY 1;
 
 -- Selecting all where industry is Crypto or Crypto + ... to see how many different crypto related words are there
 SELECT *
 FROM layoffs_staging2
 WHERE industry LIKE "Crypto%";

-- Now updating the industry column by changing Crypto Currency to Crypto
UPDATE layoffs_staging2
SET industry = "Crypto"
WHERE industry LIKE "Crypto%";

-- Checking, and there is only Crypto but no Crypto Currency
 SELECT DISTINCT industry
 FROM layoffs_staging2
 ORDER BY 1;

-- Now checking country : seems like United States is used in mutliple way: 'United States' and 'United States.'
SELECT DISTINCT country
 FROM layoffs_staging2
 ORDER BY 1;

-- checking country United States and United States + ..
SELECT *
FROM layoffs_staging2
WHERE country LIKE "United States%";
 
-- Triming and Trailing what comes after United States
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

-- Now update the correction of country name United States. to United States
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE "United States%";


-- changing the date formate
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

-- UPDATE the date column from string to date 
UPDATE layoffs_staging2
SET `date`= STR_TO_DATE(`date`, '%m/%d/%Y');

-- check if its working: its working the format is changed from example: 2/28/2023 to 2023-2-28
SELECT `date`
FROM layoffs_staging2;

-- Changing data type for 'date column' to date. It was previously 'text' data type
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE; 

SELECT *
FROM layoffs_staging2;



-- 3. WORKING WITH NULL AND BLANK VALUES: need to think whats we gona do if there is null or blank values:make them all null?,blanks?, or try to populate that data?  

-- In industry column
SELECT *
FROM layoffs_staging2
WHERE industry is NULL
OR industry = '';

-- First updating table by changing blank industry values to NULL so that its easier to work on for example in populating data as shown in below queries
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- checking if we can populate industry data based on company example Airbnb. Meaning, from below query we can look at company and see if the company's industry type is mentioned in some rows of same comany
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- Checking all at once to find out missing company's industry type with the help of given industry type of company with same name
SELECT t1.company, t1.industry, t2.company, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
  ON t1.company = t2.company
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;

-- Updating by populating the missing industry type
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;

-- NOTE: So now we have populated data of missing industry type. Thats all we can do about populating data
-- Because although we still have some NULL or Blank values in total_laid_off, percentatge_laid_off, funds_raised_million, there is no way or logic that supports populating data
-- For instance if we had orginal total before laid off then we could have calculated and populated the missing NULL or Blank fields in total_laid_off and percentatge_laid_off 


-- In total_laid_off column, looking for companies that has both 'total_laid_off' and 'percentage_laid_off' NULL
SELECT *
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off is NULL;

-- Since in the future we are looking for the lay off data of the companies and if we have companies that has both 'total_laid_off' and 'percentage_laid_off' NULL values
-- It means these companies are of no use for the analysis so we can delete these rows containing NULL values for both 'total_laid_off' and 'percentage_laid_off' columns
DELETE
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off IS NULL; 

SELECT *
FROM layoffs_staging2;


-- 4. REMOVE IRRELEVANT/UNNECESSARY COLUMN:
-- Since we donot need 'row_num' column that we made in the begining to check duplicates, we can remove it
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;







