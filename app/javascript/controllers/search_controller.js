import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["ingredients"]
  connect() {
    $(".search-result-wrapper").hide();
  }

  results(event) {
    event.preventDefault();
    $(".search-result-wrapper, .spinner").show();
    $(".exact-results, .extra-results, .exact-results-title, .extra-results-title").empty();
    $.get('/search/results', {ingredients: this.ingredientsTarget.value}, function(data, status) {
        if (data && data.length > 0) {
            $.each(data, function(k,v) {
                const recipeTemplate = `
                    <div class="border p-5">
                    <div class="text-xl font-bold mb-5">${v.title}</div>
                    <div class="flex mb-5 justify-center">
                        <img class="w-20 h-30" src="${v.image}">
                    </div>
                    <div>
                        ${v.ingredients_list.split("\n").map(ingredient => 
                            `<li>${ingredient}</li>`
                        ).join('')}
                    </div>
                    </div>
                `
                if(v.is_exact) {
                    $(".exact-results-title").html("Recipes that are a perfect match");
                    $(".search-result-wrapper .exact-results").append(recipeTemplate);
                } else {
                    $(".extra-results-title").html("Not the exact recipes but close enough");
                    $(".search-result-wrapper .extra-results").append(recipeTemplate);
                }
            });
        } else {
            $(".search-result-wrapper .no-results").html("<p>No matching recipes found.</p>")
        }
    }, 'json')
    .done(function() {
        // This function will be executed when the get request is done
        $(".spinner").hide();
    })
  }
}