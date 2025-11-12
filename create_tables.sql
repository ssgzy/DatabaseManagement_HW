-- create database
CREATE DATABASE IF NOT EXISTS online_system 
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- use database
USE online_system 

-- 1.create table users
CREATE TABLE users (
    user_id VARCHAR(10) PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    registration_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_email (email),
    INDEX idx_user_name (user_name),
    INDEX idx_registration_date (registration_date),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户信息表';

-- 2.create table courses
CREATE TABLE courses (
    course_id VARCHAR(10) PRIMARY KEY,
    course_title VARCHAR(200) NOT NULL,
    instructor_id VARCHAR(10) NOT NULL,
    category VARCHAR(50),
    release_date DATE,
    price DECIMAL(10,2),
    description TEXT,
    INDEX idx_instructor_id (instructor_id),
    INDEX idx_category (category),
    INDEX idx_release_date (release_date),
    INDEX idx_price (price)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课程信息表';

-- 3.create table instructors
CREATE TABLE instructors (
    instructor_id VARCHAR(10) PRIMARY KEY,
    instructor_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    department VARCHAR(50),
    bio TEXT,
    UNIQUE KEY uk_email (email),
    INDEX idx_instructor_name (instructor_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='教师信息表';

-- 4.create table enrollment
CREATE TABLE enrollment (
    enrollment_id VARCHAR(20) PRIMARY KEY,
    user_id VARCHAR(10) NOT NULL,
    course_id VARCHAR(10) NOT NULL,
    enrollment_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('enrolled', 'in_progress', 'completed', 'dropped')),
    progress_percent INT CHECK (progress_percent >= 0 AND progress_percent <= 100),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    INDEX idx_enrollment_user (user_id),
    INDEX idx_enrollment_course (course_id),
    INDEX idx_enrollment_date (enrollment_date),
    INDEX idx_enrollment_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='选课信息表';

-- 5.create table course_content
CREATE TABLE course_content (
    content_id VARCHAR(20) PRIMARY KEY,
    course_id VARCHAR(10) NOT NULL,
    content_title VARCHAR(200) NOT NULL,
    duration_seconds INT NOT NULL CHECK (duration_seconds > 0),
    sequence INT NOT NULL CHECK (sequence > 0),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    INDEX idx_course_content_course_id (course_id),
    INDEX idx_course_content_sequence (sequence),
    INDEX idx_course_content_duration (duration_seconds),
    UNIQUE KEY uk_course_sequence (course_id, sequence)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课程内容表';

ALTER TABLE courses 
ADD CONSTRAINT fk_courses_instructor 
FOREIGN KEY (instructor_id) 
REFERENCES instructors(instructor_id);

