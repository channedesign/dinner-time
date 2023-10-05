import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["ingredientsList"]
  connect() {
    
  }

  results(event) {
    event.preventDefault();
    
    $(".prediction-results-wrapper").empty()
    $.get("/predict_ingredients", {ingredients_list: this.ingredientsListTarget.value}, function(data, status) {
        $(".prediction-results-wrapper").attr('data-controller', 'fuzzy-search');
        $.each(data, function(k, v) {
            const predictTemplate = `
            <div class="w-full mt-5 text-center form-wrapper-${k}">
                <form action="/ft_ingredients" method="post" class="grid grid-cols-8 gap-4 ">
                    <span class="col-span-1  border rounded p-2">${Object.entries(v.prediction).map(([key, value]) => `${(value*100).toFixed(2)}%`).join('')}</span>
                    <input type='text' name='text' value="${v.input}" class="w-full col-span-3">
                    <input type='text' class="search-labels search-labels-${k}" name='label' value="${Object.entries(v.prediction).map(([key, value]) => `${key}`).join('')}"  class="w-full col-span-3">
                    <input type='submit' value='save' data-action="click->predict-ingredients#save"  class="w-full col-span-1 border rounded p-2 hover:bg-slate-200 hover:cursor-pointer">
                </form>
                <div class="search-labels-result-wrapper search-labels-result-wrapper-${k}"></div>
            </div>
        `;
                $(".prediction-results-wrapper").append(predictTemplate)
            
            
        }) 
    }, 'json')
  }

  save(event) {
    event.preventDefault();
    var text_input = $(event.target).parent().find('input[name="text"]').val();
    var label_input = $(event.target).parent().find('input[name="label"]').val()
    $.post("/ft_ingredients", {ft_ingredient: {text: text_input, label: label_input}}, function(data, status) {
        $(event.target).parent().parent().remove();
    }, 'json')
  }
}