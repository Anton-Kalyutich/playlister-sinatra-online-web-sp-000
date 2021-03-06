require 'rack-flash'

class SongsController < ApplicationController

    configure do
        enable :sessions
        use Rack::Flash
    end
    
    get '/songs' do
        @songs = Song.all
        erb :'songs/index'
    end

    get '/songs/new' do
        @artists = Artist.all
        @genres = Genre.all
        erb :'songs/new'
    end

    post '/songs' do
        @song = Song.create(params[:song])
        if !params[:artist][:name].empty?
            Artist.find_or_create_by(name: params[:artist][:name]).songs << @song
        end
    
        flash[:message] = "Successfully created song."
        redirect "/songs/#{@song.slug}"
    end

    get '/songs/:slug' do
        @song = Song.find_by_slug(params[:slug])
        @artist = @song.artist
        @genres = @song.genres
        erb :'songs/show'
    end

    get '/songs/:slug/edit' do
        @song = Song.find_by_slug(params[:slug])
        @artists = Artist.all
        @genres = Genre.all
        erb :'songs/edit'
    end

    patch '/songs/:slug' do
        @song = Song.find_by_slug(params[:slug])
        @song.update(params[:song])
        if !params[:artist][:name].empty?
            Artist.find_or_create_by(name: params[:artist][:name]).songs << @song
        end
        flash[:message] = "Successfully updated song."
        redirect "/songs/#{@song.slug}"
    end
end