class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    ratings = params[:ratings]
    sort_by = params[:sort_by]
    if ratings == nil and sort_by == nil
      ratings = session[:ratings]
      sort_by = session[:sort_by]
      if ratings != nil and sort_by !=nil
        redirect_to movies_path({:ratings => ratings, :sort_by => sort_by})
        return
      end
    elsif ratings == nil
      ratings = session[:ratings]
      if ratings != nil
        redirect_to movies_path({:ratings => ratings, :sort_by => sort_by})
        return
      end
    elsif ratings.empty?
      ratings = session[:ratings]
      if ratings !=nil
        redirect_to movies_path({:ratings => ratings, :sort_by => sort_by})
        return
      end
    elsif sort_by == nil
      sort_by = session[:sort_by]
      if sort_by !=nil
        redirect_to movies_path({:ratings => ratings, :sort_by => sort_by})
        return
      end
    end


    if ratings != nil 
      session[:ratings] =ratings
      ratings = ratings.keys
      @movies = Movie.where(:rating => ratings).all
    else
      @movies = Movie.all
    end

    if sort_by != nil
      if sort_by == 'title'
        #@movies = Movie.find(:all, :order => 'title' )
        #@movies = Movie.all
        @movies = @movies.sort_by {|m| m.title}
        @cond_hilite1 ='hilite'
        session[:sort_by] = sort_by
      elsif sort_by == 'date'
        #@movies = Movie.find(:all, :order => 'release_date')
        @movies = @movies.sort_by {|m| m.release_date}
        @cond_hilite2 = 'hilite'
        session[:sort_by] = sort_by
      end

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

end
