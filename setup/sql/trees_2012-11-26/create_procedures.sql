/*
Ronald Speelman 2012-11-25
More documentation on: http://moinne.com/blog/ronald
*/


/* set sql_mode to strict to avoid invalid variable assignments */
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES';


/*****************************************************************
 * tree_add_root
 *****************************************************************/
DELIMITER //
DROP PROCEDURE IF EXISTS tree_add_root;
//
CREATE DEFINER = CURRENT_USER PROCEDURE tree_add_root ()
/**
 * Part of the hierarchical tree functionality package. This package sets and maintains
 * multiple trees. The choosen model is the "Modified Preorder Tree Traversal"
 * <br>
 * %author Ronald Speelman
 * %version 1.4
 * Add a new root, This can be done only once
 * %return nothing
*/
proc: BEGIN

        -- Declare variables
        DECLARE e_table_not_empty CONDITION FOR SQLSTATE '45000';
        DECLARE v_found INT DEFAULT 0;

        -- Make sure the table is empty
        SELECT COUNT(1) INTO v_found FROM trees;
        IF v_found <> 0 THEN
            SIGNAL e_table_not_empty
                SET MESSAGE_TEXT = 'The table should be empty before adding a root node.';
            LEAVE proc;
        END IF;

        -- insert root node
        INSERT INTO trees (name, description, label, lft, rht,lvl)
            VALUES ('Root'  , NULL , 'Root', 1 , 2 ,0);

END //
DELIMITER ;


/*****************************************************************
 * tree_add_node
 *****************************************************************/
DELIMITER //
DROP PROCEDURE IF EXISTS tree_add_node;
//
CREATE DEFINER = CURRENT_USER PROCEDURE tree_add_node (
     IN p_parent INT
    ,IN p_name VARCHAR(50)
    ,IN p_label VARCHAR(100)
    ,IN p_description VARCHAR(500)
    )
/**
 * Part of the hierarchical tree functionality package. This package sets and maintains
 * multiple trees. The choosen model is the "Modified Preorder Tree Traversal"
 * <br>
 * %author Ronald Speelman
 * %version 1.4
 * Add a new node
 * %param p_parent           Number:      Node_id of the parent
 * %param p_name             String(50):  Name of the node. e.g. 'products',
 *                                        Must be a unique name in the treelevel
 * %param p_label            String(100): Label of the node. e.g. 'Products'
                                          If not provided, the name is used
 * %param p_description      String(500): Description of the node. e.g. 'Our list of products'
 * %return tree_id           Number:      The id of the just inserted node
*/
proc: BEGIN

        -- Declare variables
        DECLARE e_name_already_exists CONDITION FOR SQLSTATE '45000';
        DECLARE e_name_is_empty CONDITION FOR SQLSTATE '45000';
        DECLARE e_no_parent CONDITION FOR SQLSTATE '45000';
        DECLARE e_parent_not_found  CONDITION FOR SQLSTATE '45000';
        DECLARE v_parent_found INT DEFAULT 0;
        DECLARE v_found_name INT DEFAULT NULL;
        DECLARE v_label VARCHAR(100) DEFAULT NULL;
        DECLARE v_description VARCHAR(500) DEFAULT NULL;
        DECLARE v_parent_lft INT DEFAULT NULL;
        DECLARE v_parent_rht INT DEFAULT NULL;
        DECLARE v_parent_lvl MEDIUMINT DEFAULT NULL;
        DECLARE v_new_id INT DEFAULT NULL;

        -- Use default values if NULL is given as parameter
        SET v_label := COALESCE( p_label, p_name);
        SET v_description := COALESCE( p_description, v_description);

        -- Validate the parent (node_id)
        IF ( p_parent IS NULL) THEN
            SIGNAL e_no_parent
                SET MESSAGE_TEXT = 'The id of the parent node cannot be empty.';
            LEAVE proc;
        END IF;
        SELECT tree_id, lft , rht ,lvl INTO v_parent_found, v_parent_lft, v_parent_rht, v_parent_lvl
          FROM trees
         WHERE tree_id = p_parent;

        IF ( v_parent_found IS NULL) THEN
            SIGNAL e_parent_not_found
                SET MESSAGE_TEXT = 'The tree_id of the parent does not exists.';
            LEAVE proc;
        END IF;

        -- Validate the name of the node
        IF ( p_name IS NULL) OR ( p_name = '') THEN
            SIGNAL e_name_already_exists
                SET MESSAGE_TEXT = 'The name of the node cannot be empty.';
            LEAVE proc;
        END IF;

        -- check if the name already exists in this branch
        SELECT 1
          INTO v_found_name
          FROM trees
         WHERE lft >= v_parent_lft
           AND lft <  v_parent_rht
           AND lvl =  v_parent_lvl + 1
           AND name LIKE BINARY p_name ;

        IF v_found_name <> 0 THEN
            SIGNAL e_name_already_exists
               SET MESSAGE_TEXT = 'A node whith the exact same name already exists in this branch';
               LEAVE proc;
        END IF;

        -- insert the new node
        START TRANSACTION;
            -- make some room in the tree
            UPDATE trees SET lft = CASE WHEN lft >  v_parent_rht THEN lft + 2 ELSE lft END
                            ,rht = CASE WHEN rht >= v_parent_rht THEN rht + 2 ELSE rht END
             WHERE rht >= v_parent_rht;
            -- insert
            INSERT INTO trees (name, label, description, lft, rht, lvl)
                 VALUES ( p_name , v_label, v_description , v_parent_rht , v_parent_rht + 1,v_parent_lvl + 1);

            SELECT LAST_INSERT_ID() INTO v_new_id;
        COMMIT;

        -- return the inserted id
        SELECT v_new_id AS tree_id;

