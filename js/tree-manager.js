function getCrumbs(pos) {
  var node = $(pos).parent().prev();
  var crumbs = [];
  crumbs.push($(node).text().trim());
  while (crumbs[crumbs.length-1]) {
    node = $(node).parent().parent().prev().prev().prev();
    crumbs.push($(node).text().trim());
  }
  crumbs.pop();
  return crumbs.reverse();
}

var lineage = [{name: 'Fundamentals',
                subcats: [{name: 'Algorithms',
                           subcats: ['Sorting','Computing','Misc']},
                          {name: 'Data Structures',
                           subcats: ['Basic', 'Trees', 'Misc']}]},
               {name: 'Languages',
                subcats: [{name: 'Java',
                           subcats: ['Bult-Ins', '3rd Party Libs']},
                          {name: 'Python',
                           subcats: ['Bult-Ins', '3rd Party Libs']}]}];

var ind = -1;
var categories = $('<select/>').addClass('selectpicker').append($('<option/>').val(ind++).text('None'));
for(var x = 0; x < lineage.length; ++x) {
  categories.append($('<option/>').val(ind++).text(lineage[x].name));
  for(var y = 0; y < lineage[x].subcats.length; ++y) {
    categories.append($('<option/>').val(ind++).text(lineage[x].name + ' / ' + lineage[x].subcats[y].name));
    /*
    for(var z = 0; z < lineage[x].subcats[y].subcats.length; ++z) {
      categories.append($('<option/>').val(ind++).text(lineage[x].name + ' / ' + lineage[x].subcats[y].name + ' / ' + lineage[x].subcats[y].subcats[z]));
    } */
  }
}

function genCatBtnGrp() {
  return $('<div/>')
           .addClass('pull-right btn-group btn-group-sm')
           .append(
             $('<button/>')
               .addClass('btn btn-success')
               .attr("data-toggle", "modal")
               .attr("data-target", "#addCatModal")
               .click(addCat)
               .append($('<i/>').addClass('glyphicon glyphicon-plus')))
           .append(
             $('<button/>')
               .addClass('btn btn-info')
               .attr("data-toggle", "modal")
               .attr("data-target", "#editCatModal")
               .click(editCat)
               .append($('<i/>').addClass('glyphicon glyphicon-edit')))
           .append(
             $('<button/>')
               .addClass('btn btn-danger')
               .attr("data-toggle", "modal")
               .attr("data-target", "#delCatModal")
               .click(delCat)
               .append($('<i/>').addClass('glyphicon glyphicon-trash')));
}

function genSubCatBtnGrp() {
  return $('<div/>')
           .addClass('pull-right btn-group btn-group-sm')
           .append(
             $('<button/>')
               .addClass('btn btn-success')
               .attr("data-toggle", "modal")
               .attr("data-target", "#addTutModal")
               .click(addTut)
               .append($('<i/>').addClass('glyphicon glyphicon-plus')))
           .append(
             $('<button/>')
               .addClass('btn btn-info')
               .attr("data-toggle", "modal")
               .attr("data-target", "#editCatModal")
               .click(editCat)
               .append($('<i/>').addClass('glyphicon glyphicon-edit')))
           .append(
             $('<button/>')
               .addClass('btn btn-danger')
               .attr("data-toggle", "modal")
               .attr("data-target", "#delCatModal")
               .click(delCat)
               .append($('<i/>').addClass('glyphicon glyphicon-trash')));
}
function genTutBtnGrp() {
  return $('<div/>')
           .addClass('pull-right btn-group btn-group-sm')
           .append(
             $('<button/>')
               .addClass('btn btn-info')
               .attr("data-toggle", "modal")
               .attr("data-target", "#editTutModal")
               .click(editTut)
               .append($('<i/>').addClass('glyphicon glyphicon-edit')))
           .append(
             $('<button/>')
               .addClass('btn btn-danger')
               .attr("data-toggle", "modal")
               .attr("data-target", "#delTutModal")
               .click(delTut)
               .append($('<i/>').addClass('glyphicon glyphicon-trash')));
}

function addCat(event) {
  console.log('addCat');
  $('#addCatModal div.modal-body ol.breadcrumb').empty();
  $.each(getCrumbs(this), function(index, val) {
    $('#addCatModal div.modal-body ol.breadcrumb')
      .append(
        $('<li/>')
        .addClass('breadcrumb-item')
        .append(
          $('<a/>')
            .attr('href', '#')
            .text(val)));
  });
}

function editCat(event) {
  console.log('editCat');

  var crumbs = getCrumbs(this);
  var lastCrumb = crumbs.pop();
  var txt = crumbs.join(' / ');
  var catval = $('#editCatModal div.modal-body div.input-group select.selectpicker option')
                 .filter(function () { return $(this).html() == txt;}
               ).val();
  console.log(catval);
  if (catval == null) { catval = '-1'; }
  $('#editCatModal div.modal-body div.input-group select.selectpicker').val(catval);
}

function delCat(event) {
  console.log("delCat");
  $('#delCatModal div.modal-body ol.breadcrumb').empty();
  $.each(getCrumbs(this), function(index, val) {
    $('#delCatModal div.modal-body ol.breadcrumb')
      .append(
        $('<li/>')
        .addClass('breadcrumb-item')
        .append(
          $('<a/>')
            .attr('href', '#')
            .text(val)));
  });
}

function addTut(event) {
  console.log('addTut');
  $('#addTutModal div.modal-body ol.breadcrumb').empty();
  $.each(getCrumbs(this), function(index, val) {
    $('#addTutModal div.modal-body ol.breadcrumb')
      .append(
        $('<li/>')
        .addClass('breadcrumb-item')
        .append(
          $('<a/>')
            .attr('href', '#')
            .text(val)));
  });
}

function editTut(event) {
  console.log("editTut");
  var crumbs = getCrumbs(this);
  //var lastCrumb = crumbs.pop();
  var txt = crumbs.join(' / ');
  var catval = $('#editTutModal div.modal-body div.input-group select.selectpicker option')
                 .filter(function () { return $(this).html() == txt;}
               ).val();
  console.log(catval);
  if (catval == null) { catval = '-1'; }
  $('#editTutModal div.modal-body div.input-group select.selectpicker').val(catval);
}
function delTut(event) {
  console.log("delTut");
}
function addCatReq(event) {
  console.log("addCatReq");
}
function editCatReq(event) {
  console.log("editCatReq");
}
function delCatReq(event) {
  console.log("delCatReq");
}
function addTutReq(event) {
  console.log("addTutReq");
}
function editTutReq(event) {
  console.log("editTutReq");
}
function delTutReq(event) {
  console.log("delTutReq");
}
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
  var subCats = $('#tree > ul > li.parent_li > ul > li.parent_li > ul > li.parent_li > span > i.glyphicon-folder-open').parent();
  subCats.after(genSubCatBtnGrp());
  $('.glyphicon-folder-open').parent().not(subCats).after(genCatBtnGrp());
  $('.glyphicon-leaf').parent().after(genTutBtnGrp());

  var editor = ace.edit("editor");
  editor.getSession().setMode("ace/mode/sh");
  editor.setOptions({maxLines: 15});
});
