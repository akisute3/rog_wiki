# coding: utf-8
class ApiController < ApplicationController

  protect_from_forgery except: [:pull]

  def pull
    GIT_REPO.pull
    render json: {result: :success}
  rescue => e
    render json: {result: :error, message: e.message}
  end

end