END //
DELIMITER ;

/*****************************************************************
 * tree_update_node
 *****************************************************************/
DELIMITER //
DROP PROCEDURE IF EXISTS tree_update_node;
//
CREATE DEFINER = CURRENT_USER PROCEDURE tree_update_node (
     IN p_id INT
    ,IN p_label VARCHAR(100)
    ,IN p_description VARCHAR(500)
    )
/**
 * Part of the hierarchical tree functionality package. This package sets and maintains
 * multiple trees. The choosen model is the "Modified Preorder Tree Traversal"
 * <br>
 * %author Ronald Speelman
 * %version 1.4
 * Update the label and description of a node
 * %param p_id               Number:      Node_id of the node to update
 * %param p_label            String(100): Label of the node. e.g. 'Products'
                                          If not provided, the name is used
 * %param p_description      String(500): Description of the node. e.g. 'Our list of products'
 * %return  nothing
*/
proc: BEGIN

        -- Declare variables
        DECLARE e_no_node CONDITION FOR SQLSTATE '45000';
        DECLARE e_node_not_found  CONDITION FOR SQLSTATE '45000';
        DECLARE v_node_found INT DEFAULT 0;
        DECLARE v_label VARCHAR(100) DEFAULT NULL;
        DECLARE v_description VARCHAR(500) DEFAULT NULL;

        -- Validate the node_id
        IF ( p_id IS NULL) THEN
            SIGNAL e_no_node
                SET MESSAGE_TEXT = 'The id of the node cannot be empty.';
            LEAVE proc;
        END IF;

        SELECT tree_id, label ,description INTO v_node_found, v_label, v_description
          FROM trees
         WHERE tree_id = p_id;

        IF ( v_node_found IS NULL) THEN
            SIGNAL e_node_not_found
                SET MESSAGE_TEXT = 'The tree_id does not exists.';
            LEAVE proc;
        END IF;

        -- Use old values if NULL is given as parameter
        SET v_label := COALESCE( p_label, v_label);
        SET v_description := COALESCE( p_description, v_description);

        -- update the node
        UPDATE trees
           SET label       = v_label
              ,description = v_description
         WHERE tree_id     = p_id;

END //
DELIMITER ;


/*****************************************************************
 * tree_get_all
 *****************************************************************/
DELIMITER //
DROP PROCEDURE IF EXISTS tree_get_all;
//
CREATE DEFINER = CURRENT_USER PROCEDURE tree_get_all (
     IN p_depth TINYINT
    ,IN p_indent VARCHAR(20)
    )
/**
 * Part of the hierarchical tree functionality package. This package sets and maintains
 * multiple trees. The choosen model is the "Modified Preorder Tree Traversal"
 * <br>
 * %author Ronald Speelman
 * %version 1.4
 * Get the whole tree, this is only for convenience. You can also used the
 * tree_get_branch and get tree_id 1
 * %param p_depth           Number:         The depth of the returned children
 * %param p_indent          String(20):     The indent string for eacht level in
 *                                          the tree. Default is no indentation.
 * %return the whole tree:                  For each row: tree_id, name, label
 *                                          , description,lvl, is_branch
*/
proc: BEGIN
        CALL tree_get_branch(1,p_depth,p_indent);
END //
DELIMITER ;


/*****************************************************************
 * tree_get_branch_by_name
 *****************************************************************/
