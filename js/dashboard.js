function addCategory(url) {
    var parent_id = 2;
    var name = $("#addCatName").val();
    var label = $("#addCatLabel").val();
    var params = {parent_id: parent_id, name: name, label: label};
    console.log(JSON.stringify(params));
    var request = $.ajax({
      url: url,
      type: "post",
      data: params,
      datatype: "json",
      contenttype: "application/x-www-form-urlencoded; charset=utf-8"
    });
    request.done(handleAddCategoryResponse);
}

function handleAddCategoryResponse(response) {
    console.log(JSON.stringify(response));
}
