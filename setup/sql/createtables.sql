DROP DATABASE IF EXISTS tutorialdb;
CREATE DATABASE tutorialdb;
USE tutorialdb;

DROP TABLE IF EXISTS categories;
CREATE TABLE IF NOT EXISTS categories (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    parent_id INTEGER,
    name VARCHAR(30) NOT NULL,
    label VARCHAR(30) NOT NULL
) ENGINE=InnoDB;

INSERT INTO categories VALUES(1, NULL, 'toplvl', 'Top Level'),
                             (2, NULL, 'fundamentals', 'Programming Fundamentals'),
                             (3, 2, 'algorithms', 'Algorithms'),
                             (4, 3, 'sorting', 'Sorting Algorithms'),
                             (5, 3, 'computing', 'Computing Algorithms'),
                             (6, 3, 'misc', 'Misc Algorithms'),
                             (7, 2, 'data-structures', 'Data Structures'),
                             (8, 7, 'basic', 'Basic Data Structures'),
                             (9, 7, 'tree', 'Tree Data Structures'),
                             (10, 2, 'questions', 'Interview Questions'),
                             (11, 10, 'easy', 'Easy Questions'),
                             (12, NULL, 'languages', 'Programming Languages'),
                             (13, 12, 'python', 'Python'),
                             (14, 13, 'basic', 'Basic Python'),
                             (15, 13, 'libraries', 'Python Libraries'),
                             (16, 12, 'java', 'Java'),
                             (17, 16, 'basic', 'Basic Java'),
                             (18, 16, 'libraries','Java Libraries'),
                             (19, NULL, 'frameworks', 'Web Frameworks'),
                             (20, 19, 'django', 'Django'),
                             (21, 20, 'basic', 'Basic Django'),
                             (22, 20, 'libraries', 'Django Libraries'),
                             (23, 19, 'tomcat', 'Tomcat'),
                             (24, 23, 'basic', 'Basic Tomcat'),
                             (25, 23, 'libraries', 'Tomcat Libraries');

DROP TABLE IF EXISTS tutorials;
CREATE TABLE IF NOT EXISTS tutorials (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    label Varchar(40) NOT NULL
) ENGINE=InnoDB;

INSERT INTO tutorials VALUES(1, 'quicksort', 'Quicksort'),
                            (2, 'mergesort', 'Mergesort'),
                            (3, 'fibonacci-sequence', 'Fibonacci Sequence'),
                            (4, 'prime-numbers', 'Prime Numbers'),
                            (5, 'palindromes', 'Palindromes'),
                            (6, 'jpeg-compression', 'JPEG Compression');

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
  SELECT t1.name AS lev1, t2.name AS lev2
  FROM categories AS t1
  JOIN categories AS t2
  ON t2.parent_id = t1.id
  WHERE t1.parent_id IS NULL AND t2.name IS NOT NULL
  ORDER BY lev1, lev2;
END; //

DROP PROCEDURE IF EXISTS GetCatsFor1Lvl;
CREATE PROCEDURE GetCatsFor1Lvl (IN lvl1_cat VARCHAR(30))
BEGIN
  DECLARE lvl1_id INT DEFAULT NULL;

  SET lvl1_id = (SELECT id
                 FROM categories
                 WHERE parent_id IS NULL AND name = lvl1_cat);

  IF lvl1_id IS NOT NULL THEN
    SELECT *
    FROM categories
    WHERE parent_id = lvl1_id;
  END IF;
END; //

DROP PROCEDURE IF EXISTS GetCatsFor2Lvls;
CREATE PROCEDURE GetCatsFor2Lvls (IN lvl1_cat VARCHAR(30), IN lvl2_cat VARCHAR(30))
BEGIN
  DECLARE lvl2_id INT DEFAULT NULL;

  SET lvl2_id = (SELECT c2.id
                 FROM categories AS c1
                 JOIN categories AS c2 ON c1.id = c2.parent_id
                 WHERE c1.parent_id IS NULL AND c1.name = lvl1_cat AND c2.name = lvl2_cat);

  IF lvl2_id IS NOT NULL THEN
    SELECT *
    FROM categories
    WHERE parent_id = lvl2_id;
  END IF;
END; //

DROP PROCEDURE IF EXISTS GetTutsFor3Lvls;
CREATE PROCEDURE GetTutsFor3Lvls (IN lvl1_cat VARCHAR(30), IN lvl2_cat VARCHAR(30), IN lvl3_cat VARCHAR(30))
BEGIN
  DECLARE lvl3_id INT DEFAULT NULL;
  
  SET lvl3_id = (SELECT c3.id
                 FROM categories AS c1
                 JOIN categories AS c2 ON c1.id = c2.parent_id
                 JOIN categories AS c3 ON c2.id = c3.parent_id
                 WHERE c1.parent_id IS NULL AND c1.name = lvl1_cat AND c2.name = lvl2_cat AND c3.name = lvl3_cat);

  IF lvl3_id IS NOT NULL THEN
    SELECT t1.id, t1.name
    FROM tutorials AS t1
    JOIN tutorial_categories AS t2
    ON t1.id = t2.tutorial_id
    WHERE t2.category_id = lvl3_id;
  END IF;
END; //
