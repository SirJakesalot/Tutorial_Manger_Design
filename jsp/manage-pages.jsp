<%@ include file="header.jsp" %>
<style>
  .btn {
    min-height: 30px;
  }  
</style>

<div id="tree" class="tree well">
  <ul>
    <li>
      <span><i class="glyphicon glyphicon-folder-open"></i> ${tree.cat().name()}</span>
      <div id="${tree.cat().id()}" class="pull-right btn-group btn-group-sm" data-name="${tree.cat().name()}" data-label="${tree.cat().label()}" data-type="cat">
        <button class="btn btn-success" data-toggle="modal" data-target="#addNodeModal">
          <i class="glyphicon glyphicon-plus"></i>
        </button>
        <button class="btn btn-info" data-toggle="modal" data-target="#editCatModal">
          <i class="glyphicon glyphicon-edit"></i>
        </button>
      </div>
      <c:set var="node" value="${tree}" scope="request"></c:set>
      <jsp:include page="node.jsp"/>
    </li>
  </ul>
</div>


<div id="addNodeModal" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Add Node</h4>
      </div>
      <div class="modal-body">
        <div class="tabbable">
          <ul id="addNodeTabs" class="nav nav-tabs">
            <li class="active"><a href="#addPage" data-toggle="tab">Add Page</a></li>
            <li><a href="#addCat" data-toggle="tab">Add Category</a></li>
          </ul>
          <div class="tab-content">
            <div class="tab-pane active" id="addPage">
              <br>

              <form id="addPageForm">
                <div class="form-group">
                  <label for="addPageName">Page Name</label>
                  <input id="addPageName" name="name" type="text" class="form-control" placeholder="New Page Name" maxlength="50"/>
                </div>
                <div class="form-group">
                  <label for="addPageLabel">Page Label</label>
                  <input id="addPageLabel" name="label" type="text" class="form-control" placeholder="New Page Label" maxlength="100"/>
                </div>
                <div class="form-group">
                  <div id="addPageFormMessages"></div>
                </div>
                <div style="text-align: right;">
                  <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                  <button type="submit" class="btn btn-success" disabled>Add Page</button>
                </div>
              </form>
            </div>

            <div class="tab-pane" id="addCat">
              <br>

              <form id="addCatForm">
                <div class="form-group">
                  <label for="addCatName">Category Name</label>
                  <input id="addCatName" name="name" type="text" class="form-control" placeholder="New Category Name" maxlength="50"/>
                </div>
                <div class="form-group">
                  <label for="addCatLabel">Category Label</label>
                  <input id="addCatLabel" name="label" type="text" class="form-control" placeholder="New Category Label" maxlength="100"/>
                </div>
                <div class="form-group">
                  <div id="addCatFormMessages"></div>
                </div>
                <div style="text-align: right;">
                  <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                  <button type="submit" class="btn btn-success" disabled>Add Category</button>
                </div>
              </form>

            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
        
        
<div id="editCatModal" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Edit Category</h4>
      </div>
      <div class="modal-body">
        <form id="editCatForm">
          <div class="form-group">
            <label for="editCatPicker">Parent Category</label></br>
            <select id="editCatPicker" data-live-search="true" data-live-search-style="contains" class="selectpicker"></select>
          </div>
          <div class="form-group">
            <label for="editCatName">Category Name</label>
            <input id="editCatName" name="name" type="text" class="form-control" placeholder="New Category Name"/>
          </div>
          <div class="form-group">
            <label for="editCatLabel">Category Label</label>
            <input id="editCatLabel" name="label" type="text" class="form-control" placeholder="New Category Label"/>
          </div>
          <div style="text-align: right;">
            <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
            <button type="submit" class="btn btn-primary" disabled>Save</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>


<div id="delCatModal" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Delete Category</h4>
      </div>
      <div class="modal-body">
        <strong>Are you sure you want to delete this category?</strong>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-danger" onclick="delCat();">Delete</button>
      </div>
    </div>
  </div>
</div>

<div id="editPageModal" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Edit Page</h4>
      </div>
      <div class="modal-body">
        <div class="form-group">
          <label for="editPagePicker">Parent Category</label></br>
          <select id="editPagePicker" data-live-search="true" data-live-search-style="contains" class="selectpicker"></select>
        </div>
        <div class="form-group">
          <label for="editPageName">Page Name</label>
          <input id="editPageName" type="text" class="form-control" placeholder="New Page Name"/>
        </div>
        <div class="form-group">
          <label for="editPageLabel">Page Label</label>
          <input id="editPageLabel" type="text" class="form-control" placeholder="New Page Label"/>
        </div>
        <div class="form-group">
          <label for="editPageEditor">Page Content</label>
          <div id="editPageEditor"></div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary" onclick="editPage();">Save</button>
      </div>
    </div>
  </div>
</div>

