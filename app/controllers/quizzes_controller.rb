class QuizzesController < ApplicationController
  include QuizzesHelper
  before_action :require_admin
  before_action :require_own_quiz, only: [:edit, :update]
  def new
    @question_type_input = Question.question_types.map{|label, index|[label.split("_").join(" "), label]};
    @quiz = Quiz.new
    0.times do
      @quiz.questions.build.choices.build
    end
  end

  def index
    @quizzes = current_user.quizzes   
  end

  def create
    @quiz = Quiz.new(quiz_params)
    @quiz.creator = current_user
    if params[:commit] == "Add Question"
      @quiz.questions.build
    elsif params[:commit].match?(/Add Option to question \d+/)
      question_number = params[:commit].match(/Add Option to question (\d+)/)[1].to_i - 1
      @quiz.questions[question_number].choices.build
    elsif params[:commit] == "Create Quiz"
      if @quiz.save
        flash[:notice] = "Quiz Created"
        redirect_to root_path
      else
        flash.now[:alert] = @quiz.errors.full_messages.first
      end
    end
    respond_to do |format|
      format.html{ render :new }
      format.js{}
    end
  end

  def edit
    @quiz = Quiz.find_by(id: params[:id])
  end

  def update
    @quiz = Quiz.find_by(id: params[:id])
    unless @quiz.update(quiz_update_params)
      flash[:alert] = @quiz.errors.full_messages
    end
    if params[:commit] == "Add Question"
      @quiz.questions.build
    elsif params[:commit].match?(/Add Option to question \d+/)
      question_number = params[:commit].match(/Add Option to question (\d+)/)[1].to_i - 1
      @quiz.questions[question_number].choices.build
    elsif params[:commit] == "Update Quiz"
      flash[:notice] = "Quiz Updated"
      redirect_to root_path
    end
    respond_to do |format|
      format.html{ render :edit }
      format.js{}
    end
  end

  private

  def quiz_params
    params.require(:quiz).permit(:title, questions_attributes: [:contents,:question_type, :_destroy, choices_attributes: [:contents, :_destroy]])
  end

  def quiz_update_params
    params.require(:quiz).permit(:title, :id ,questions_attributes: [:contents,:question_type, :_destroy,:id, choices_attributes: [:contents, :_destroy, :id]])
  end
end
