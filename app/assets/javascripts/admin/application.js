// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require bootstrap-sprockets
//= require metisMenu/jquery.metisMenu.js
//= require pace/pace.min.js
//= require slimscroll/jquery.slimscroll.min.js
//= require jasny/jasny-bootstrap.min.js
//= require datetimepicker/moment-with-locales.min.js
//= require datetimepicker/bootstrap-datetimepicker.min.js
//= require dropzone/dropzone.js
//= require sweetalert/sweetalert.min.js
//= require blueimp/jquery.blueimp-gallery.min.js
//= require iCheck/icheck.min.js
//= require jquery.ui.touch-punch/jquery.ui.touch-punch.min.js
//= require steps/jquery.steps.min.js
//= require admin/inspinia.js

// Override the default confirm dialog by rails
$.rails.allowAction = function(link) {

  // Este es para los confirm, simples
  if (link.data("confirm") != undefined) {
    $.rails.showConfirmationDialog(link);
    return false;
  }

  // Este es para mostrar un diálogo con un prompt para
  // introducir un texto (en principio, sólo para los cambios
  // de estado)
  else if (link.data("prompt") != undefined) {
    $.rails.showPromptDialog(link);
    return false;
  }
  return true;
  
}

//User click confirm button
$.rails.confirmed = function(link){
  link.data("confirm", null);
  link.trigger("click.rails");
}

//Display the confirmation dialog
$.rails.showConfirmationDialog = function(link){
  var message = link.data("confirm");
  var type = link.data("type") || 'warning';

  swal({
    title: message,
    type: type,
    showCancelButton: true,
    allowOutsideClick: true,
    closeOnConfirm: true
  }, 
  function(isConfirm){
    if (isConfirm) {
      $.rails.confirmed(link);
      // Restore message (lost on previous method)
      link.data("confirm", message);
    }
  });
}

//User click confirm button in prompt dialog
$.rails.confirmedPrompt = function(link, paramName, paramValue) {
  link.data("prompt", null);
  // Se añade el parámetro del comentario
  link.attr('href', link.attr('href') + '?' + paramName + '=' + paramValue);
  link.trigger("click.rails");
}

//Display the prompt dialog
$.rails.showPromptDialog = function(link){
  var message = link.data("prompt");
  var type = 'input';
  var text = link.data("text");
  // Cacheo el href para reestablecerlo luego
  var href = link.attr('href');
  var paramName = link.data('param-name');
  var closeOnConfirm = link.data('close-on-confirm') || false;

  swal({
    title: message,
    type: type,
    text: text,
    showCancelButton: true,
    allowOutsideClick: true,
    closeOnConfirm: closeOnConfirm,
    showLoaderOnConfirm: true
  }, 
  function(inputValue){
    // Cancelar
    if (inputValue === false) return false;

    $.rails.confirmedPrompt(link, paramName, inputValue);
    
    // Restore message (lost on previous method)
    link.data("prompt", message);
    // Reestablezco también el href
    link.attr('href', href);
  });
}

$(function() {
  var addLinkCallback = function() {
    $("tr[data-link]").click(function(e) {
      if (e.metaKey){
        window.open($(this).data("link"), '_blank');
      }
      else {
        window.location = $(this).data("link")
      }
    });
  };
  $(function() {
    addLinkCallback();
  });
  $(document).ajaxSuccess(function(e, data, status, xhr) {
    addLinkCallback();
  });

  // Checkboxes  
  $('.i-checks').iCheck({
    checkboxClass: 'icheckbox_square-green'
  });
});