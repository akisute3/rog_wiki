# coding: utf-8
class WikisController < ApplicationController

  before_action :set_wiki, only: [:show, :edit, :destroy]

  def index
    @wikis = Wiki.all
  end

  def show
    redirect_to(action: :new, id: params[:id]) unless @wiki.exist?
  end

  def new
    @wiki = Wiki.new(title: params[:id])
  end

  def edit
  end

  def create
    @wiki = Wiki.new(wiki_params)

    respond_to do |format|
      if @wiki.save
        format.html { redirect_to action: :show, id: @wiki.title }
      else
        format.html { render action: (action_name == 'create') ? :new : :edit }
      end
    end
  end

  def update
    create
  end

  def destroy
    @wiki.destroy
    respond_to do |format|
      format.html { redirect_to wikis_url, notice: "\"#{@wiki.title}\" を削除しました" }
    end
  end


  private

  def set_wiki
    @wiki = Wiki.read(params[:id])
  end

  def wiki_params
    hash = params.require(:wiki).permit(:title, :content, :comment)
    hash[:title] = nil if hash[:title].empty?

    hash
  end

end
