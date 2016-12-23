README.txt
Ronald Speelman 2012-05-20-
More documentation on: http://moinne.com/blog/ronald

Manage hierarchical data with MySQL stored procedures

Below you will find all code to create the table and the stored procedures to manage hierarchical trees in MySQL.
The following stored procedures are provided:
tree_add_root()
tree_add_node(id,name,label,description)
tree_update_node(id,label,description)
tree_get_all(depth,indentstring)
tree_get_branch(id,depth,indentstring)
tree_get_branch_by_name(parentname,name,depth,indentstring)
tree_get_parents(id,indentstring)
tree_swap_leafs(id1,id2)
tree_del(id)

Note that I do not describe the parameters for each procedure in this article. The parameters are described in the code.
Also, the procedures try to verify the input of the stored procedures and appropriate error messages will be returned if needed.

How to set it up?
Install the table:
mysql>source create_tables.sql
This will create the table 'trees' if it does not already exists.

Install the stored procedures:
mysql>source create_procedures.sql
This will create the procedures as described above. Note that they will overwrite existing stored procedures if they have the same name. Be careful!

Set up test data:
mysql>source populate_trees.sql

How do I used the stored procedures?
To test if everything works run the procedure to show the whole tree and have the branches indented by '--':
mysql>call tree_get_all(NULL,'--');
+---------+-----------+---------------------+------------------+-----+-----------+
| tree_id | name      | label               | description      | lvl | is_branch |
+---------+-----------+---------------------+------------------+-----+-----------+
|       1 | Root      | Root                | NULL             |   0 |         1 |
|       2 | pages     | --Pages             | Pages in website |   1 |         1 |
|       4 | Home      | ----Home            | NULL             |   2 |         1 |
|       5 | About     | ------About us      | NULL             |   3 |         1 |
|       6 | Contact   | --------Contact us  | NULL             |   4 |         0 |
|       7 | Events    | --------Our events  | NULL             |   4 |         0 |
|       8 | Service   | ------Service       | NULL             |   3 |         1 |
|       9 | Products  | --------Products    | NULL             |   4 |         1 |
|      10 | Search    | ----------Search    | NULL             |   5 |         0 |
|      11 | Reviews   | ----------Reviews   | NULL             |   5 |         0 |
|      25 | Furniture | ----------Furniture | NULL             |   5 |         0 |
|      12 | FAQ       | --------FAQ         | NULL             |   4 |         0 |
|      13 | Order     | ------Shoppingcart  | NULL             |   3 |         0 |
|       3 | products  | --Products          | Product list     |   1 |         1 |
|      14 | Furniture | ----Furniture       | NULL             |   2 |         1 |
|      16 | Living    | ------Living        | NULL             |   3 |         1 |
|      19 | Chairs    | --------Chairs      | NULL             |   4 |         0 |
|      20 | Tables    | --------Tables      | NULL             |   4 |         0 |
|      17 | Kitchen   | ------Kitchen       | NULL             |   3 |         0 |
|      18 | Bedroom   | ------Bedroom       | NULL             |   3 |         1 |
|      21 | Chairs    | --------Chairs      | NULL             |   4 |         0 |
|      22 | Tables    | --------Tables      | NULL             |   4 |         0 |
|      23 | Beds      | --------Beds        | NULL             |   4 |         0 |
|      24 | Closets   | --------Closets     | NULL             |   4 |         0 |
|      15 | Office    | ----Office suplies  | NULL             |   2 |         0 |
+---------+-----------+---------------------+------------------+-----+-----------+
25 rows in set (0.00 sec)

The example data has two trees, one for the navigation in our website and another tree for products that we sell.
tree_id : The id of the node, this is the primary key
name : name of the node, must be unique (case sensitive) in a branch
label : the pretty name of the node
description : an optional long description of the node
lvl : the level of the node in the tree
is_branch : if it is '1' there is a sub-branch available. If it is '0' then this node is a leaf in the tree.

Now lets get the first two levels in the tree indented by 2 spaces:
mysql>call tree_get_all(2,'  ');
+---------+-----------+--------------------+------------------+-----+-----------+
| tree_id | name      | label              | description      | lvl | is_branch |
+---------+-----------+--------------------+------------------+-----+-----------+
|       1 | Root      | Root               | NULL             |   0 |         1 |
|       2 | pages     |   Pages            | Pages in website |   1 |         1 |
|       4 | Home      |     Home           | NULL             |   2 |         1 |
|       3 | products  |   Products         | Product list     |   1 |         1 |
|      14 | Furniture |     Furniture      | NULL             |   2 |         1 |
|      15 | Office    |     Office suplies | NULL             |   2 |         0 |
+---------+-----------+--------------------+------------------+-----+-----------+
6 rows in set (0.00 sec)

Or get the 'Products' branch and only it's direct children and do not indent it:
mysql>call tree_get_branch(3,1,NULL);
+---------+-----------+----------------+--------------+-----+-----------+
| tree_id | name      | label          | description  | lvl | is_branch |
+---------+-----------+----------------+--------------+-----+-----------+
|       3 | products  | Products       | Product list |   1 |         1 |
|      14 | Furniture | Furniture      | NULL         |   2 |         1 |
|      15 | Office    | Office suplies | NULL         |   2 |         0 |
+---------+-----------+----------------+--------------+-----+-----------+
3 rows in set (0.00 sec)

