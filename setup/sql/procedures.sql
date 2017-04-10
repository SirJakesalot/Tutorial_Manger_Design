USE pageDB
DELIMITER //

DROP PROCEDURE IF EXISTS CountName //
CREATE PROCEDURE CountName(IN nm VARCHAR(50))
BEGIN
    SELECT COUNT(*)
    FROM (SELECT name FROM categories
          UNION
          SELECT name FROM pages) AS names
    WHERE name=nm;
END //

DROP PROCEDURE IF EXISTS CountNameExceptCatId //
CREATE PROCEDURE CountNameExceptCatId(
    IN cat_id VARCHAR(50),
    IN nm VARCHAR(50))
BEGIN
    SELECT COUNT(*)
    FROM (SELECT name FROM categories WHERE NOT id=cat_id
          UNION
          SELECT name FROM pages) AS names
    WHERE name=nm;
END //

DROP PROCEDURE IF EXISTS CountNameExceptPageId //
CREATE PROCEDURE CountNameExceptPageId(
    IN pg_id VARCHAR(50),
    IN nm VARCHAR(50))
BEGIN
    SELECT COUNT(*)
    FROM (SELECT name FROM categories
          UNION
          SELECT name FROM pages WHERE NOT id=pg_id) AS names
    WHERE name=nm;
END //

DROP PROCEDURE IF EXISTS CountLabel //
CREATE PROCEDURE CountLabel(IN lbl VARCHAR(100))
BEGIN
    SELECT COUNT(*)
    FROM (SELECT label FROM categories
          UNION
          SELECT label FROM pages) AS labels
    WHERE label=lbl;
END //

DROP PROCEDURE IF EXISTS CountLabelExceptCatId //
CREATE PROCEDURE CountLabelExceptCatId(
    IN cat_id VARCHAR(50),
    IN lbl VARCHAR(100))
BEGIN
    SELECT COUNT(*)
    FROM (SELECT label FROM categories WHERE NOT id=cat_id
          UNION
          SELECT label FROM pages) AS labels
    WHERE label=lbl;
END //

DROP PROCEDURE IF EXISTS CountLabelExceptPageId //
CREATE PROCEDURE CountLabelExceptPageId(
    IN pg_id VARCHAR(50),
    IN lbl VARCHAR(100))
BEGIN
    SELECT COUNT(*)
    FROM (SELECT label FROM categories
          UNION
          SELECT label FROM pages WHERE NOT id=pg_id) AS labels
    WHERE label=lbl;
END //

DROP PROCEDURE IF EXISTS CountCatId //
CREATE PROCEDURE CountCatId(IN cat_id VARCHAR(50))
BEGIN
    SELECT COUNT(*)
    FROM categories
    WHERE id=cat_id;
END //

DROP PROCEDURE IF EXISTS CountPageId //
CREATE PROCEDURE CountPageId(IN pg_id VARCHAR(50))
BEGIN
    SELECT COUNT(*)
    FROM pages
    WHERE id=pg_id;
END //

DROP PROCEDURE IF EXISTS CountParentId //
CREATE PROCEDURE CountParentId(IN pid VARCHAR(50))
BEGIN
    SELECT COUNT(id)
    FROM (SELECT id FROM categories WHERE parent_id=pid
          UNION
          SELECT category_id AS id FROM page_categories WHERE category_id=pid) AS ids;
END //

DROP PROCEDURE IF EXISTS GetAllCats //
CREATE PROCEDURE GetAllCats()
BEGIN
    SELECT * FROM categories;
END //

DROP PROCEDURE IF EXISTS GetCatByName //
CREATE PROCEDURE GetCatByName(IN nm VARCHAR(50))
BEGIN
    SELECT *
    FROM categories
    WHERE name=nm;
END //

DROP PROCEDURE IF EXISTS CountCatById //
CREATE PROCEDURE CountCatById(
    IN cat_id VARCHAR(50))
BEGIN
    SELECT COUNT(*) FROM categories WHERE id=cat_id;
END //

DROP PROCEDURE IF EXISTS InsertCat;
CREATE PROCEDURE InsertCat(
    IN pid VARCHAR(50),
    IN nm VARCHAR(50),
    IN lbl VARCHAR(100))
BEGIN
    INSERT INTO categories(parent_id, name, label)
    VALUES (pid, nm, lbl);
END //

DROP PROCEDURE IF EXISTS DeleteCatById //
CREATE PROCEDURE DeleteCatById(IN cat_id VARCHAR(50))
BEGIN
    DELETE FROM categories WHERE id=cat_id;
END //

DROP PROCEDURE IF EXISTS DeletePageById //
CREATE PROCEDURE DeletePageById(IN pg_id VARCHAR(50))
BEGIN
    DELETE FROM pages WHERE id=pg_id;
END //

DROP PROCEDURE IF EXISTS UpdateRootCat //
CREATE PROCEDURE UpdateRootCat(
    IN cid VARCHAR(50),
    IN nm VARCHAR(50),
    IN lbl VARCHAR(100))
BEGIN
    UPDATE categories
    SET name=nm, label=lbl
    WHERE id=cid;
END //

DROP PROCEDURE IF EXISTS UpdateSubcat //
CREATE PROCEDURE UpdateSubcat(
    IN cid VARCHAR(50),
    IN nm VARCHAR(50),
    IN lbl VARCHAR(100),
    IN pid VARCHAR(50))
BEGIN
    UPDATE categories
    SET name=nm, label=lbl, parent_id=pid
    WHERE id=cid;
END //

DROP PROCEDURE IF EXISTS GetAllPages //
CREATE PROCEDURE GetAllPages()
BEGIN
    SELECT id, pc.category_id AS category_id, name, label
    FROM pages LEFT JOIN (SELECT * FROM page_categories) AS pc
    ON id=pc.page_id;
END //

DROP PROCEDURE IF EXISTS GetPageByName //
CREATE PROCEDURE GetPageByName(IN nm VARCHAR(50))
BEGIN
    SELECT *
    FROM pages
    WHERE name=nm;
END //

DROP PROCEDURE IF EXISTS GetPageById //
CREATE PROCEDURE GetPageById(IN pid VARCHAR(50))
BEGIN
    SELECT *
    FROM pages
    WHERE id=pid;
END //

DROP PROCEDURE IF EXISTS InsertPage //
CREATE PROCEDURE InsertPage(
    IN nm VARCHAR(50),
    IN lbl VARCHAR(100),
    IN pid VARCHAR(50))
BEGIN
    INSERT INTO pages(name, label) VALUES(nm, lbl);
    INSERT INTO page_categories VALUES(LAST_INSERT_ID(), pid);
END //

DROP PROCEDURE IF EXISTS UpdatePage //
CREATE PROCEDURE UpdatePage(
    IN pid VARCHAR(50),
    IN nm VARCHAR(50),
    IN lbl VARCHAR(100),
    IN cntnt TEXT,
    IN parent_id VARCHAR(50))
BEGIN
    UPDATE pages
    SET name=nm, label=lbl, content=cntnt
    WHERE id=pid;
    UPDATE page_categories
    SET category_id=parent_id
    WHERE page_id=pid;
END //

DROP PROCEDURE IF EXISTS DeletePage //
CREATE PROCEDURE DeletePage(IN pg_id VARCHAR(50))
BEGIN
    DELETE FROM pages WHERE id=pg_id;
    DELETE FROM page_categories WHERE page_id=pg_id;
END //
