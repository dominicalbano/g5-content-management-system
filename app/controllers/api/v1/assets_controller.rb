class Api::V1::AssetsController < Api::V1::ApplicationController
  def index
    render json: Asset.all
  end

  def show
    render json: Asset.find(params[:id]), root: :asset
  end

  def create
    @asset = Asset.new(asset_params)
    if @asset.save
      render json: @asset, root: :asset
    else
      render json: {errors: @asset.errors.messages}, status: :unprocessable_entity
    end
  end

  def update
    @asset = Asset.find(params[:id])
    if @asset.update_attributes(asset_params)
      render json: @asset, root: :asset
    else
      render json: @asset.errors, root: :asset, status: :unprocessable_entity
    end
  end

  def destroy
    @asset = Asset.find(params[:id])
    if @asset.destroy
      render json: nil, status: :ok
    else
      render json: @asset.errors, root: :asset, status: :unprocessable_entity
    end
  end

  def sign_upload
    aws_signer = AWSSigner.new(params)
    render json: aws_signer.upload_headers, status: :ok
  end

  def sign_delete
    aws_signer = AWSSigner.new(params)
    render json: aws_signer.delete_headers, status: :ok
  end

  private

  def asset_params
    params.require(:asset).permit(:name, :url, :website_id, :category_id)
  end
end

