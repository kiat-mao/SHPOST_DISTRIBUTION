class OrdersController < ApplicationController
  load_and_authorize_resource

  after_action :logging, only: [:to_check, :to_recheck, :check_decline, :place, :recheck_decline, :confirm]
  # before_filter :logging

  # GET /orders
  # GET /orders.json
  def index
  end

  #新建订单
  def fresh
    @orders = initialize_grid(@orders.accessible_by(current_ability).fresh)
    render "index"
  end

  #审核被驳回订单
  def pending
    @orders = initialize_grid(@orders.accessible_by(current_ability).by_status [OrderDetail.statuses[:pending]])
    render "index"
  end

  #待审核订单
  def checking
    @orders = initialize_grid(@orders.accessible_by(current_ability).by_status [OrderDetail.statuses[:checking]])
    render "index"
  end

  #复核被驳回订单
  def declined
    @orders = initialize_grid(@orders.accessible_by(current_ability).by_status [ OrderDetail.statuses[:declined]])
    render "index"
  end

  #待复核订单
  def rechecking
    @orders = initialize_grid(@orders.accessible_by(current_ability).by_status [OrderDetail.statuses[:rechecking]])
    render "index"
  end

  #待收货订单
  def receiving
    @orders = initialize_grid(@orders.accessible_by(current_ability).by_status [OrderDetail.statuses[:receiving]])
    render "index"
  end

  #提交（审核）
  def to_check
    @order_details = @order.checking!
    redirect_to request.referer
  end

  #通过（审核）
  def to_recheck
    @order_details = @order.rechecking!
    redirect_to request.referer   
  end

  #驳回（审核）
  def check_decline
    @why_decline = params[:why_decline]    
    @order_details = @order.pending! @why_decline
    redirect_to request.referer
  end

  #下单
  def place
    @order_details = @order.receiving!
    redirect_to request.referer
  end

  #驳回（复核）
  def recheck_decline
    @why_decline = params[:why_decline] 
    @order_details = @order.declined! @why_decline
    redirect_to request.referer
  end

  #收货
  def confirm
    @order_details = @order.closed!
    redirect_to request.referer
  end

  # 查看
  def look
    if ! current_user.unitadmin? && ! current_user.superadmin?&& current_user.branch?
      @orders = initialize_grid(@orders.accessible_by(current_ability).where(is_fresh: false))
    else
      @orders = initialize_grid(@orders.where(is_fresh: false))
    end    
    render "index"
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
  end

  # GET /orders/1/edit
  def edit
    @source = request.referer
  end

  # POST /orders
  # POST /orders.json
  def create
    @order.user_id = current_user.id
    @order.unit_id = current_user.unit.try :id

    respond_to do |format|
      @order.is_fresh = true
      @order.user = current_user
      @order.unit = current_user.unit

      if @order.save
        format.html { redirect_to @order, notice: I18n.t('controller.create_success_notice', model: '订单')}
        format.json { render action: 'show', status: :created, location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        # if current_user.role.eql?"unitadmin"
        #   format.html { redirect_to look_orders_url, notice: I18n.t('controller.update_success_notice', model: '订单')}
        #   format.json { head :no_content }
        # else
        #   if @order.is_fresh
        #     format.html { redirect_to fresh_orders_url, notice: I18n.t('controller.update_success_notice', model: '订单')}
        #     format.json { head :no_content }
        #   else
        #     format.html { redirect_to pending_orders_url, notice: I18n.t('controller.update_success_notice', model: '订单')}
        #     format.json { head :no_content }
        #   end
        # end
        format.html { redirect_to params[:source], notice: I18n.t('controller.update_success_notice', model: '订单')}
        format.json { head :no_content }       
      else
        @source = params[:source]
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy!
    respond_to do |format|
      format.html { redirect_to request.referer  }
      format.json { head :no_content }
    end
  end

  def commodity_choose
    @order = Order.find(params[:id].to_i)
    @commodities = initialize_grid(Commodity.joins(:supplier).where("commodities.is_on_sell=? and suppliers.is_valid=?", true, true).order(:supplier_id, :cno))

  end


  private
    def logging
      @order_details.each do |order_detail|
        # binding.pry
        order_detail_log = OrderDetailLog.create!(user: current_user, operation: params[:action], order_detail: order_detail, desc: @why_decline)
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    # def set_order
    #   @order = Order.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:address, :name, :tel, :phone, :desc)
    end
end
