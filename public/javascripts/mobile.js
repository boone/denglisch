var jQT = new $.jQTouch({debug: true});

$(function () {
	$('#search_form').submit(function() {
		
		$('#instructions').hide();
		$('#searching').show();
		
		$form = $(this);
		
		// call the server to search
    $.ajax({
      type: $form.attr('method'),
			url: $form.attr('action'),
      dataType: 'html',
			data: $form.serialize(),
			success: function(data) {
				// replace the search_results div with the content
				$('#search_results').html(data);
				$('#searching').hide();
				$('#search_results').show();
			},
			error: function() {
				alert('There was an error communicating with the server. Please try again.');
			}
  	});    
		
		$('#search_button').focus(); // set focus to submit button to hide keyboard
		
    return false;
	});
});