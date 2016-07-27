class AudiosController < ApplicationController

  def new
    @audio = Audio.new
  end


  def create
    @audio = Audio.new(audio_params)
    if @audio.save
      redirect_to @audio
    else
      @errors = @audio.errors.full_messages
      render 'new'
    end
  end

  def show
  end

private
  def audio_params
    params.require(:audio).permit(:track)
  end

end
