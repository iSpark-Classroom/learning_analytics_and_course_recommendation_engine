-- User table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ  DEFAULT NOW()
);

--Categories tables
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
`z`)

-- Courses table
CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    category_id INT NOT NULL,
    rating NUMERIC(3,2) DEFAULT 0 CHECK (rating BETWEEN 0 AND 5),
    total_reviews INT DEFAULT 0 CHECK (total_reviews >= 0),
    is_active BOOLEAN  DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

   
        FOREIGN KEY (category_id)
        REFERENCES categories(id)
     
);

-- Enrollment table
CREATE TABLE enrollments (
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolled_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ,

    PRIMARY KEY (user_id, course_id),

    
        FOREIGN KEY (user_id)
        REFERENCES users(id)
   

        FOREIGN KEY (course_id)
        REFERENCES courses(id)
      
);

-- Activity logs table 
CREATE TABLE activity_logs (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    activity_type VARCHAR(50) NOT NULL CHECK (
        

        FOREIGN KEY (user_id)
        REFERENCES users(id)
 
        FOREIGN KEY (course_id)
        REFERENCES courses(id)
        ON DELETE CASCADE
);


-- Course review table 
CREATE TABLE course_reviews (
    id SERIAL PRIMARY KEY,
    user_id INT,
    course_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES users(id),

    FOREIGN KEY (course_id)
        REFERENCES courses(id),

    UNIQUE (user_id, course_id)
	);


CREATE recommend_courses(p_user_id INT)
RETURNS TABLE(course_id INT, title TEXT, category TEXT, score FLOAT)
AS $$
BEGIN
    RETURN QUERY
    WITH recent_activity AS (
        SELECT c.category_id, COUNT(*) AS activity_count
        FROM activity_logs al
        INNER JOIN courses c ON al.course_id = c.id
        WHERE al.user_id = p_user_id
          AND al.timestamp >= NOW() - INTERVAL '30 days'
        GROUP BY c.category_id
    ),

    popular_courses AS (
        SELECT c.id,
               c.title,
               cat.name AS category,
               c.rating,
               COUNT(e.user_id) AS popularity
        FROM courses c
        JOIN categories cat ON c.category_id = cat.id
        LEFT JOIN enrollments e ON e.course_id = c.id
        GROUP BY c.id, cat.name
    )

    SELECT pc.id,
           pc.title,
           pc.category,
           (pc.rating * 0.6 + pc.popularity * 0.4) AS score
    FROM popular_courses pc
    JOIN recent_activity ra
        ON ra.category_id = (SELECT category_id FROM courses WHERE id = pc.id)
    WHERE pc.id NOT IN (
        SELECT course_id FROM enrollments WHERE user_id = p_user_id
    )
    ORDER BY score DESC
    LIMIT 5;
END;

