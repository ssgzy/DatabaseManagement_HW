SELECT 
    i.instructor_id,
    i.instructor_name,
    i.department,
    COUNT(DISTINCT c.course_id) AS total_courses,
    COUNT(DISTINCT e.user_id) AS total_students,
    ROUND(AVG(e.progress_percent), 2) AS avg_completion_rate,
    -- Use subquery to find each instructor's most popular course
    (SELECT c2.course_title 
     FROM courses c2 
     LEFT JOIN enrollment e2 ON c2.course_id = e2.course_id 
     WHERE c2.instructor_id = i.instructor_id 
     GROUP BY c2.course_id, c2.course_title 
     ORDER BY COUNT(e2.user_id) DESC 
     LIMIT 1) AS most_popular_course,
    -- Calculate the ratio of high completion rate courses (completion rate > 80%)
    ROUND(
        (SELECT COUNT(DISTINCT c3.course_id)
         FROM courses c3 
         LEFT JOIN enrollment e3 ON c3.course_id = e3.course_id 
         WHERE c3.instructor_id = i.instructor_id 
         AND e3.progress_percent > 80) * 100.0 / 
        NULLIF(COUNT(DISTINCT c.course_id), 0), 2
    ) AS high_completion_course_ratio
    
FROM instructors i
LEFT JOIN courses c ON i.instructor_id = c.instructor_id
LEFT JOIN enrollment e ON c.course_id = e.course_id
WHERE e.status IN ('in_progress', 'completed')
GROUP BY i.instructor_id, i.instructor_name, i.department
HAVING total_students > 0  -- Only count instructors with students
ORDER BY avg_completion_rate DESC, total_students DESC;