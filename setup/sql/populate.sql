DROP TABLE IF EXISTS settings;
CREATE TABLE IF NOT EXISTS settings (
    site_label VARCHAR(50) NOT NULL,
    main_page_content TEXT default NULL,
    head_snippet TEXT default NULL,
    foot_snippet TEXT default NULL
) ENGINE=InnoDB;

INSERT INTO settings
VALUES('Jake\' Page Tutorials', '<p>This is the main page!</p>', '<style></style>', '<p>footer</p>');

INSERT INTO categories
VALUES(1, NULL, 'tutorials', 'Tutorials'),
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

INSERT INTO pages(name,label,content)
VALUES('quicksort', 'Quicksort', 'Quicksort Page'),
      ('mergesort', 'Mergesort', 'Mergesort Page'),
      ('fibonacci sequence', 'Fibonacci Sequence', 'Fib Page'),
      ('prime numbers', 'Prime Numbers', 'Prime Numbers Page'),
      ('palindromes', 'Palindromes', 'Palindromes Page'),
      ('jpeg compression', 'JPEG Compression', 'JPEG Compression Page');

INSERT INTO page_categories
VALUES(1, 4),
      (2, 4),
      (3, 5),
      (4, 5),
      (5, 6),
      (6, 18);