DELIMITER //
DROP PROCEDURE IF EXISTS tree_get_branch_by_name;
//
CREATE DEFINER = CURRENT_USER PROCEDURE tree_get_branch_by_name(
     IN p_parentname VARCHAR(50)
    ,IN p_name VARCHAR(50)
    ,IN p_depth TINYINT
    ,IN p_indent VARCHAR(20)
    )
/**
 * Part of the hierarchical tree functionality package. This package sets and maintains
 * multiple trees. The choosen model is the "Modified Preorder Tree Traversal"
 * <br>
 * %author Ronald Speelman
 * %version 1.4
 * Get a branch of the tree by name. You need to provide the name of the parent
 * and the name of the node you want to retrieve. This is because a duplicate
 * nodename is likely to exist in the tree. If the combination of the parent and
 * child exist more then once, only one of them is retrieved.

 * %param p_parentname      String(50):     The name of the parent. e.g. 'Root'
 * %param p_name            String(50):     The name of the node you want e.g. 'products'
 * %param p_depth           Number:         The depth of the returned children
 * %param p_indent          String(20):     The indent string for eacht level in
 *                                          the tree. Default is no indentation.
 * %return the branch:                      For each row: tree_id, name, label
 *                                          , description, lvl, is_branch
*/
proc: BEGIN

        -- Declare variables
        DECLARE e_no_relation CONDITION FOR SQLSTATE '45000';
        DECLARE v_tree_id INT DEFAULT NULL;

        -- Validate the parent name and the node name and if the node is a child of the parent
        SELECT b.tree_id INTO v_tree_id
          FROM trees a, trees b
         WHERE a.name LIKE BINARY p_parentname
           AND b.name LIKE BINARY p_name
           AND a.name <> b.name
           AND b.lft BETWEEN a.lft AND a.rht
           AND a.lvl = b.lvl -1
         LIMIT 1
             ;

        IF ( v_tree_id IS NOT NULL ) THEN
            CALL tree_get_branch( v_tree_id , p_depth, p_indent);
        ELSE
            SIGNAL e_no_relation
                SET MESSAGE_TEXT = 'The nodename is not a direct child of the parentname.';
            LEAVE proc;
        END IF;

END //
DELIMITER ;

/*****************************************************************
 * tree_get_branch
 *****************************************************************/
DELIMITER //
DROP PROCEDURE IF EXISTS tree_get_branch;
//
CREATE DEFINER = CURRENT_USER PROCEDURE tree_get_branch (
     IN p_id INT
    ,IN p_depth TINYINT
    ,IN p_indent VARCHAR(20)
    )
/**
 * Part of the hierarchical tree functionality package. This package sets and maintains
 * multiple trees. The choosen model is the "Modified Preorder Tree Traversal"
 * <br>
 * %author Ronald Speelman
 * %version 1.5
 * Get a branch of the tree
 * %param p_id              Number:         The tree_id of the branch
 * %param p_depth           Number:         The depth of the returned children
 * %param p_indent          String(20):     The indent string for each level in
 *                                          the tree. Default is no indentation.
 * %return the branch:                      For each row: tree_id, name, label
 *                                          , description, lvl, cnt_children, is_branch
*/
proc: BEGIN

        -- Declare variables
        DECLARE e_no_id CONDITION FOR SQLSTATE '45000';
        DECLARE e_id_not_found  CONDITION FOR SQLSTATE '45000';
        DECLARE v_node_found INT DEFAULT NULL;
        DECLARE v_node_lft INT DEFAULT NULL;
        DECLARE v_node_rht INT DEFAULT NULL;
        DECLARE v_node_lvl MEDIUMINT DEFAULT NULL;
        DECLARE v_indent VARCHAR(20) DEFAULT NULL;
        DECLARE v_depth TINYINT DEFAULT 127;

        -- Validate the tree_id
        IF ( p_id IS NULL) THEN
            SIGNAL e_no_id
                SET MESSAGE_TEXT = 'The id cannot be empty.';
            LEAVE proc;
        END IF;
        SELECT tree_id, lft , rht ,lvl INTO v_node_found, v_node_lft, v_node_rht, v_node_lvl
          FROM trees
         WHERE tree_id = p_id;

        IF ( v_node_found IS NULL) THEN
            SIGNAL e_id_not_found
                SET MESSAGE_TEXT = 'The tree_id does not exists.';
            LEAVE proc;
        END IF;

        -- Use default values if NULL is given as parameter
        SET v_indent := COALESCE( p_indent, '');
        SET v_depth := COALESCE( p_depth, v_depth);

        -- select the branch
        SELECT tree_id
             , name
             , CONCAT(REPEAT( v_indent, (lvl - v_node_lvl) ), label) AS label
             , description
             , lvl
             , FORMAT((((rht - lft) -1) / 2),0) AS cnt_children
            , CASE WHEN rht - lft > 1 THEN 1 ELSE 0 END AS is_branch
          FROM trees
         WHERE lft >= v_node_lft
           AND lft < v_node_rht
           AND lvl <= v_node_lvl + v_depth
         ORDER BY lft;

