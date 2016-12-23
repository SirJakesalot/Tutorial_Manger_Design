var plus_counter = 0;
var info_counter = 0;
var trash_counter = 0;

$(function () {
  $('.tree li:has(ul)').addClass('parent_li').find(' > span').attr('title', 'Collapse this branch');
  $('.tree li.parent_li > span').on('click', function (e) {
    var children = $(this).parent('li.parent_li').find(' > ul > li');
    if (children.is(":visible")) {
      children.hide('fast');
      $(this).attr('title', 'Expand this branch').find(' > i').addClass('glyphicon-folder-close').removeClass('glyphicon-folder-open');
    } else {
      children.show('fast');
      $(this).attr('title', 'Collapse this branch').find(' > i').addClass('glyphicon-folder-open').removeClass('glyphicon-folder-close');
    }
      e.stopPropagation();
  });

  var btn_group = $('<div/>')
                    .addClass('pull-right btn-group btn-group-sm')
                    .append(
                      $('<button/>')
                        .addClass('btn btn-success')
                        .click(func_plus)
                        .append(
                          $('<i/>')
                            .addClass('glyphicon glyphicon-plus')
                        )
                    )
                    .append(
                      $('<button/>')
                        .addClass('btn btn-info')
                        .click(func_info)
                        .append(
                          $('<i/>')
                            .addClass('glyphicon glyphicon-edit')
                        )
                    )
                    .append(
                      $('<button/>')
                        .addClass('btn btn-danger')
                        .click(func_trash)
                        .append(
                          $('<i/>')
                            .addClass('glyphicon glyphicon-trash')
                        )
                    );
  $('.tree li a').after(btn_group);
});

function func_plus() {
  plus_counter += 1;
  console.log("clicked plus button " + plus_counter + " times");
}
function func_info() {
  info_counter += 1;
  console.log("clicked info button " + info_counter + " times");
}
function func_trash() {
  trash_counter += 1;
  console.log("clicked trash button " + trash_counter + " times");
}
