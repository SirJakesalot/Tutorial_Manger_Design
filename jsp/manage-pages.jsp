<%@ include file="header.jsp" %>
<style>
  .btn {
    min-height: 30px;
  }  
</style>

<h1 class="c-text">Welcome</h1>
<div id="tree" class="tree well">
  <ul>
    <li>
      <span><i class="glyphicon glyphicon-folder-open"></i> ${tree.cat().name()}</span>
      <div class="pull-right btn-group btn-group-sm">
        <button class="btn btn-success" data-toggle="modal" data-target="#addNodeModal">
          <i class="glyphicon glyphicon-plus"></i>
        </button>
        <button class="btn btn-info" data-toggle="modal" data-target="#editCatModal">
          <i class="glyphicon glyphicon-edit"></i>
        </button>
        <button class="btn btn-danger" data-toggle="modal" data-target="#delCatModal">
          <i class="glyphicon glyphicon-trash"></i>
        </button>
      </div>
      <c:set var="node" value="${tree}" scope="request"></c:set>
      <jsp:include page="node.jsp"/>
    </li>
  </ul>
</div>


<button class="btn btn-info" data-toggle="modal" data-target="#addNodeModal">
  <i class="glyphicon glyphicon-plus"></i>
</button>

<div id="addNodeModal" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Add Node</h4>
      </div>
      <div class="modal-body">
        <div class="tabbable">
          <ul class="nav nav-tabs">
            <li class="active"><a href="#addPage" data-toggle="tab">Add Page</a></li>
            <li><a href="#addCat" data-toggle="tab">Add Category</a></li>
          </ul>
          <div class="tab-content">
            <div class="tab-pane active" id="addPage">
              <p>Add Page Data</p>
            </div>
            <div class="tab-pane" id="addCat">
              <br>
              <div class="input-group has-feedback">
                <input id="addCatName" type="text" class="form-control" placeholder="Category Name"/>
                <input id="addCatLabel" type="text" class="form-control" placeholder="Category Label"/>
              </div>
              <button type="button" class="btn btn-primary" onclick="addCategory('${context}/api/addcat');">Submit</button>
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
        
        
<div id="editCatModal" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Edit Category</h4>
      </div>
      <div class="modal-body">
        <p>Edit Category Data</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>


<div id="delCatModal" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Delete Category</h4>
      </div>
      <div class="modal-body">
        <p>Delete Category Data</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<div id="editPageModal" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Edit Page</h4>
      </div>
      <div class="modal-body">
        <p>Edit Page Data</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>


<div id="delPageModal" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Delete Page</h4>
      </div>
      <div class="modal-body">
        <p>Delete Page Data</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<script>
$(function () {
  $('#tree li:has(ul)')
    .addClass('parent_li')
    .find(' > span')
    .attr('title', 'Collapse this branch');
  $('#tree li.parent_li > span')
    .on('click', function (e) {
      var children = $(this).parent('li.parent_li').find(' > ul > li');
      if (children.is(":visible")) {
        children.hide('fast');
        $(this)
          .attr('title', 'Expand this branch')
          .find(' > i')
          .addClass('glyphicon-folder-close')
          .removeClass('glyphicon-folder-open');
      } else {
        children.show('fast');
        $(this)
          .attr('title', 'Collapse this branch')
          .find(' > i')
          .addClass('glyphicon-folder-open')
          .removeClass('glyphicon-folder-close');
      }
    e.stopPropagation();
  });
});
</script>

<%@ include file="footer.jsp" %>
