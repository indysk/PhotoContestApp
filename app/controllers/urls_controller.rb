class UrlsController < ApplicationController
  def update
    para = url_params
    if @url = self.create(para[:id], para[:tag])
      flash[:success] = '更新しました'
    else
      flash[:danger] = 'URLの更新に失敗しました'
    end
  end

  private
    def url_params
      params.require(:url).permit(:id, :tag)
    end
end