END //
DELIMITER ;


/*****************************************************************
 * tree_get_parents
 *****************************************************************/
DELIMITER //
DROP PROCEDURE IF EXISTS tree_get_parents;
//
CREATE DEFINER = CURRENT_USER PROCEDURE tree_get_parents (
     IN p_id INT
    ,IN p_indent VARCHAR(20)
    )
/**
 * Part of the hierarchical tree functionality package. This package sets and maintains
 * multiple trees. The choosen model is the "Modified Preorder Tree Traversal"
 * <br>
 * %author Ronald Speelman
 * %version 1.4
 * Get a the parents of a node in the tree
 * %param p_id              Number:         The tree_id of the branch
 * %param p_indent          String(20):     The indent string for eacht level in
 *                                          the tree. Default is no indentation.
 * %return the parents of a node:           For each row: tree_id, name, label
 *                                          , description, lvl
*/
proc: BEGIN

        -- Declare variables
        DECLARE e_no_id CONDITION FOR SQLSTATE '45000';
        DECLARE e_id_not_found  CONDITION FOR SQLSTATE '45000';
        DECLARE v_node_found INT DEFAULT NULL;
        DECLARE v_node_lft INT DEFAULT NULL;
        DECLARE v_indent VARCHAR(20) DEFAULT NULL;

        -- Validate the tree_id
        IF (p_id IS NULL) THEN
            SIGNAL e_no_id
                SET MESSAGE_TEXT = 'The id cannot be empty.';
            LEAVE proc;
        END IF;
        SELECT tree_id, lft INTO v_node_found, v_node_lft
          FROM trees
         WHERE tree_id = p_id;

        IF ( v_node_found IS NULL) THEN
            SIGNAL e_id_not_found
                SET MESSAGE_TEXT = 'The tree_id does not exists.';
            LEAVE proc;
        END IF;

        -- Use default values if NULL is given as parameter
        SET v_indent := COALESCE( p_indent, '');

        -- select the parents
        SELECT a.tree_id
             , a.name
             , CONCAT(REPEAT( v_indent, a.lvl ), a.label) AS label
             , a.description
             , a.lvl
          FROM trees a, trees b
         WHERE b.tree_id = p_id
           AND a.tree_id <> p_id
           AND b.lft BETWEEN a.lft AND a.rht
             ;
END //
DELIMITER ;

/*****************************************************************
 * tree_swap_leafs
 *****************************************************************/
DELIMITER //
DROP PROCEDURE IF EXISTS tree_swap_leafs;
//
CREATE DEFINER = CURRENT_USER PROCEDURE tree_swap_leafs (
     IN p_id1 INT
    ,IN p_id2 INT
    )
