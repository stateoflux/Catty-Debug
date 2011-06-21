$(document).ready(function() {

  var $errorMsg = $('div#error-msgs');  // DOM node where I will append error messages
  var $serialNumInput = $('form#new_r2d2_debug input[type="text"]');
  var $testResult = $('textarea#test_result');

  $errorMsg.hide().empty();

  var validateInput = function($inputField, $helpText) {
  // NOTE: This implementation is not effiecient since each validation test performs a new regex search from the beginning
  // of the text string.  A more efficient inplementation would have each regex search begin where the last one stopped.
  // ALSO: I'd like to investigate converting this code to something that is object oriented.
  // After reading Douglas Crockford's book, I'm realizing that I may be able to combine all the separate regex's into a single
  // expression; this would be the most efficient implementation.
  
    var r2d2Result = $inputField.val();

    /* --- Validation of the r2d2_[6/7] result dump --- */
    //Utility Functions
    var validateText = function (regex, inputString) {
      // Calls the .test method on the regex object passed in from the caller.  
      return regex.test(inputString);  // I may be able to get rid of this variable.
    };

    /*var parseAndExtract = function (regex, inputString) {
      // Calls the .exec method on the regex object passed in from the caller.  The .exec method will check if a portion of the inputString
      // matches the regex; if successful, the method returns an array made up of the matched segments of the inputString.  If no match
      // is found the method returns null.
      var extracted = regex.exec(inputString);  // I may be able to get rid of this variable.
      return extracted ? extracted[1] : -1; 
    };*/

    /*var validateDataRead = function (inputString) {
       var memData = parseAndExtract(/Da[\w]+\sRe[\w]+[\s]+:[\s]+0x\s(([\da-f]{4}\s+)+)/, inputString);
       memData = memData.split(/[\s]+/);
       memData = memData.slice(0, memData.length - 1);  // To remove the trailing white space character
       if (memData.length != 36) {      
           return -1;
       }
    };*/

    if ($inputField.val().length === 0) {
       $helpText.html("<p>Looks like you forgot to paste your R2D2_[6/7] test results.");
       return false;
    }
    else {
       // Validate that "R2D2_[6/7] test description" string is present
       if (!validateText(/R2D2_(?:6|7)/, r2d2Result)) {
         $helpText.html("<p>Could not find R2D2_ test description</p>");
         return false;
       }
       // Validate that R2D2_[6/7] test error is a data miscompare
       if (!validateText(/Er[\w]+\sCo[\w]+[\s]+:[\s]+(?:26)/, r2d2Result)) {
         $helpText.html("<p>The R2D2_ test error is not 'Data Miscompare'</p>");
         return false;
       }
       // Validate that "Data Pattern string is present
       if (!validateText(/Da[\w]+\sPa[\w]+[\s]+:[\s]+0x(?:\d{2})/, r2d2Result)) {
         $helpText.html("<p>Missing Data Pattern?</p>");
         return false;
       }
       // Validate that "Device Number" string is present
       if (!validateText(/De[\w]+\sNu[\w]+[\s]+:[\s]+(?:[1-8])/, r2d2Result)) {
         $helpText.html("<p>Missing Device Number?</p>");
         return false;
       }
       /*if (!validateText(/\sData\sRead\s+?:\s0x\s((?:(?:\d|[abcdef]){4,4}\s){11,11})[\n\r]\s+?((?:(?:\d|[abcdef]){4,4}\s){11,11})[\n\r]\s+?((?:(?:\d|[abcdef]){4,4}\s){11,11})[\n\r]\s+?((?:(?:\d|[abcdef]){4,4}\s){3,3}/, r2d2Result)) {
         $helpText.html("<p>Something is wrong with Data Read text?</p>");
         return false;
       }*/
       // Need to investigate why the final \s+ expression works in terms of capturing the newline chars?
       /*if (!validateDataRead(r2d2Result) === -1) {
         $helpText.html("<p>Something is wrong with Data Read text?</p>");
         return false;
       }*/
    }
    return 1; 
  }; // end of validateInput

  /*---------------------------------------------------------------------------
   * USER INFO VALIDATION
   *--------------------------------------------------------------------------*/
  // Validate the text fields of the user info form 
  $text_input = $('#new_user fieldset input[type="text"]');

  $text_input.blur(function() {
    // Remove any previous error messages
    $(this).removeClass('validate-fail-border');
    $(this).parent()
      .find('span')
      .remove();
    $(this).parent()
      .find('p')
      .remove();

    // test for empty string
    if (this.value == '') {
      $(this).addClass('validate-fail-border');
      $('<p></p>')
        .addClass('validate-fail')
        .text("This is a required field")
        .appendTo($(this).parent()); 
    }
    
    // Test email field
    // how would I be able to verify if the email address has been 
    // taken already??
    else if ($(this).attr('id') == 'user_email') {
      if (/^[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}$/i.test(this.value)) {
      //if (/^\w{2,8}@cisco.com$/.test(this.value)) {
        $('<span></span>')
          .addClass('validate-pass')
          .text("OK")
          .appendTo($(this).parent());
      }
      else {
        $('<span></span>')
          .addClass('validate-fail')
          .text("This input has the wrong format")
          .appendTo($(this).parent());
      }
    }
    // test name fields for correct format
    // (starts with letter, greater than one char)
    else {
      if (/\w{2,}/.test(this.value)) {
        $('<span></span>')
          .addClass('validate-pass')
          .text("OK")
          .appendTo($(this).parent());
      }
      else {
        $(this).addClass('validate-fail-border');
        $('<p></p>')
          .addClass('validate-fail')
          .text("Name has to begin with a letter and be longer than one char.")
          .appendTo($(this).parent()); 
      }
    }
  });

  $('form.user-form').submit(function(event) {
    // Remove any prior submit error messages
    $('p#submit-message').remove();
    // re-trigger the blur events on all of the form elements
    $text_input.trigger('blur');
      // if errors add error message
      if ($('.validate-fail').length) {
        event.preventDefault();
        $('<p></p>')
        .attr('id', 'submit-message')
        .addClass('validate-fail')
        .text('Please correct the errors above')
        .insertAfter('.actions');
      }
  });


  /*---------------------------------------------------------------------------
   * DEBUG SESSION INPUT VALIDATION
   *--------------------------------------------------------------------------*/
  // Check to see if a board was selected from pulldown menu
  $('select').change(function() {
    // Removes previous error messages
    $(this).parent()
      .find('span')
      .remove();

    if ($('select').val() === '') {
      $('<span></span>')
        .addClass('validate-fail')
        .text("You haven't chosen a board")
        .appendTo($(this).parent());
      return false;
    }
    else {
      $('<span></span>')
        .addClass('validate-pass')
        .text('OK')
        .appendTo($(this).parent());
    }
  });

  // Validate that S/N field is not blank
  $serialNumInput.blur(function() {
    $(this).removeClass('validate-fail-border');
    $(this).parent()
      .find('span')
      .remove();
    if (this.value === '') {
      $(this).addClass('validate-fail-border');
      $('<span></span>')
        .addClass('validate-fail')
        .text("This is a required field")
        .appendTo($(this).parent());
    }
    // Validate S/N entered is the correct format
    else {
      if (/^SA[A-Z]{1,1}[A-Z0-9]{8,9}$/.test(this.value)) {
        $('<span></span>')
          .addClass('validate-pass')
          .text('OK')
          .appendTo($(this).parent());
      }
      else {
        $('<span></span>')
          .addClass('validate-fail')
          .text('You entered a S/N with an incorrect format')
          .appendTo($(this).parent());
      }
    }
  });

  // Validate r2d2_[6/7] input and if error free, submit form.
  $testResult.change(function() {
    $errorMsg.hide().empty();
    validateInput($(this), $errorMsg);
    // Validation successfull
    if ($errorMsg.find('p').length === 0) { 
    }
    // Validation failed
    else { 
      $errorMsg.append("<span>You will have to fix the error above before you can submit this form</span><br />"); 
      $errorMsg.fadeIn('fast');
    }
  }); // end of validator


  $('form#new_r2d2_debug').submit(function(event) {
    // re-trigger blur events on form elements
    $('select').trigger('change');
    if (!$serialNumInput.trigger('blur')) {
      event.preventDefault();
    }
    $testResult.trigger('blur');
    if ($('.validate-fail').length || $errorMsg.text() != '') {
      event.preventDefault();
    }
  });
});

