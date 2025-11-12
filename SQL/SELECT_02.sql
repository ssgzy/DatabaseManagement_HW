SELECT 
    u.user_id,
    u.user_name,
    u.registration_date,
    
    -- Learning activity metrics
    COUNT(DISTINCT e.course_id) AS enrolled_courses_count,
    COUNT(DISTINCT CASE WHEN e.status = 'completed' THEN e.course_id END) AS completed_courses_count,
    ROUND(AVG(e.progress_percent), 2) AS avg_progress,
    
    -- Course category preference
    (SELECT c.category 
     FROM courses c 
     JOIN enrollment e2 ON c.course_id = e2.course_id 
     WHERE e2.user_id = u.user_id 
     GROUP BY c.category 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS favorite_category,
    
    -- Recent learning activity
    MAX(e.enrollment_date) AS latest_enrollment
    
FROM users u
LEFT JOIN enrollment e ON u.user_id = e.user_id
LEFT JOIN courses c ON e.course_id = c.course_id
WHERE e.enrollment_date IS NOT NULL
GROUP BY u.user_id, u.user_name, u.registration_date
HAVING enrolled_courses_count >= 2
ORDER BY completed_courses_count DESC, avg_progress DESC;