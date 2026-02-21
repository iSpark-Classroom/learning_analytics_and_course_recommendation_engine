# Smart Learning Analytics & Recommendation Engine
## Overview
You are joining a team building “EduLearn Africa”, an online learning platform similar to Udemy, but tailored for African learners. The platform hosts hundreds of courses across technology, entrepreneurship, agriculture, and creative skills, and aims to provide relevant courses to learners based on their interests and activity patterns.

The goal of this project is to design and implement a backend analytics and course recommendation engine using PostgreSQL. Your system will:

- Track and analyze user activity
- Recommend courses that align with users’ recent interests
- Produce engagement and retention analytics
- Handle edge cases and scale for realistic workloads

This is a group project. Teams will fork the repository, complete their solution, and submit via a Pull Request.

## Learning Objectives
By completing this project, you will:
- Design relational database schemas for a real-world platform
- Implement advanced SQL queries using joins, window functions, and CTEs
- Rank courses based on activity and relevance
- Produce analytics queries for dashboards
- Optimize queries and index large datasets
- Document your design decisions for future engineers
- Work collaboratively using GitHub workflows

## Project Requirements
### 1. Database Schema Design
Create the following tables with realistic relationships:
| Table            | Key Columns                                         |
| ---------------- | --------------------------------------------------- |
| `users`          | id, name, email, created_at                         |
| `courses`        | id, title, category, rating, is_active              |
| `categories`     | id, name                                            |
| `enrollments`    | user_id, course_id, enrolled_at                     |
| `activity_logs`  | id, user_id, course_id, activity_type, timestamp    |
| `course_reviews` | id, user_id, course_id, rating, comment, created_at |

**Requirements:**
- Primary and foreign keys
- Constraints (NOT NULL, CHECK, UNIQUE where appropriate)
- Indexes on frequently queried columns
- Include timestamps for tracking activity

**Note:**
The entities in the database design can be modified (edited, created, deleted) as needed. The above is only to serve as a guide and not the solution to the work required.

### 2. Core Features
**a) Personalized Course Recommendation Engine**
- Use recent activity (last 30 days), category interest frequency, course rating, and popularity to rank courses.
- Exclude courses the user is already enrolled in.
- Provide a SQL function that returns top N recommended courses for a user. For example:
```sql
CREATE FUNCTION recommend_courses(user_id INT)
RETURNS TABLE(course_id INT, title TEXT, category TEXT, score FLOAT)
```

**b) User Engagement Analytics**
Write SQL queries that calculate:
- Top 5 most active users
- Most popular categories in the last month
- 30-day user retention
- Courses with highest dropout rates

**Note:**
- The 30-day user retention metric measures the percentage of users who return to the platform and perform an activity within 30 days of their first activity. It tells us how well the platform keeps learners engaged after they first join or first interact. High retention indicates users are finding value and coming back to continue learning.
<img width="1201" height="245" alt="image" src="https://github.com/user-attachments/assets/7e49cc2d-8efe-46f6-be37-891db06b5196" />

**c) Dashboard Analytics**
Provide SQL queries for:
- Daily active users (DAU)
- Monthly active users (MAU)
- Course completion rates
- Growth trend by category (last 6 months)

**Requirements:** Use window functions, CTEs, aggregations, DATE_TRUNC, etc.

**d. Bonus Features (Optional but encouraged)**
You are required to do thorough research on this before implementing:
- Materialized views for analytics
- Partitioning large tables by date
- Triggers to auto-update engagement scores
- Stored procedures for batch analytics
- JSONB usage for flexible activity storage
- Full-text search on course titles

### 3. Edge Cases
Your solution must handle:
- New users (cold start problem) - show popular courses as fallback
- Users with no recent activity
- Sparse activity or missing data
- Duplicate enrollments
- Timezone-aware timestamps

### 4. Performance & Indexing
- Add indexes for `user_id`, `timestamp`, and `category` where needed
- Compare query performance before and after indexing
- Use `EXPLAIN ANALYZE` to document query cost improvements

## Submission Instructions
1. Fork the repository on the organization GitHub
2. Work in your group branch
3. Commit regularly and write meaningful messages
4. Submit your solution via a Pull Request to the original repository

## Deliverables
1. `README.md` with project overview, [Entity Relationship Diagram]ERD (link embedded or photos) , schema design notes, and overall approach and query documentation. Check the project `README` for a sample README template.
2. SQL files:
   - `schema.sql` - table definitions
   - `seed_data.sql` - sample data (~100 users, ~50 courses, ~1000 activity logs)
   - `recommendation_engine.sql` – ranking function
   - `analytics_queries.sql` – dashboard queries
   - `indexes.sql` – indexing and optimizations
   - `performance_tests.sql` – `EXPLAIN ANALYZE` results

## Evaluation Criteria
| Area                             | Weight |
| -------------------------------- | ------ |
| Schema Design                    | 20%    |
| SQL Complexity & Accuracy        | 25%    |
| Recommendation Logic             | 20%    |
| Analytics Queries                | 15%    |
| Indexing & Performance           | 10%    |
| Documentation, Organization, & GitHub Practices | 10%    |

## Future Improvements
Include these in your docs under a section titled `Future Enhancements/Improvements`
- Incorporate additional signals like quiz performance, forum activity, or course ratings
- Implement caching for faster recommendation queries
- Machine learning-based ranking for advanced personalization
- Multi-language support for Cameroon/Africa learners
