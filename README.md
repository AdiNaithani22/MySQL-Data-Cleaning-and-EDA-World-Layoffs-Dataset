# MySQL Data Cleaning and Exploratory Data Analysis: World Layoffs Dataset

## Project Overview

This project involves data cleaning and exploratory data analysis (EDA) of a global layoffs dataset from 2020 to 2023. The analysis uses MySQL to uncover insights into layoffs across different companies, industries, and regions.

### Key Objectives

- **Data Cleaning:** Transform raw data into a usable format by removing duplicates, handling null values, and standardizing entries.
- **Exploratory Data Analysis:** Analyze the cleaned data to uncover trends and insights.

## Project Details

### Data Cleaning Process

1. **Database Setup and Data Import:**
   - Created a MySQL database schema `World_layoffs` and imported the dataset.

2. **Data Preparation:**
   - Removed duplicate entries using partitioning techniques.
   - Standardized company names and industry labels.
   - Addressed missing data and updated date formats for accurate analysis.

### Exploratory Data Analysis (EDA)

1. **Basic Exploration:**
   - Calculated maximum layoffs and analyzed key companies with significant layoffs.

2. **Industry and Country Analysis:**
   - Evaluated which industries and countries experienced the most significant layoffs.

3. **Time Series Analysis:**
   - Analyzed layoffs by year and month, and implemented a rolling sum to track trends over time.

4. **Advanced Queries:**
   - Utilized CTEs and ranking functions to reveal insights across different dimensions.

### Key Insights

- Major tech companies, such as Amazon and Google, led significant layoffs.
- The United States and India reported the highest layoffs.
- Layoffs peaked in 2022, with 2023 showing an increasing trend based on partial data.

## Conclusion

This project showcases the power of MySQL in cleaning and analyzing real-world datasets. It highlights skills in data manipulation, analysis, and interpretation
