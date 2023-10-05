import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    var searchRequest = null;
    var debounceTimeout = null;
    $(".search-labels").each(function(index) {
        var searchEvents = $('.search-labels-'+index).on('keyup', function(event) {
            $(".search-labels-result-wrapper").empty();
            $(".search-labels-result-wrapper").removeClass('hidden')
            //only display search when search bar not empty
            if( $(this).val().length > 0 ) {
                // Reseting resquests
                if (searchRequest) {
                searchRequest.abort()
                }
              searchRequest = $.get('/search_labels', {search_label: $(this).val()}, function(data, status) {
                    $.each(data, function(k,v) {
                        $(".search-labels-result-wrapper-" + index).append(`<div class="border p-2 hover:bg-slate-200 hover:cursor-pointer" data-action="click->fuzzy-search#selectLabel" data-fuzzy-search-id-param="${index}">${v}</div>`)
                    });
                }, 'json')
            }
        });
        // set time out to minimize db requests
        $('.search-lables').on('keyup', function(event){
            clearTimeout(debounceTimeout);
            debounceTimeout = setTimeout('', 500);
            if( $(this).val().length === 0 ) {
                $(".search-result-wrapper").addClass('hidden')
            }
        });
    })
   
  }

  selectLabel(event) {
    $(".search-labels-" + event.params.id).val(event.target.outerText);
    $(".search-labels-result-wrapper").empty();
  }
}