<div id="delPageModal" class="modal fade" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Delete Page</h4>
      </div>
      <div class="modal-body">
        <strong>Are you sure you want to delete this page?</strong>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-danger" onclick="delPage();">Submit</button>
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
  $.each($('div').find('[data-type="cat"]'), function() {
    $('#editCatPicker').append(
      $('<option/>')
        .val($(this).attr('id'))
        .text($(this).data('label'))
    );
    $('#editPagePicker').append(
      $('<option/>')
        .val($(this).attr('id'))
        .text($(this).data('label'))
    );
  });
  $('#editCatPicker').selectpicker('refresh');
  $('#editPagePicker').selectpicker('refresh');
  /*
  $.each($('.selectpicker'), function() {
    $(this).selectpicker('refresh');
  });
  */
  var editor = ace.edit("editPageEditor");
  editor.getSession().setMode("ace/mode/html");
  editor.setOptions({maxLines: 15});
  editor.$blockScrolling = Infinity;
});
$('.modal').on('show.bs.modal', function(e) {
  $(this).data('trigger', $(e.relatedTarget).parent().attr('id'));
});
$('.modal').on('hidden.bs.modal', function(e) {
  $('.alert-danger').remove();
});
$('#editCatModal').on('show.bs.modal', function(e) {
  var btn_group = $(e.relatedTarget).parent();
  if (btn_group.attr('id') == ${tree.cat().id()}) {
    $('label[for=editCatPicker]').hide();
    $('#editCatModal .selectpicker').selectpicker('hide').val('');
  } else {
    $('label[for=editCatPicker]').show();
    $('#editCatModal .selectpicker').selectpicker('show');
  }
  $('#editCatName').val($(e.relatedTarget).parent().data('name'));
  $('#editCatLabel').val($(e.relatedTarget).parent().data('label'));
  $('#editCatPicker').val($(e.relatedTarget).parent().parent().parent().parent().find('div').attr('id'));
  $('#editCatPicker').selectpicker('refresh');
});
$('#editPageModal').on('show.bs.modal', function(e) {
  getPageContent();
  $('#editPageName').val($(e.relatedTarget).parent().data('name'));
  $('#editPageLabel').val($(e.relatedTarget).parent().data('label'));
  $('#editPagePicker').val($(e.relatedTarget).parent().parent().parent().parent().find('div').attr('id'));
  $('#editPagePicker').selectpicker('refresh');
});

var addCatURL  = "${context}/api/addcat";
var delCatURL  = "${context}/api/delcat";
var editCatURL = "${context}/api/editcat";
var addPageURL  = "${context}/api/addpage";
var delPageURL  = "${context}/api/delpage";
var editPageURL = "${context}/api/editpage";
var getPageContentURL = "${context}/api/getpagecontent";
</script>

<script>
$('#addPageForm').bootstrapValidator({
  framework: 'bootstrap',
  container: '#addPageFormMessages',
  feedbackIcons: {
    valid: 'glyphicon glyphicon-ok',
    invalid: 'glyphicon glyphicon-remove',
    validating: 'glyphicon glyphicon-refresh'
  },
  fields: {
    name: {
      validators: {
        notEmpty: {message: 'Page Name cannot be empty' },
        regexp: {
          regexp:/^[a-z0-9_-]+$/,
          message: 'Page Name must consist of lowercase letters, numbers, underscores, and dashes'
        }
      }
    },
    label: {
      validators: {
        notEmpty: {message: 'Page Label cannot be empty' }
      }
    }
  }
}).on('success.field.bv', function(e, data) {
  if (data.bv.getInvalidFields().length > 0) {
    data.bv.disableSubmitButtons(true);
  }
}).submit(function(e) {
  if (!e.isDefaultPrevented()) {
    e.preventDefault();
    addPage();
  }
});
</script>

<script>
$('#addCatForm').bootstrapValidator({
  framework: 'bootstrap',
  container: '#addCatFormMessages',
  feedbackIcons: {
    valid: 'glyphicon glyphicon-ok',
    invalid: 'glyphicon glyphicon-remove',
    validating: 'glyphicon glyphicon-refresh'
  },
  fields: {
    name: {
      validators: {
        notEmpty: {message: 'Category Name cannot be empty' },
        regexp: {
          regexp:/^[a-z0-9_-]+$/,
          message: 'Category Name must consist of lowercase letters, numbers, underscores, and dashes'
        }
      }
    },
    label: {
      validators: {
        notEmpty: {message: 'Category Label cannot be empty' }
      }
    }
  }
}).on('success.field.bv', function(e, data) {
  if (data.bv.getInvalidFields().length > 0) {
    data.bv.disableSubmitButtons(true);
  }
}).submit(function(e) {
  if (!e.isDefaultPrevented()) {
    e.preventDefault();
    addCategory();
  }
});
</script>

<script>
$('#editCatForm').bootstrapValidator({
  framework: 'bootstrap',
  container: '#editCatFormMessages',
  feedbackIcons: {
    valid: 'glyphicon glyphicon-ok',
    invalid: 'glyphicon glyphicon-remove',
    validating: 'glyphicon glyphicon-refresh'
  },
  fields: {
    name: {
      validators: {
        notEmpty: {message: 'Category Name cannot be empty' },
        regexp: {
          regexp:/^[a-z0-9_-]+$/,
          message: 'Category Name must consist of lowercase letters, numbers, underscores, and dashes'
        }
      }
    },
    label: {
      validators: {
        notEmpty: {message: 'Category Label cannot be empty' }
      }
    }
  }
}).on('success.field.bv', function(e, data) {
  if (data.bv.getInvalidFields().length > 0) {
    data.bv.disableSubmitButtons(true);
  }
}).submit(function(e) {
  if (!e.isDefaultPrevented()) {
    e.preventDefault();
    editCategory();
  }
});
</script>

<%@ include file="footer.jsp" %>
