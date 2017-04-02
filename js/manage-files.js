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
    var parent_id = $('#editCatPicker').val();
    var id = $('#editCatModal').data('trigger');
    var name = $("#editCatName").val();
    var label = $("#editCatLabel").val();
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
    var params = {id: id, name: name, label: label};
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

function handleResponse(response) {
    console.log(JSON.stringify(response));
    if (response.success != undefined) {
        $('.modal').modal('hide');
    }
}
