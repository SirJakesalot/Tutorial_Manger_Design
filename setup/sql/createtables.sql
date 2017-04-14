DROP DATABASE IF EXISTS pageDB;
CREATE DATABASE pageDB;
USE pageDB;

DROP TABLE IF EXISTS settings;
CREATE TABLE IF NOT EXISTS settings (
    site_label VARCHAR(50) NOT NULL,
    main_page_content TEXT default NULL,
    head_snippet TEXT default NULL,
    foot_snippet TEXT default NULL
) ENGINE=InnoDB;

DROP TABLE IF EXISTS categories;
CREATE TABLE IF NOT EXISTS categories (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    parent_id INTEGER,
    name VARCHAR(50) NOT NULL,
    label VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

DROP TABLE IF EXISTS pages;
CREATE TABLE IF NOT EXISTS pages (
    id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    label VARCHAR(100) NOT NULL,
    content TEXT default NULL
) ENGINE=InnoDB;

DROP TABLE IF EXISTS page_categories; CREATE TABLE IF NOT EXISTS page_categories ( page_id INTEGER NOT NULL, category_id INTEGER NOT NULL, PRIMARY KEY (page_id, category_id),
    KEY pkey (page_id),
    FOREIGN KEY(page_id) REFERENCES pages(id) ON DELETE CASCADE,
    FOREIGN KEY(category_id) REFERENCES categories(id) ON DELETE CASCADE
) ENGINE=InnoDB;

DROP USER IF EXISTS 'pageDB_admin'@'localhost';
CREATE USER 'pageDB_admin'@'localhost' IDENTIFIED BY 'm@n@g3r';
GRANT ALL ON pageDB.* TO 'pageDB_admin'@'localhost';

DROP USER IF EXISTS 'pageDB_user'@'localhost';
CREATE USER 'pageDB_user'@'localhost';
GRANT SELECT ON pageDB.* TO 'pageDB_user'@'localhost';

source populate.sql;
source procedures.sql;
