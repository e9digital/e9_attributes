;jQuery(function($) {

  /*
   * change the value of the new menu option type link when the scope select
   * changes, e.g. when viewing "Email" menu options, clicking "Add Menu Option"
   * defaults to creating a new email menu option.
   */
  $('body.admin a.new-menu-option').bind('scope-select:change:key', function(e, v) {
    $(this).attr('href', function(i, val) {
      return val.replace(/\[key\]=([^&]*)/, '[key]='+encodeURIComponent(v));
    });
  });

  /*
   * Adds a new nested assocation.  Depends on the nested association
   * js templates being loaded.
   */
  $('a.add-nested-association').click(function(e) {
    e.preventDefault();

    var template;

    // get the template for this attribute type
    try { 
      template = E9CRM.js_templates[this.getAttribute('data-association')];
    } catch(e) { return }

    // sub in the current index and increment it
    template = template.replace(
      new RegExp(E9CRM.js_templates.start_child_index, 'g'), 
      ++E9A.js_templates.current_child_index
    );

    // and insert the new template before this link
    $(template).insertBefore($(this));
  });

  /*
   * Effectively destroys an added nested association, removing the container
   * the association is not persisted, or hiding it and setting the _destroy
   * parameter for the association if it is.
   */
  $('a.destroy-nested-association').live('click', function(e) {
    e.preventDefault();

    // grab the parent nested-association and attempt to get its hidden
    // 'destroy' input if it exists.
    var $parent = $(this).closest('.nested-association').hide(),
        $destro = $parent.find('input[id$=__destroy]');

    // If a in input ending in __destroy was found it means that this is a
    // persisted record.  Set that input's value to '1' so it will be destroyed
    // on record commit.
    if ($destro.length) { $destro.val('1'); }

    // otherwise this record was created locally and has not been saved, so
    // simply remove it.
    else { $parent.remove(); }
  });
});
