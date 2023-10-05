class FtIngredientsController < ApplicationController
  before_action :set_ft_ingredient, only: %i[ show edit update destroy ]
  @@model = FastText.load_model("app/ml_models/ft_ingredients.bin")

  # GET /ft_ingredients or /ft_ingredients.json
  def index
    @ft_ingredients_count = FtIngredient.all.count
    @pagy, @ft_ingredients = pagy(FtIngredient.all.order(id: :asc))
  end

  # GET /ft_ingredients/1 or /ft_ingredients/1.json
  def show
  end

  # GET /ft_ingredients/new
  def new
    @ft_ingredient = FtIngredient.new
  end

  # GET /ft_ingredients/1/edit
  def edit
  end

  # POST /ft_ingredients or /ft_ingredients.json
  def create
    @ft_ingredient = FtIngredient.new(ft_ingredient_params)

    respond_to do |format|
      if @ft_ingredient.save
        format.html { redirect_to ft_ingredient_url(@ft_ingredient), notice: "Ft ingredient was successfully created." }
        format.json 
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ft_ingredient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ft_ingredients/1 or /ft_ingredients/1.json
  def update
    respond_to do |format|
      if @ft_ingredient.update(label: ft_ingredient_params[:label].squish.pluralize)
        format.html { redirect_to edit_ft_ingredient_url(id: (@ft_ingredient.id + 1)), notice: "Ft ingredient was successfully updated." }
        format.json { render :show, status: :ok, location: @ft_ingredient }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ft_ingredient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ft_ingredients/1 or /ft_ingredients/1.json
  def destroy
    @ft_ingredient.destroy

    respond_to do |format|
      format.html { redirect_to ft_ingredients_url, notice: "Ft ingredient was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def unique_labels 
    @unique_labels = FtIngredient.distinct.order(:label).pluck(:label)
  end

  def train
    @ft_ingredients = FtIngredient.all
    text = []
    label = []
    @ft_ingredients.each do |ingredient|
      text.push(ingredient.text)
      label.push(ingredient.label)
    end
    model = FastText::Classifier.new(loss: "softmax", epoch: 30, lr: 0.5, word_ngrams: 1, pretrained_vectors: 'wiki-news-300d-1M.vec', dim: 300)
    model.fit(text, label)
    model.save_model("app/ml_models/ft_ingredients.bin")
  
    render :nothing
  end

  def predict_and_fix

  end

  def predict
    ingredients_list = params[:ingredients_list].split("\n").map { |ingredient| ingredient.delete_suffix(",").gsub(/\"/, '').squish}

    @results = ingredients_list.map do |ingredient|
      { input: ingredient, prediction: @@model.predict(ingredient) }
    end

    respond_to do |format|
      format.json
    end
  end

  def search_labels
    @labels = FtIngredient.where("label iLIKE ?", "%#{params[:search_label]}%").pluck(:label).uniq
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ft_ingredient
      @ft_ingredient = FtIngredient.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ft_ingredient_params
      params.require(:ft_ingredient).permit(:label, :text)
    end
end
