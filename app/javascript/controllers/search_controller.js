import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["ingredients"]
  connect() {
    
  }

  results(event) {
    event.preventDefault();
    $(".search-result-wrapper .results").empty();
    $.get('/search/results', {ingredients: this.ingredientsTarget.value}, function(data, status) {
        if (data && data.length > 0) {
            $.each(data, function(k,v) {
                console.log(data)
                $(".search-result-wrapper .results").append(
                    `
                    <div class="border p-5 ">
                        <div class="text-xl font-bold mb-5">${v.title}</div>
                        <div class="flex mb-5 justify-center">
                        <img class="w-20 h-30" src="${v.image}">
                        </div>
                        <div>
                        ${v.ingredients_list.split("\n").map(ingredient => `
                            <li>${ingredient}</li>
                        `).join('')}
                        </div>
                    </div>
                    `
                )
            });
        } else {
            $(".search-result-wrapper .results").html("<p>No matching recipes found.</p>")
        }
    }, 'json')
  }
}