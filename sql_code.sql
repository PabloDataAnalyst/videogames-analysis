/* ----------------------------------------------------------
 🎮 VIDEO GAME SALES ANALYSIS (1971–2020)
 Author: Pablo
 Purpose: Identify real duplicates, analyze total sales by
 genre and by company/platform.
----------------------------------------------------------- */

/* ----------------------------------------------------------
 STEP 1 — Detect real duplicates in the dataset
----------------------------------------------------------- */
SELECT 
    title, 
    console, 
    COUNT(*) AS duplicate_count
FROM vg
GROUP BY 
    title, 
    console
HAVING COUNT(*) > 1;


/* ----------------------------------------------------------
 STEP 2 — Inspect duplicate records in detail
   (To understand whether they represent true duplicates
    or valid entries for different platforms or images)
----------------------------------------------------------- */
SELECT *
FROM vg
WHERE (title, console) IN (
    SELECT 
        title, 
        console
    FROM vg
    GROUP BY 
        title, 
        console
    HAVING COUNT(*) > 1
)
ORDER BY 
    title, 
    console;


/* ----------------------------------------------------------
 NOTE:
 After inspection, duplicates correspond to the same game 
 with different cover images or releases on multiple platforms.
 
 Since identical entries have NULL in sales values, 
 we keep them (no deletion needed) and focus on 
 aggregating sales by genre.
----------------------------------------------------------- */


/* ----------------------------------------------------------
 STEP 3 — Total sales by video game genre
----------------------------------------------------------- */
SELECT 
    genre, 
    SUM(total_sales) AS total_sales_million
FROM vg
GROUP BY genre
ORDER BY total_sales_million DESC;
/* → Identifies top-selling video game genres historically. */


/* ----------------------------------------------------------
 STEP 4 — Total sales by genre and company/platform
   (Grouped by main company family)
----------------------------------------------------------- */
SELECT
    genre,
    CASE
        WHEN console ILIKE '%PlayStation%' THEN 'PlayStation'
        WHEN console ILIKE '%PS%' THEN 'PlayStation'
        WHEN console ILIKE '%X%' THEN 'Xbox'
        WHEN console ILIKE '%Series%' THEN 'Xbox'
        WHEN console ILIKE '%N%' THEN 'Nintendo'
        WHEN console ILIKE '%Wii%' THEN 'Nintendo'
        WHEN console ILIKE '%NS%' THEN 'Nintendo'
        WHEN console ILIKE '%DS%' THEN 'Nintendo'
        WHEN console ILIKE '%PC%' THEN 'PC'
        WHEN console ILIKE '%macOS%' THEN 'PC'
        WHEN console ILIKE '%iOS%' THEN 'Mobile'
        WHEN console ILIKE '%Android%' THEN 'Mobile'
        ELSE 'Other'
    END AS company,
    SUM(total_sales) AS total_sales_million
FROM vg
WHERE total_sales IS NOT NULL
GROUP BY 
    genre, 
    company
ORDER BY 
    total_sales_million DESC;
/* → Reveals which companies dominate sales per genre. */

