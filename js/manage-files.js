function addNode() {
    var key = $('#addNodeTabs li.active').text();
    if (key == 'Add Category') {
        addCat();
    } else if (key == 'Add Page') {
        addPage();
    } else {
        console.log('Unknown key for addNode!');
    }
}

function addCat() {
    var parent_id = $('#addNodeModal').data('trigger');
    var name = $("#addCatName").val();
    var label = $("#addCatLabel").val();
    var params = {parent_id: parent_id, name: name, label: label};
    console.log(JSON.stringify(params));
    var request = $.ajax({
      url: addCatURL,
      type: "post",
      data: params,
      datatype: "json",
      contenttype: "application/x-www-form-urlencoded; charset=utf-8"
    });
    request.done(handleResponse);
}

function delCat() {
    var id = $('#delCatModal').data('trigger');
    var params = {id: id};
    console.log(JSON.stringify(params));
    var request = $.ajax({
      url: delCatURL,
      type: "post",
      data: params,
      datatype: "json",
      contenttype: "application/x-www-form-urlencoded; charset=utf-8"
    });
    request.done(handleResponse);
}

function editCat() {
    var id = $('#editCatModal').data('trigger');
    var name = $("#editCatName").val();
    var label = $("#editCatLabel").val();
    var parent_id = $('#editCatPicker').val();
    if (parent_id == null) {
      parent_id = 'null';
    }
    var params = {id: id, name: name, label: label, parent_id: parent_id};
    console.log(JSON.stringify(params));
    var request = $.ajax({
      url: editCatURL,
      type: "post",
      data: params,
      datatype: "json",
      contenttype: "application/x-www-form-urlencoded; charset=utf-8"
    });
    request.done(handleResponse);
}

function addPage() {
    var parent_id = $('#addNodeModal').data('trigger');
    var name = $("#addPageName").val();
    var label = $("#addPageLabel").val();
    var params = {parent_id: parent_id, name: name, label: label};
    console.log(JSON.stringify(params));
    var request = $.ajax({
      url: addPageURL,
      type: "post",
      data: params,
      datatype: "json",
      contenttype: "application/x-www-form-urlencoded; charset=utf-8"
    });
    request.done(handleResponse);
}

function editPage() {
    var id = $('#editPageModal').data('trigger');
    var name = $("#editPageName").val();
    var label = $("#editPageLabel").val();
    var content = ace.edit("editPageEditor").getSession().getValue();
    var parent_id = $('#editPagePicker').val();
    var params = {id: id, name: name, label: label, content: content, parent_id: parent_id};
    console.log(JSON.stringify(params));
    var request = $.ajax({
      url: editPageURL,
      type: "post",
      data: params,
      datatype: "json",
      contenttype: "application/x-www-form-urlencoded; charset=utf-8"
    });
    request.done(handleResponse);
}

function delPage() {
    var id = $('#delPageModal').data('trigger');
    var params = {id: id};
    console.log(JSON.stringify(params));
    var request = $.ajax({
      url: delPageURL,
      type: "post",
      data: params,
      datatype: "json",
      contenttype: "application/x-www-form-urlencoded; charset=utf-8"
    });
    request.done(handleResponse);
}

function getPageContent() {
    var id = $('#editPageModal').data('trigger');
    var params = {id: id};
    console.log(JSON.stringify(params));
    var request = $.ajax({
      url: getPageContentURL,
      type: "post",
      data: params,
      datatype: "json",
      contenttype: "application/x-www-form-urlencoded; charset=utf-8"
    });
    request.done(handleGetPageContentResponse);
}

function editSettings() {
    var site_label = $("#siteLabel").val();
    var main_page_content = ace.edit("mainPageContent").getSession().getValue();
    var head_snippet = ace.edit("headSnippet").getSession().getValue();
    var foot_snippet = ace.edit("footSnippet").getSession().getValue();
    var params = {site_label: site_label,
                  main_page_content: main_page_content,
                  head_snippet: head_snippet,
                  foot_snippet: foot_snippet}
    console.log(JSON.stringify(params));
    var request = $.ajax({
      url: editSettingsURL,
      type: "post",
      data: params,
      datatype: "json",
      contenttype: "application/x-www-form-urlencoded; charset=utf-8"
    });
    request.done(handleResponse);
}

function handleResponse(response) {
    console.log(JSON.stringify(response));
    if (response.success != undefined) {
        location.reload();
    } else if (response.error != undefined) {
        $('.modal-body').prepend($('<div/>').addClass('alert').addClass('alert-danger').text(response.error));
    }
}
function handleGetPageContentResponse(response) {
    console.log(JSON.stringify(response));
    if (response.content != undefined) {
        ace.edit("editPageEditor").getSession().setValue(response.content);
    } else if (response.error != undefined) {
        $('.modal-body').prepend($('<div/>').addClass('alert').addClass('alert-danger').text(response.error));
    }
}
