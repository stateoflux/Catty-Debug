$(document).ready(function() {

  var validateInput = function($inputField, $helpText) {
  // NOTE: This implementation is not effiecient since each validation test performs a new regex search for the beginning
  // of the text string.  A more efficient inplementation would have each regex search begin where the last one stopped.
  // ALSO: I'd like to investigate converting this code to something that is object oriented.
  // After reading Douglas Crockford's book, I'm realizing that I may be able to combine all the separate regex's into a single
  // expression; this would be the most efficient implementation.
  
    var r2d2Result = $inputField.val();

    /* --- Validation of the r2d2_[6/7] result dump --- */
    //Utility Functions
    var parseAndExtract = function (regex, inputString) {
      // Calls the .exec method on the regex object passed in from the caller.  The .exec method will check if a portion of the inputString
      // matches the regex; if successful, the method returns an array made up of the matched segments of the inputString.  If no match
      // is found the method returns null.
      var extracted = regex.exec(inputString);  // I may be able to get rid of this variable.
      return extracted ? extracted[1] : -1; 
    };

    var validateDataRead = function (inputString) {
       var memData = parseAndExtract(/Da[\w]+\sRe[\w]+[\s]+:[\s]+0x\s(([\da-f]{4}\s+)+)/, inputString);
       memData = memData.split(/[\s]+/);
       memData = memData.slice(0, memData.length - 1);  // To remove the trailing white space character
       if (memData.length != 36) {      
           return -1;
       }
    };

    if ($inputField.val().length === 0) {
       $helpText.html("<p>Looks like you forgot to paste your R2D2_[6/7] test results.");
       return false;
    }
    else {
       // Validate that "R2D2_[6/7] test description" string is present
       if (parseAndExtract(/R2D2_(6|7)/, r2d2Result) === -1) {
         $helpText.html("<p>Could not find R2D2_ test description</p>");
         return false;
       }
       // Validate that R2D2_[6/7] test error is a data miscompare
       if (parseAndExtract(/Er[\w]+\sCo[\w]+[\s]+:[\s]+(26)/, r2d2Result) === -1) {
         $helpText.html("<p>The R2D2_ test error is not 'Data Miscompare'</p>");
         return false;
       }
       // Validate that "Data Pattern string is present
       if (parseAndExtract(/Da[\w]+\sPa[\w]+[\s]+:[\s]+0x(\d{2})/, r2d2Result) === -1) {
         $helpText.html("<p>Missing Data Pattern?</p>");
         return false;
       }
       // Validate that "Device Number" string is present
       if (parseAndExtract(/De[\w]+\sNu[\w]+[\s]+:[\s]+([1-8])/, r2d2Result) === -1) {
         $helpText.html("<p>Missing Device Number?</p>");
         return false;
       }
       // Need to investigate why the final \s+ expression works in terms of capturing the newline chars?
       if (validateDataRead(r2d2Result) === -1) {
         $helpText.html("<p>Something is wrong with Data Read text?</p>");
         return false;
       }
    }
    return 1; 
  }; // end of validateInput

  // BUILDS THE RESULT TABLE BASED ON THE RESPONSE FROM THE SERVER
  var buildResultView = function(result) {
    var summaryText = "<h3>Debug Summary</h3>" + 
                       "<p>" + result["bad-bits"].length + " defective bits were found and have been highlighted below:</p>";
    $.each(result["summary-frag"], function(i, line) {
        summaryText += line;
    });
    summaryText += "<p>Please refer to the table below for a mapping between the defective bit and the memory device</p>";

    var mappingTable = "<h3>Mapping Table</h3>" +
                       "<table cellspaing='0'>" +    // Using the cellspacing attribute is the most bulletproof method 
                                                     // for zeroing out the spacing between table cells
                       "<thead>" +
                       "<tr><th scope='col'>Bad Bit</th><th scope='col'>Ref Des</th><th>Mem Device #</th><th>Cycle</th><th>Clock Edge</th></tr>" +
                       "</thead><tbody>";

    $.each(result["bad-bits"], function(i, badBit) {
      var row = "<tr>";
      if ((i % 2) != 0) {
        console.log(i);
        row = "<tr class='odd'>";
      }
      mappingTable += row + "<td>" + badBit['bit'] + "</td><td>" + badBit['refdes'] + "</td><td>" + 
      badBit['dev-num'] + "</td><td>" + badBit['cycle'] + "</td><td>" + badBit['edge'] + "</td></tr>";
      return result;
    });

      mappingTable += "</tbody></table>";
     $('#summary').html(summaryText);
     $('#results').html(mappingTable);
  }; 
  var projectNameMap = {
    "ringar-3": "Ringar",
    "ringar-5": "Ringar",
    "heathland-6": "Heathland",
    "heathland-7": "Heathland",
    "sup2t-1": "Sup-2T"
  };
  var boardSerNum = '';
  var projectName = '';
  var boardAssyNum = '73-11111-01';
  /*---------------------------------------------------------------------------
   * DATA INPUT SECTION
   *--------------------------------------------------------------------------*/
  // Validate r2d2_[6/7] input and if error free, submit form.
  $('.console-input').submit(function(event) {
    event.preventDefault();
    var $statusMsg = $('#status');
    var projName = $(this).find('select option:selected').val();
    //console.log($(this).find('select option:selected').val());

    $statusMsg.hide().empty();
    projectName = projectNameMap[projName];
    validateInput($('.console-input textarea'), $statusMsg);
    // Validation successfull
    if ($statusMsg.find('p').length === 0) { 
      
      // send ajax call to server side script with r2d2_[6/7] result dump as a parameter
      //$.get('findDevices.r', $(this).serialize(), function(data) {
        // Callback to generate the "view" based on the JSON object returned from server side script
      //}
      $.getJSON('results.json', function(json) {
        buildResultView(json); 
      })
      // slide up the entire form
      $(this).parent().andSelf().fadeOut('fast', function() {
        // Slide down results section
        $(this).siblings('.results-container')
        .fadeIn('slow', function() {
          $('.add-2-db, .rework-request').hide();  // Will update this when I have time.  the hide after the fade cause a weird redraw!!
        });
      });
    }
    // Validation failed
    else { 
      $statusMsg.append("<span>You will have to fix the error above before you can submit this form</span><br />"); 
      $statusMsg.fadeIn('fast');
    }
  });

  /*---------------------------------------------------------------------------
   * RESULTS SECTION
   *--------------------------------------------------------------------------*/

  // Display add to db form
  $('#add-board').click(function() {
      //event.preventDefault();
      $('.add-2-db').slideDown();
      return false;
  });
  // Since these forms have similar behavior I should look into make the code a plugin
  // Add board to database
  $('form.add-2-db').submit(function(event) {
      event.preventDefault();
      // I should validate that the input is in the correct format (SAD\D{??})
      var serNum = $(this).find('input:text').val().toLocaleUpperCase();
      boardSerNum = serNum;
      if (/SAD\d{6,7}\w{2}/.test(serNum)) {
        // Ajax call to server.  Use progressive enhancement!!!!
        //$.post('cat6k_debug.r', {'ser-num' : ser_num ......})
        $(this).slideUp('fast');
        // Change request message to a success message 
        $(this).siblings('p').eq(0)
        .html(serNum + " has been saved to the database.  Thanks!")
        .css({'background-color': '#fce978', 'padding': '6px'});
      }
      else {
        $(this).children('span').html("Wrong format").addClass('validate-fail');
      }
  });

  /*--------------------------------------------------------------------------
   * Rework request form logic
   *-------------------------------------------------------------------------*/
  // Display Rework request form
  $('#rwk').click(function(event) {
      $('.rework-request').slideDown()
      .find(':input').each(function() {
        if ($(this).is('#proj-name')) {
          this.value = projectName;
        }
        else if ($(this).is('#assy-num')) {
          this.value = boardAssyNum;
        }
        else if ($(this).is('#ser-num1')) {
          if (boardSerNum) {
            this.value = boardSerNum;
          }
        }
      });
      return false
  });

  var $rwkInputs = $('.rework-request td :input');
  // Remove the default text when user clicks within input element
  $rwkInputs.click(function() {
      var defaultVal = this.value;
      this.value = '';
  });
  // Validate the text fields of the rework request form 
  //$('.rework-request td :input').blur(function() {
  $rwkInputs.blur(function() {
    var $td = $(this).parent('td');
    $td.find('span').remove();
    // test for empty string
    if (this.value == '') {
      $('<span></span>').addClass('validate-fail').text("This is a required field").appendTo($td); 
    }
    else if ($(this).is('#email')) {
      if (/\w{8}/.test(this.value)) {
        $('<span></span>').addClass('validate-pass').text("OK").appendTo($td);
      }
      else {
        $('<span></span>').addClass('validate-fail').text("This input has the wrong format").appendTo($td);
      }
    }
    else if ($(this).is('#ser-num1')) {
      if (/SAD\d{6,7}\w{2}/.test($(this).val().toLocaleUpperCase())) {
        $('<span></span>').addClass('validate-pass').text("OK").appendTo($td);
      }
      else {
        $('<span></span>').addClass('validate-fail').text("Input is the wrong format").appendTo($td);
      }
    }
  });
  $('form.rework-request').submit(function(event) {
      event.preventDefault();
      // Validation 
      // re-trigger the blur events on all of the form elements
      // Ajax call to server.  Use progressive enhancement!!!!
      //$.post('cat6k_debug.r', $(this).serialize(), function() {})
      $(this).slideUp('slow');
      // Change request message to a success message 
      $(this).prev('p')
      .html("Your rework request has been sent. Thanks!")
      .css({'background-color': '#fce978', 'padding': '6px'});
  });
});


