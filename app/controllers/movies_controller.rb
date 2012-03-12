class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    remember_previous_settings
    @all_ratings = Movie.all_ratings
    @selected_ratings = Hash.new
    if params[:ratings]
      params[:ratings].keys.each do |r|
          @selected_ratings[r] = "1"
      end
    else
      @all_ratings.each do |r|
        @selected_ratings[r] = "1"
      end
    end

    @movies = Movie.find_all_by_rating(@selected_ratings.keys, :order => params[:sort_by])
    if params[:sort_by] == 'title' 
      @sort_by = 'title'
      @title_col_class = 'hilite'
    elsif params[:sort_by] == 'release_date' 
      @sort_by = 'release_date'
      @date_col_class = 'hilite'
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def remember_previous_settings
    settings = [:sort_by, :ratings]
    redirect_needed = false
    settings.each do |s|
      if params[s]
        session[s] = params[s]
      elsif session[s]
        params[s] = session[s]
        redirect_needed = true
      end
    end
    if redirect_needed
      redirect_to movies_path(params)
    end
  end

end
