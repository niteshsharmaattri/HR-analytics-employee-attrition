
-- HR ANALYTICS - EMPLOYEE ATTRITION ANALYSIS
-- Database: hr_analytics
-- Author: Nitesh Sharma
-- Date:  February 2026


USE hr_analytics;


-- QUERY 1: Overall Attrition Rate
-- Business Question: What is the company's attrition rate?

SELECT 
    COUNT(*) as TotalEmployees,
    SUM(AttritionFlag) as EmployeesLeft,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) as AttritionRate_Percentage
FROM employee_data;
-- Result: 16.12% attrition rate



-- QUERY 2: Department-wise Attrition
-- Business Question: Which departments have highest attrition?

SELECT 
    Department,
    COUNT(*) as TotalEmployees,
    SUM(AttritionFlag) as EmployeesLeft,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) as AttritionRate
FROM employee_data
GROUP BY Department
ORDER BY AttritionRate DESC;
-- Key Finding: Sales (20.63%), HR (19.05%), R&D (13.84%)



-- QUERY 3: Age Group Analysis
-- Business Question: Which age groups are leaving most?

SELECT 
    AgeGroup,
    COUNT(*) as TotalEmployees,
    SUM(AttritionFlag) as EmployeesLeft,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) as AttritionRate
FROM employee_data
GROUP BY AgeGroup
ORDER BY AttritionRate DESC;
-- Key Finding: 18-25 age group has 35.77% attrition



-- QUERY 4: Salary Impact on Attrition
-- Business Question: Does low salary increase attrition?

SELECT 
    SalaryRange,
    COUNT(*) as TotalEmployees,
    SUM(AttritionFlag) as EmployeesLeft,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) as AttritionRate,
    ROUND(AVG(MonthlyIncome), 0) as AvgSalary
FROM employee_data
GROUP BY SalaryRange
ORDER BY 
    CASE 
        WHEN SalaryRange = 'Low' THEN 1
        WHEN SalaryRange = 'Medium' THEN 2
        WHEN SalaryRange = 'High' THEN 3
        ELSE 4
    END;
-- Key Finding: Low salary employees have 28.61% attrition



-- QUERY 5: Job Role-wise Attrition
-- Business Question: Which roles have highest turnover?

SELECT 
    JobRole,
    COUNT(*) as TotalEmployees,
    SUM(AttritionFlag) as EmployeesLeft,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) as AttritionRate
FROM employee_data
GROUP BY JobRole
ORDER BY AttritionRate DESC
LIMIT 10;
-- Key Finding: Sales Representatives (39.76%) highest attrition



-- QUERY 6: Work-Life Balance Impact
-- Business Question: Does poor work-life balance increase attrition?

SELECT 
    WorkLifeBalance,
    CASE 
        WHEN WorkLifeBalance = 1 THEN 'Bad'
        WHEN WorkLifeBalance = 2 THEN 'Average'
        WHEN WorkLifeBalance = 3 THEN 'Good'
        WHEN WorkLifeBalance = 4 THEN 'Excellent'
    END as BalanceLevel,
    COUNT(*) as TotalEmployees,
    SUM(AttritionFlag) as EmployeesLeft,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) as AttritionRate
FROM employee_data
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance;
-- Key Finding: Bad work-life balance = 31.25% attrition




-- QUERY 7: Tenure Analysis
-- Business Question: When do employees leave most?

SELECT 
    TenureCategory,
    COUNT(*) as TotalEmployees,
    SUM(AttritionFlag) as EmployeesLeft,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) as AttritionRate,
    ROUND(AVG(YearsAtCompany), 1) as AvgYears
FROM employee_data
GROUP BY TenureCategory
ORDER BY 
    CASE 
        WHEN TenureCategory = 'New (0-2 yrs)' THEN 1
        WHEN TenureCategory = 'Mid (3-5 yrs)' THEN 2
        WHEN TenureCategory = 'Senior (6-10 yrs)' THEN 3
        ELSE 4
    END;
-- Key Finding: 29.82% of new employees (0-2 yrs) leave




-- QUERY 8: Overtime Impact
-- Business Question: Does overtime increase attrition?

SELECT 
    OverTime,
    COUNT(*) as TotalEmployees,
    SUM(AttritionFlag) as EmployeesLeft,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) as AttritionRate
FROM employee_data
GROUP BY OverTime;
-- Key Finding: Overtime employees have 30.53% vs 10.44% attrition



-- QUERY 9: Job Satisfaction Impact
-- Business Question: Do unhappy employees leave more?

SELECT 
    JobSatisfaction,
    CASE 
        WHEN JobSatisfaction = 1 THEN 'Very Dissatisfied'
        WHEN JobSatisfaction = 2 THEN 'Dissatisfied'
        WHEN JobSatisfaction = 3 THEN 'Satisfied'
        WHEN JobSatisfaction = 4 THEN 'Very Satisfied'
    END as SatisfactionLevel,
    COUNT(*) as TotalEmployees,
    SUM(AttritionFlag) as EmployeesLeft,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) as AttritionRate
FROM employee_data
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;
-- Key Finding: Very dissatisfied = 22.84% vs very satisfied = 11.33%



-- QUERY 10: HIGH-RISK EMPLOYEE SEGMENTS
-- Business Question: Which employee combinations have highest risk?

SELECT 
    'Low Salary + Overtime + Young Age' as RiskSegment,
    COUNT(*) as TotalInSegment,
    SUM(AttritionFlag) as EmployeesLeft,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) as AttritionRate
FROM employee_data
WHERE SalaryRange = 'Low' 
    AND OverTime = 'Yes' 
    AND AgeGroup IN ('18-25', '26-35')

UNION ALL

SELECT 
    'Sales + Bad Work-Life Balance' as RiskSegment,
    COUNT(*) as TotalInSegment,
    SUM(AttritionFlag) as EmployeesLeft,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) as AttritionRate
FROM employee_data
WHERE Department = 'Sales' 
    AND WorkLifeBalance IN (1, 2)

UNION ALL

SELECT 
    'New Employees (0-2 yrs) + Low Satisfaction' as RiskSegment,
    COUNT(*) as TotalInSegment,
    SUM(AttritionFlag) as EmployeesLeft,
    ROUND(SUM(AttritionFlag) * 100.0 / COUNT(*), 2) as AttritionRate
FROM employee_data
WHERE TenureCategory = 'New (0-2 yrs)' 
    AND JobSatisfaction IN (1, 2)

ORDER BY AttritionRate DESC;
-- CRITICAL FINDING: Low Salary + Overtime + Young = 63.75% attrition!



-- END OF ANALYSIS
