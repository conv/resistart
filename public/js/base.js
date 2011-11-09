$(document).ready(function() {

  $('.alert-message').click(function() {
    $('.alert-message').hide('fast');
    $('fieldset.url').addClass('error');
  });

  $('.form-stacked').validate();
  $('input[name="newurl"]').attr('disabled', 'disabled');
  $('input[type="url"]').change(function() {
      if($(this).valid()) {
        $('input[name="newurl"]').removeAttr('disabled');
      }
      else {
        $('input[name="newurl"]').attr('disabled', 'disabled');
      }
  });

});