Or get a branch by it's name. Because it is very likely that a tree has duplicate names in it, you need to provide the
name of the parent and the name of the node that you want to retrieve. If this combination is used more then once in
the tree, only one result is retrieved.
This procedure is not as efficient as the one above and in case of duplicate parent-child combinations the result can be unpredictable.
But it is much more verbose to ask for 'Root','products' then only for 'id:3'.
Note that the names are case sensitive.
E.g.;
mysql>call tree_get_branch_by_name('Root','products',1,NULL);
+---------+-----------+----------------+--------------+-----+-----------+
| tree_id | name      | label          | description  | lvl | is_branch |
+---------+-----------+----------------+--------------+-----+-----------+
|       3 | products  | Products       | Product list |   1 |         1 |
|      14 | Furniture | Furniture      | NULL         |   2 |         1 |
|      15 | Office    | Office suplies | NULL         |   2 |         0 |
+---------+-----------+----------------+--------------+-----+-----------+
3 rows in set (0.00 sec)

To retrieve the parents of the node 'Beds', for a breadcrumb for example, use;
mysql>call tree_get_parents(23,NULL);
+---------+-----------+-----------+--------------+-----+
| tree_id | name      | label     | description  | lvl |
+---------+-----------+-----------+--------------+-----+
|       1 | Root      | Root      | NULL         |   0 |
|       3 | products  | Products  | Product list |   1 |
|      14 | Furniture | Furniture | NULL         |   2 |
|      18 | Bedroom   | Bedroom   | NULL         |   3 |
+---------+-----------+-----------+--------------+-----+
4 rows in set (0.00 sec)

Adding, removing and changing the tree:
Add the root to the tree:
When you first set up the table you first need to add a root to the tree. You only need to do this once.
This will give you an error message if the table trees is not empty.
mysql>call tree_add_root();

Add a new node to the tree:
mysql>call tree_add_node(18,'beds',NULL,NULL);
+---------+
| tree_id |
+---------+
|      26 |
+---------+
1 row in set (0.01 sec)
This has added the node 'beds' to the parent 'Bedroom'. The new tree_id for this node is returned.
We left the 'label' parameter empty so the name will be used as the label too.
Note that in the parent 'Bedroom' there is already another node called 'Beds'.
We are allowed to add this node name because the names of the nodes are case sensitive. Another 'Beds' would generate an error message.
Let's see the result:
mysql:call tree_get_branch(18,1,'  ');
+---------+---------+-----------+-------------+-----+-----------+
| tree_id | name    | label     | description | lvl | is_branch |
+---------+---------+-----------+-------------+-----+-----------+
|      18 | Bedroom | Bedroom   | NULL        |   3 |         1 |
|      21 | Chairs  |   Chairs  | NULL        |   4 |         0 |
|      22 | Tables  |   Tables  | NULL        |   4 |         0 |
|      23 | Beds    |   Beds    | NULL        |   4 |         0 |
|      24 | Closets |   Closets | NULL        |   4 |         0 |
|      26 | beds    |   beds    | NULL        |   4 |         0 |
+---------+---------+-----------+-------------+-----+-----------+
6 rows in set (0.00 sec)

Change a node:
We noticed that the label and description of the newly inserted node is not correct and we can change it like this:
mysql>call tree_update_node(26,'Beds','other beds');
Query OK, 1 row affected (0.04 sec)

mysql:call tree_get_branch(18,1,'  ');
+---------+---------+-----------+-------------+-----+-----------+
| tree_id | name    | label     | description | lvl | is_branch |
+---------+---------+-----------+-------------+-----+-----------+
|      18 | Bedroom | Bedroom   | NULL        |   3 |         1 |
|      21 | Chairs  |   Chairs  | NULL        |   4 |         0 |
|      22 | Tables  |   Tables  | NULL        |   4 |         0 |
|      23 | Beds    |   Beds    | NULL        |   4 |         0 |
|      24 | Closets |   Closets | NULL        |   4 |         0 |
|      26 | beds    |   Beds    | other beds  |   4 |         0 |
+---------+---------+-----------+-------------+-----+-----------+
6 rows in set (0.00 sec)


We can change the order of the leafs like this:
mysql>call tree_swap_leafs(24,26);
Query OK, 0 rows affected (0.04 sec)

mysql> call tree_get_branch(18,1,'  ');
+---------+---------+-----------+-------------+-----+-----------+
| tree_id | name    | label     | description | lvl | is_branch |
+---------+---------+-----------+-------------+-----+-----------+
|      18 | Bedroom | Bedroom   | NULL        |   3 |         1 |
|      21 | Chairs  |   Chairs  | NULL        |   4 |         0 |
|      22 | Tables  |   Tables  | NULL        |   4 |         0 |
|      23 | Beds    |   Beds    | NULL        |   4 |         0 |
|      26 | beds    |   Beds    | other beds  |   4 |         0 |
|      24 | Closets |   Closets | NULL        |   4 |         0 |
+---------+---------+-----------+-------------+-----+-----------+
6 rows in set (0.00 sec)

And finally we can remove a node from the tree.
If the node has children, these children will be removed too.
mysql>call tree_del(18);
Query OK, 6 rows affected (0.01 sec)

mysql> call tree_get_branch(18,1,'  ');
ERROR 1644 (45000): The tree_id does not exists.

Let's try it one level higher to see the whole furniture branch:
mysql>call tree_get_branch(14,NULL,'  ');
+---------+-----------+------------+-------------+-----+-----------+
| tree_id | name      | label      | description | lvl | is_branch |
+---------+-----------+------------+-------------+-----+-----------+
|      14 | Furniture | Furniture  | NULL        |   2 |         1 |
|      16 | Living    |   Living   | NULL        |   3 |         1 |
|      19 | Chairs    |     Chairs | NULL        |   4 |         0 |
|      20 | Tables    |     Tables | NULL        |   4 |         0 |
|      17 | Kitchen   |   Kitchen  | NULL        |   3 |         0 |
+---------+-----------+------------+-------------+-----+-----------+
5 rows in set (0.00 sec)


More documentation can be found on:
http://moinne.com/blog/ronald
