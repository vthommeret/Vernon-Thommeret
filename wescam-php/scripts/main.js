$(document).ready(function() {
    $('#focus').focus();
    
    $('#crushee').focus();
    
    $('#add_someone').submit(function() {
        var crushee = $('#crushee').val();
        
        if (crushee == '')
            return false;
        
        $('#crushee').attr("disabled","disabled");
        $('#crushee').addClass('disabled');
        $('#add').attr("disabled","disabled");
        $('#add').css('display', 'none')
        $('#load').css('display', 'inline');
        
        $.post($('#wc_site').val() + 'add_someone/', {crushee: crushee},
            function(data) {
                if (data.error) {
                    $('#crushee').removeAttr("disabled");
                    $('#crushee').removeClass('disabled');
                    $('#add').removeAttr('disabled')
                    $('#add').css('display', 'inline')
                    $('#load').css('display', 'none');
                    alert(data.error);
                    $('#crushee').select();
                } else {
                    var successful_match = data.successful_match;
                
                    var listItem = $('#crushee').parent();
                    var orderedList = listItem.parent();
                    
                    var heart = '';
                    if (successful_match) {
                        listItem.addClass('match');
                        heart = ' &hearts;';
                        
                        var matchedRow = $('#crusher_' + successful_match);
                        matchedRow.html(data.name + heart);
                        matchedRow.addClass('match');
                    }
                    
                    // prevent mini jump
                    
                    var cloned = orderedList.clone();
                    cloned.attr('id', 'doubleBuffer');
                    $('li:first', cloned).html(data.name + heart);
                    cloned.insertAfter(orderedList);
                    
                    var diff1 = cloned.outerHeight() - orderedList.outerHeight();
                    cloned.remove();
                    
                    $('#crushee').remove();
                    $('#load').remove();
                    $('#add').remove();
                    listItem.html(data.name + heart);

                    orderedList.css('position', 'relative');                    
                    orderedList.css('top', (-1 * diff1) + 'px');

                    // slide down and fade in... mmmm good.
                    setTimeout(function() {
                        var num = $('li', orderedList).size() + 1;
                        var newRow = '<li style="visibility: hidden" value="' + num + '"><input id="crushee" class="text" type="text" maxlength="12" size="12" type="text" /> <img src="/images/load.gif" id="load" alt="" /> <input type="submit" disabled="disabled" value="add username" id="add" /></li>';
                        
                        var cloned = orderedList.clone();
                        cloned.attr('id', 'doubleBuffer');
                        cloned.prepend(newRow);
                        cloned.insertAfter(orderedList);
                        
                        var diff2 = cloned.outerHeight() - orderedList.outerHeight()
                        
                        cloned.remove();
                        
                        orderedList.prepend(newRow);
    
                        $('#crushee').keyup(function() {
                            var contents = $(this).val();
                            var submit = $('#add');
                    
                            if (contents == '')
                                submit.attr('disabled', 'disabled')
                            else
                                submit.attr('disabled', '')
                        });
    
                        orderedList.css('position', 'relative');                    
                        orderedList.css('top', '-' + (diff2 + diff1) + 'px');
                        
                        orderedList.animate({top: 0}, 300, function() {
                            $('li:first', orderedList).css('opacity', '0');
                            $('li:first', orderedList).css('visibility', 'visible');
                            $('li:first', orderedList).animate({opacity: 1}, 300);
                            $('#crushee').focus();
                        });
                    }, 350);
                    
                    if (successful_match)
                        alert("Holy shit!! " + data.name + " likes you, too! We've already sent the e-mail. Have fun!");
                }
            }, 'json'
        );

        return false;
    });

    $('#crushee').keyup(function() {
        var contents = $(this).val();
        var submit = $('#add');

        if (contents == '')
            submit.attr('disabled', 'disabled')
        else
            submit.attr('disabled', '')
    });

    $('#message textarea').keyup(function() {
        var contents = $(this).val();
        var submit = $('input[type=submit]', $(this).parent());
        
        if (contents == '')
            submit.attr('disabled', 'disabled')
        else
            submit.attr('disabled', '')
    });
});
