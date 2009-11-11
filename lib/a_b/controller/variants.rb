Application.class_eval do
  
  get '/variants/:id/destroy' do
    @variant = ABVariant.find params[:id]
    if @variant
      @variant.destroy
      flash[:success] = 'Variant deleted successfully.'
    else
      flash[:error] = 'Could not delete variant.'
    end
    redirect '/'
  end
end
