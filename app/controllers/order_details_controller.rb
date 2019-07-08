class OrderDetailsController < ApplicationController
  load_and_authorize_resource

  # GET /order_details
  # GET /order_details.json
  def index
    status = params[:status].to_sym
    @order_details = initialize_grid(@order_details.accessible_by(current_ability))
  end

  #审核被驳回子订单
  def pending
    @order_details = initialize_grid(@order_details.where(status: OrderDetail.statuses[:pending]).where(user: current_user))
  end

  #待审核子订单
  def checking
    @order_details = initialize_grid(@order_details.where(status: OrderDetail.statuses[:checking]))
  end

  #复核被驳回子订单
  def declined
    @order_details = initialize_grid(@order_details.where(status: OrderDetail.statuses[:declined])]
  end

  #待复核子订单
  def rechecking
    @order_details = initialize_grid(@order_details.where(status: OrderDetail.statuses[:rechecking]))
  end

  #待收货子订单
  def receiving
    @order_details = initialize_grid(@order_details.where(status: OrderDetail.statuses[:receiving]).(user: current_user))
  end

  # GET /order_details/1
  # GET /order_details/1.json
  def show
  end

  # GET /order_details/new
  def new
    @order = Order.find(params[:order_id].to_i)
    @commodity_id = params[:commodity_id].to_i
  end

  # GET /order_details/1/edit
  def edit
    @order = @order_detail.order
    @commodity_id = @order_detail.commodity_id
  end

  # POST /order_details
  # POST /order_details.json
  def create
    @order = Order.find(params[:order_id].to_i)
    @order_detail.order = @order
    
    @order_detail.commodity = Commodity.find(params[:commodity_id].to_i)
    @order_detail.at_unit = current_user.unit
    @order_detail.status = "waiting"

    respond_to do |format|
      if @order_detail.save!
        format.html { redirect_to commodity_choose_order_path(@order), notice: I18n.t('controller.create_success_notice', model: '子订单') }
        format.json { render action: 'show', status: :created, location: @order_detail }
      else
        format.html { render action: 'new' }
        format.json { render json: @order_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /order_details/1
  # PATCH/PUT /order_details/1.json
  def update
    @order = @order_detail.order
    respond_to do |format|
      if @order_detail.update!(order_detail_params)
        format.html { redirect_to fresh_orders_url, notice: I18n.t('controller.create_success_notice', model: '子订单') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_details/1
  # DELETE /order_details/1.json
  def destroy
    @order_detail.destroy!
    respond_to do |format|
      format.html { redirect_to fresh_orders_url }
      format.json { head :no_content }
    end
  end

  #提交（审核）
  def to_check
    @order_detail.checking!
  end

  #通过（审核）
  def to_recheck
    @order_detail.rechecking!
  end

  #驳回（审核）
  def check_decline
    @order_detail.declined!
  end

  #下单
  def place
    @order_detail.receiving!
  end

  #驳回（审核）
  def recheck_decline
    @order_detail.declined!
  end

  #收货
  def confirm
    @order_detail.closed!
  end

  #取消
  def cancel
    @order_detail.canceled!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_order_detail
    #   @order_detail = OrderDetail.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_detail_params
      params.require(:order_detail).permit(:amount, :price, :commodity_id)
    end
end
