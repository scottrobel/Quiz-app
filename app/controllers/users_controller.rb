# frozen_string_literal: true

class UsersController < ApplicationController
  include UsersHelper
  def show
    @user = User.find_by(id: params[:id])
  end

  def index
    user_json = User.all.includes(:responses, :quizzes).map do |user|
      {
        object: get_json_from(user),
        quizzes: user.quizzes.includes(:answers, :questions, :responses).map do |quiz|
          {
            object: get_json_from(quiz),
            questions: quiz.questions.map do |question|
            {
              object: get_json_from(question),
              answers: question.answers.map do |answer|  
                {
                  object: get_json_from(answer)
                }
              end
            }
            end,
            responses: quiz.responses.includes(:response_answers).map do |response|
            {
              object: get_json_from(response),
              response_answers: response.response_answers.map do |response_answer|
                {
                  object: get_json_from(response_answer)
                }
              end
            }
            end
          }
        end
      }
    end
    respond_to do |format|
      format.json  { render :json => user_json } # don't do msg.to_json
    end
  end
  
  private

  def get_json_from(object)
    json_data = object.class.column_names.map do |column_name|
      [column_name, object[column_name]]
    end.to_h
    json_data["id"] = nil
    json_data
  end
end
