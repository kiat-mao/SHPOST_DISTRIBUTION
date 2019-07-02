class ImportFilesController < ApplicationController
  load_and_authorize_resource
  user_logs_filter only: [:download, :import], symbol: :file_name, operation: :operation, object: :ImportFile

  def index
    @import_files_grid = initialize_grid(@import_files,
         :order => 'import_files.created_at',
         :order_direction => 'desc')
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @import_file.save
        format.html { redirect_to @import_file, notice: I18n.t('controller.create_success_notice', model: '信息导入结果') }
        format.json { render action: 'show', status: :created, location: @import_file }
      else
        format.html { render action: 'new' }
        format.json { render json: @import_file.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  end

  def destroy
    @operation = "destroy"
    file_path = @import_file.file_path
    if File.exist?(file_path)
      File.delete(file_path)
    end
    @import_file.destroy
      
    respond_to do |format|
      format.html { redirect_to import_files_path }
      format.json { head :no_content }
    end
  end

  def download
    @operation = "download"
    @file_name = @import_file.file_name
    file_path = @import_file.file_path
        
    if !file_path.blank?
      file_path = Rails.root.to_s + file_path 
      if File.exist?(file_path)
        io = File.open(file_path)
        send_data(io.read, :type => "text/excel;charset=utf-8; header=present",              :filename => @file_name)
        io.close
      else
        redirect_to commodity_import_files_path(@import_file.symbol_id), :notice => '文件不存在，下载失败！'
      end
    end
  end

  def image_index
    @import_files = nil
    @symbol_id = nil
    if !params[:format].blank?
      @symbol_id = params[:format].to_i
      @import_files = ImportFile.where(symbol_id: @symbol_id )
    end
    @import_files_grid = initialize_grid(@import_files,
         :order => 'import_files.created_at',
         :order_direction => 'desc')
  end

  private
    def set_import_file
      @import_file = ImportFile.find(params[:id])
    end

    def import_file_params
      params.require(:import_file).permit(:file_name, :file_path)
    end
end
