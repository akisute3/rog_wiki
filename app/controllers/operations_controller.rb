# coding: utf-8
class OperationsController < ApplicationController

  def pull
    GIT_REPO.pull
    render json: {result: :success}
  rescue => e
    render json: {result: :error, message: e.message}
  end

end
