DROP DATABASE IF EXISTS tutorialdb;
CREATE DATABASE tutorialdb;
USE tutorialdb;

DROP TABLE IF EXISTS categories;
CREATE TABLE IF NOT EXISTS categories (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    parent_id INTEGER,
    name VARCHAR(30) NOT NULL
) ENGINE=InnoDB;

INSERT INTO categories VALUES(1, NULL, 'Tutorials'),
                             (2, 1, 'Programming Fundamentals'),
                             (3, 2, 'Algorithms'),
                             (4, 3, 'Sorting Algorithms'),
                             (5, 3, 'Computing Algorithms'),
                             (6, 3, 'Misc Algorithms'),
                             (7, 2, 'Data Structures'),
                             (8, 7, 'Basic Data Structures'),
                             (9, 7, 'Tree Data Structures'),
                             (10, 2, 'Interview Questions'),
                             (11, 10, 'Easy Questions'),
                             (12, 1, 'Programming Languages'),
                             (13, 12, 'Python'),
                             (14, 13, 'Basic Python'),
                             (15, 13, 'Python Libraries'),
                             (16, 12, 'Java'),
                             (17, 16, 'Basic Java'),
                             (18, 16, 'Java Libraries'),
                             (19, 1, 'Web Frameworks'),
                             (20, 19, 'Django'),
                             (21, 20, 'Basic Django'),
                             (22, 20, 'Django Libraries'),
                             (23, 19, 'Tomcat'),
                             (24, 23, 'Basic Tomcat'),
                             (25, 23, 'Tomcat Libraries');

DROP TABLE IF EXISTS tutorials;
CREATE TABLE IF NOT EXISTS tutorials (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    title VARCHAR(40) NOT NULL
) ENGINE=InnoDB;

INSERT INTO tutorials VALUES(1, 'quicksort'),
                            (2, 'mergesort'),
                            (3, 'fibonacci sequence'),
                            (4, 'prime numbers'),
                            (5, 'palindromes'),
                            (6, 'jpeg compression');

DROP TABLE IF EXISTS tutorial_categories;
CREATE TABLE IF NOT EXISTS tutorial_categories (
    tutorial_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    PRIMARY KEY (tutorial_id, category_id),
    KEY pkey (tutorial_id),
    FOREIGN KEY(tutorial_id) REFERENCES tutorials(id) ON DELETE CASCADE,
    FOREIGN KEY(category_id) REFERENCES categories(id) ON DELETE CASCADE
) ENGINE=InnoDB;

INSERT INTO tutorial_categories VALUES(1, 4),
                                      (2, 4),
                                      (3, 5),
                                      (4, 5),
                                      (5, 6),
                                      (6, 18);


DELIMITER //
DROP PROCEDURE IF EXISTS GetTop2Lvls;
CREATE PROCEDURE GetTop2Lvls ()
BEGIN
  SELECT t1.name as lev1, t2.name as lev2
  FROM categories as t1 LEFT JOIN categories as t2 ON t2.parent_id = t1.id
  WHERE t1.parent_id=1;
END; //

DROP PROCEDURE IF EXISTS GetBot2Lvls;
CREATE PROCEDURE GetBot2Lvls (IN cat INTEGER)
BEGIN
  SELECT t3.id AS tutorial_id, t3.title AS tutorial_title, t1.id AS category_id, t1.parent_id AS category_parent_id, t1.name AS category_name
  FROM categories AS t1
  LEFT JOIN tutorial_categories AS t2 ON t2.category_id = t1.id
  LEFT JOIN tutorials AS t3 ON t2.tutorial_id = t3.id
  WHERE t3.id IS NOT NULL AND t1.parent_id = cat;
END; //
