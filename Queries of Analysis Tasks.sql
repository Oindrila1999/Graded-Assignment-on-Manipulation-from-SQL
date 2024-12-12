-- 1. Employee Productivity Analysis:
-- - Identify employees with the highest total hours worked and least absenteeism.
SELECT EMPLOYEEID,EMPLOYEENAME,SUM(TOTAL_HOURS)+SUM(OVERTIME_HOURS) TOTAL_WORKED_HOURS,SUM(DAYS_ABSENT) AS ABSENTEEISM
FROM ATTENDANCE_RECORDS
GROUP BY EMPLOYEEID,EMPLOYEENAME
ORDER BY TOTAL_WORKED_HOURS DESC,ABSENTEEISM ASC;

-- 2. Departmental Training Impact:
-- - Analyze how training programs improve departmental performance.
SELECT E.DEPARTMENT_ID,
AVG(CASE 
		WHEN E.PERFORMANCE_SCORE = 'Excellent' THEN 5
        WHEN E.PERFORMANCE_SCORE = 'Good' THEN 4
        WHEN E.PERFORMANCE_SCORE = 'Average' THEN 3
		ELSE NULL
	END) AS AVG_PERFORMANCE,
AVG(T.FEEDBACK_SCORE) AVG_FEEDBACK
FROM training_programs T
JOIN employee_details E
ON T.EMPLOYEEID = E.EMPLOYEEID
GROUP BY E.DEPARTMENT_ID;

-- 3. Project Budget Efficiency:
-- - Evaluate the efficiency of project budgets by calculating costs per hour worked.
SELECT PROJECT_ID,PROJECT_NAME,BUDGET/SUM(HOURS_WORKED) AS EFFICIENCY
FROM PROJECT_ASSIGNMENTS
GROUP BY PROJECT_ID,PROJECT_NAME
ORDER BY EFFICIENCY DESC;

-- 4. Attendance Consistency:
-- - Measure attendance trends and identify departments with significant deviations.
SELECT E.DEPARTMENT_ID,E.EMPLOYEENAME,A.TOTAL_HOURS TOTAL_HOURS,AVG(A.TOTAL_HOURS) OVER(PARTITION BY E.DEPARTMENT_ID) AS AVG_HOURS,
TOTAL_HOURS-AVG(A.TOTAL_HOURS) OVER(PARTITION BY E.DEPARTMENT_ID) AS DEVIATION
FROM employee_details E
JOIN attendance_records A
ON E.employeeid = A.employeeid;

-- 5. Department-Wise Training Impact
-- Evaluate the impact of training programs on departmental performance by correlating training feedback scores with project milestones.
SELECT E.DEPARTMENT_ID,AVG(T.FEEDBACK_SCORE) AVG_FEEDBACK,AVG(P.milestones_achieved) AVG_MILESTONE,COUNT(P.project_id) NO_OF_PROJECTS
FROM employee_details E
JOIN training_programs T
ON E.employeeid = T.employeeid
JOIN project_assignments P
ON E.employeeid = P.employeeid
GROUP BY E.DEPARTMENT_ID
ORDER BY AVG_FEEDBACK DESC,AVG_MILESTONE DESC;

-- 6. Training and Project Success Correlation:
-- - Link training technologies with project milestones to assess the real-world impact of training.
SELECT E.DEPARTMENT_ID,T.technologies_covered,AVG(T.FEEDBACK_SCORE) FEEDBACKS,SUM(P.milestones_achieved) MILESTONE,SUM(P.BUDGET) BUDGET
FROM employee_details E
JOIN training_programs T
ON E.employeeid = T.employeeid
JOIN project_assignments P
ON E.employeeid = P.employeeid
GROUP BY T.technologies_covered,E.department_id
ORDER BY MILESTONE DESC;

-- 7. High-Impact Employees:
-- - Identify employees who significantly contribute to high-budget projects while maintaining excellent performance scores.
SELECT E.EMPLOYEEID, E.EMPLOYEENAME, P.PROJECT_ID, P.PROJECT_NAME, P.BUDGET, E.PERFORMANCE_SCORE
FROM employee_details E
JOIN project_assignments P
ON E.employeeid = P.employeeid
WHERE E.performance_score = 'Excellent' 
and P.budget > (SELECT AVG(budget) FROM project_assignments)
ORDER BY P.BUDGET;
