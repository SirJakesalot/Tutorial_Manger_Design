DROP DATABASE IF EXISTS pageDB;
CREATE DATABASE pageDB;
USE pageDB;

DROP TABLE IF EXISTS categories;
CREATE TABLE IF NOT EXISTS categories (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    parent_id INTEGER,
    name VARCHAR(50) NOT NULL,
    label VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

INSERT INTO categories VALUES(1, NULL, 'tutorials', 'Tutorials'),
                             (2, 1, 'fundamentals', 'Programming Fundamentals'),
                             (3, 2, 'algorithms', 'Algorithms'),
                             (4, 3, 'sorting', 'Sorting Algorithms'),
                             (5, 3, 'computing', 'Computing Algorithms'),
                             (6, 2, 'data-structures', 'Data Structures'),
                             (7, 6, 'Tree Data Structures', 'trees'),
                             (8, 1, 'languages', 'Programming Languages'),
                             (9, 8, 'python3', 'Python3'),
                             (10, 9, 'list-comprehension', 'List Comprehensions'),
                             (11, 9, 'python-classes', 'Python Classes'),
                             (12, 8, 'java8', 'Java8'),
                             (13, 12, 'java-classes', 'Java Classes'),
                             (14, 1, 'web-frameworks', 'Web Frameworks'),
                             (15, 14, 'django', 'Django'),
                             (16, 15, 'django-templates', 'Django Templates'),
                             (17, 15, 'django-url-mapping', 'Django URL Mapping'),
                             (18, 14, 'tomcat7', 'Tomcat7'),
                             (19, 18, 'jsp', 'JSP'),
                             (20, 18, 'tomcat-url-mapping', 'Tomcat7 URL Mapping');

DROP TABLE IF EXISTS pages;
CREATE TABLE IF NOT EXISTS pages (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    label VARCHAR(100) NOT NULL,
    content TEXT default NULL
) ENGINE=InnoDB;

INSERT INTO pages(name,label) VALUES('quicksort', 'Quicksort'),
                                    ('mergesort', 'Mergesort'),
                                    ('fibonacci sequence', 'Fibonacci Sequence'),
                                    ('prime numbers', 'Prime Numbers'),
                                    ('palindromes', 'Palindromes'),
                                    ('jpeg compression', 'JPEG Compression');

DROP TABLE IF EXISTS page_categories; CREATE TABLE IF NOT EXISTS page_categories ( page_id INTEGER NOT NULL, category_id INTEGER NOT NULL, PRIMARY KEY (page_id, category_id),
    KEY pkey (page_id),
    FOREIGN KEY(page_id) REFERENCES pages(id) ON DELETE CASCADE,
    FOREIGN KEY(category_id) REFERENCES categories(id) ON DELETE CASCADE
) ENGINE=InnoDB;

INSERT INTO page_categories VALUES(1, 4),
                                  (2, 4),
                                  (3, 5),
                                  (4, 5),
                                  (5, 6),
                                  (6, 18);

DROP USER IF EXISTS 'pageDB_admin'@'localhost';
CREATE USER 'pageDB_admin'@'localhost' IDENTIFIED BY 'm@n@g3r';
GRANT ALL ON pageDB.* TO 'pageDB_admin'@'localhost';

DROP USER IF EXISTS 'pageDB_user'@'localhost';
CREATE USER 'pageDB_user'@'localhost';
GRANT SELECT ON pageDB.* TO 'pageDB_user'@'localhost';
