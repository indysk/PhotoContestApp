class UrlsController < ApplicationController
  def update

    url_model = Url.new
    url_model.get_url_params(url_params)
    redirect_to root_path and return unless correct_user?(url_model.contest.user)

    @contest ||= url_model.contest
    if @contest.update(url_model.contest_params)
      @url = {page: url_model.page, url_value: url_model.url_value}
      flash[:success] = '更新しました'
    else
      flash[:danger] = 'URLの更新に失敗しました'
    end
  end

  private
    def url_params
      params.require(:url).permit(:id, :page)
    end
end
