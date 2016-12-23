DROP TABLE IF EXISTS trees;

CREATE TABLE trees(
  tree_id           INT UNSIGNED NOT NULL AUTO_INCREMENT
 ,name              VARCHAR(50) NOT NULL
 ,label             VARCHAR(100) NOT NULL
 ,description       VARCHAR(500) NULL
 ,lft               INT NOT NULL
 ,rht               INT NOT NULL
 ,lvl               MEDIUMINT NOT NULL
 ,PRIMARY KEY (tree_id)
 ,KEY trees_nav_idx (lft,rht,lvl)
 ,KEY trees_name_idx (name,lvl)
) ENGINE=InnoDB;