/**
 * Part of the hierarchical tree functionality package. This package sets and maintains
 * multiple trees. The choosen model is the "Modified Preorder Tree Traversal"
 * <br>
 * %author Ronald Speelman
 * %version 1.4
 * Swap the position of two leafs in the branch (so only within the same level)
 * %param p_id1             Number:         The tree_id of the node to be moved
 * %param p_id2             Number:         The tree_id of the target node
 * %return nothing
*/
proc: BEGIN

        -- Declare variables
        DECLARE e_no_id CONDITION FOR SQLSTATE '45000';
        DECLARE e_id_not_found  CONDITION FOR SQLSTATE '45000';
        DECLARE e_id_not_leaf  CONDITION FOR SQLSTATE '45000';
        DECLARE e_levels_not_equal  CONDITION FOR SQLSTATE '45000';
        DECLARE v_node_found INT DEFAULT NULL;
        DECLARE v_node1_lft INT DEFAULT NULL;
        DECLARE v_node1_rht INT DEFAULT NULL;
        DECLARE v_node1_lvl INT DEFAULT NULL;
        DECLARE v_node2_lft INT DEFAULT NULL;
        DECLARE v_node2_rht INT DEFAULT NULL;
        DECLARE v_node2_lvl INT DEFAULT NULL;

        -- Validate the tree_id for p_id1 and p_id2
        IF (p_id1 IS NULL OR p_id2 IS NULL) THEN
            SIGNAL e_no_id
                SET MESSAGE_TEXT = 'Both id1 and id2 needs to be provided as parameter.';
            LEAVE proc;
        END IF;

        SELECT tree_id, lft, rht, lvl INTO v_node_found, v_node1_lft, v_node1_rht, v_node1_lvl
          FROM trees
         WHERE tree_id = p_id1;

        IF ( v_node_found IS NULL) THEN
            SIGNAL e_id_not_found
                SET MESSAGE_TEXT = 'The tree_id for id1 does not exists.';
            LEAVE proc;
        END IF;

        SELECT tree_id, lft, rht, lvl INTO v_node_found, v_node2_lft, v_node2_rht, v_node2_lvl
          FROM trees
         WHERE tree_id = p_id2;

        IF ( v_node_found IS NULL) THEN
            SIGNAL e_id_not_found
                SET MESSAGE_TEXT = 'The tree_id for id2 does not exists.';
            LEAVE proc;
        END IF;

        IF ( v_node1_lvl <> v_node2_lvl ) THEN
            SIGNAL e_levels_not_equal
                SET MESSAGE_TEXT = 'You cannot change position between nodes with a different level.';
            LEAVE proc;
        END IF;

        IF ( v_node1_rht - v_node1_lft ) > 1 OR
           ( v_node2_rht - v_node2_lft ) > 1 THEN
            SIGNAL e_levels_not_equal
                SET MESSAGE_TEXT = 'You can only swap leafs. One or both of the nodes is a branch.';
            LEAVE proc;
        END IF;

        -- update the leafs
        START TRANSACTION;
            UPDATE trees
            SET   lft     = v_node2_lft
                , rht     = v_node2_rht
                , lvl     = v_node2_lvl
            WHERE tree_id = p_id1;

            UPDATE trees
            SET   lft     = v_node1_lft
                , rht     = v_node1_rht
                , lvl     = v_node1_lvl
            WHERE tree_id = p_id2;
        COMMIT;
END //
DELIMITER ;


/*****************************************************************
 * tree_del
 *****************************************************************/
DELIMITER //
DROP PROCEDURE IF EXISTS tree_del;
//
CREATE DEFINER = CURRENT_USER PROCEDURE tree_del (
     IN p_id INT
    )
/**
 * Part of the hierarchical tree functionality package. This package sets and maintains
 * multiple trees. The choosen model is the "Modified Preorder Tree Traversal"
 * <br>
 * %author Ronald Speelman
 * %version 1.5
 * Delete a node in the tree with all children
 * %param p_id              Number:         The tree_id of the branch
 * %return  nothing
*/
proc: BEGIN

        -- Declare variables
        DECLARE e_no_id CONDITION FOR SQLSTATE '45000';
        DECLARE e_id_not_found  CONDITION FOR SQLSTATE '45000';
        DECLARE v_node_found INT DEFAULT NULL;
        DECLARE v_node_lft INT DEFAULT NULL;
        DECLARE v_node_rht INT DEFAULT NULL;
        DECLARE v_node_lvl MEDIUMINT DEFAULT NULL;
        DECLARE v_node_tmp INT DEFAULT NULL;

        -- Validate the tree_id
        IF ( p_id IS NULL) THEN
            SIGNAL e_no_id
                SET MESSAGE_TEXT = 'The id cannot be empty.';
            LEAVE proc;
        END IF;

        SELECT tree_id, lft , rht ,lvl INTO v_node_found, v_node_lft, v_node_rht, v_node_lvl
          FROM trees
         WHERE tree_id = p_id;

        IF ( v_node_found IS NULL) THEN
            SIGNAL e_id_not_found
                SET MESSAGE_TEXT = 'The tree_id does not exists.';
            LEAVE proc;
        END IF;

        -- Start deleting
        START TRANSACTION;
            -- Delete the node and the children if they exist
            DELETE
              FROM trees
             WHERE lft >= v_node_lft
               AND lft < v_node_rht
               AND rht <= v_node_rht
               AND lvl >= v_node_lvl;

            -- update the parents
               SET v_node_tmp = ((v_node_rht - v_node_lft) + 1);
            UPDATE trees
               SET lft = CASE WHEN lft > v_node_lft THEN lft - v_node_tmp ELSE lft END
                  ,rht = CASE WHEN rht > v_node_lft THEN rht - v_node_tmp ELSE rht END
             WHERE rht > v_node_rht;
        COMMIT;

END //
DELIMITER ;


/* restore the original sql_mode */
SET sql_mode=@OLD_SQL_MODE;

