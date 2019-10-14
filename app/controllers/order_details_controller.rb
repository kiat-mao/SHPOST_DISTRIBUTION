class OrderDetailsController < ApplicationController
  load_and_authorize_resource :order, only: [:new, :create, :edit, :update]
  load_and_authorize_resource :order_detail, through: :order, only: [:new, :create]
  load_resource :commodity, only: [:new, :create]
  load_and_authorize_resource
  after_action :logging, :if => proc {|c| c.action_name.in? ["create", "to_check", "to_recheck", "check_decline", "place", "recheck_decline", "confirm", "cancel"] || (c.action_name.eql?("update") && !@order_detail.try(:waiting?))}
  # after_action :logging_update,  only: [:update], if: -> {!@order_detail.try :waiting?}

  # GET /order_details
  # GET /order_details.json
  def index
    # @order_details = initialize_grid(@order_details.accessible_by(current_ability))
  end

  #审核被驳回子订单
  def pending
    @status = "pending"
    @order_details_grid = initialize_grid(@order_details.joins(:order).accessible_by(current_ability).where(status: OrderDetail.statuses[:pending]), :order => 'created_at', :order_direction => 'desc', :per_page => params[:page_size])
    render "index"
  end

  #待审核子订单
  def checking
    @status = "checking"
    @order_details_grid = initialize_grid(@order_details.joins(:order).accessible_by(current_ability).where(status: OrderDetail.statuses[:checking]), :order => 'created_at', :order_direction => 'desc', :per_page => params[:page_size])
    render "index"
  end

  #复核被驳回子订单
  def declined
    @status = "declined"
    @order_details_grid = initialize_grid(@order_details.joins(:order).accessible_by(current_ability).where(status: OrderDetail.statuses[:declined]), :order => 'created_at', :order_direction => 'desc', :per_page => params[:page_size])
    render "index"
  end

  #待复核子订单
  def rechecking
    @status = "rechecking"
    @order_details_grid = initialize_grid(@order_details.joins(:order).accessible_by(current_ability).where(status: OrderDetail.statuses[:rechecking]), :order => 'created_at', :order_direction => 'desc', :per_page => params[:page_size])
    render "index"
  end

  #待收货子订单
  def receiving
    @status = "receiving"
    @order_details_grid = initialize_grid(@order_details.joins(:order).accessible_by(current_ability).where(status: OrderDetail.statuses[:receiving]), :order => 'created_at', :order_direction => 'desc', :per_page => params[:page_size])
    render "index"
  end

  #查看子订单
  def look
    @status = "look"
    where_sql = "order_details.status != 'waiting'"
    @add_status = params[:status]
    
    if !params[:status].blank?
      if params[:status].eql?"receiving_closed"
        where_sql = "order_details.status = 'receiving' or order_details.status = 'closed'"
      elsif params[:status].eql?"not_canceled"
        where_sql = "order_details.status != 'canceled' and order_details.status != 'waiting'"
      end
    end
   
    if ! current_user.unitadmin? && ! current_user.superadmin? && current_user.branch?
      @order_details = @order_details.joins(:order).accessible_by(current_ability).where(where_sql)
    else
      @order_details = @order_details.joins(:order).where(where_sql)
    end  
    @order_details_grid = initialize_grid(@order_details, :order => 'created_at', :order_direction => 'desc', :per_page => params[:page_size]) 
    
    render "index"
  end

  # GET /order_details/1
  # GET /order_details/1.json
  def show
  end

  # GET /order_details/new
  def new
    # @order = Order.find params[:order_id].to_i
    @commodity = Commodity.find params[:commodity_id].to_i
  end

  # GET /order_details/1/edit
  def edit
    @order = @order_detail.order
    @commodity = @order_detail.commodity
    @source = request.referer
    # binding.pry
    # @order = @order_detail.order
    # @commodity = @order_detail.commodity
  end

  # POST /order_details
  # POST /order_details.json
  def create
    # @order = Order.find(params[:order_id].to_i)
    # @order_detail.order = @order
    # binding.pry
    @commodity = Commodity.find(params[:commodity_id].to_i)
    @order_detail.commodity = @commodity
    @order_detail.at_unit = current_user.unit
    @order_detail.status = "waiting"
    @order_detail.cost_price = @commodity.try :cost_price
    
    respond_to do |format|
      if @order_detail.save
        format.html { redirect_to @order_detail, notice: I18n.t('controller.create_success_notice', model: '子订单') }
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
    # @order = @order_detail.order
    # @commodity = @order_detail.commodity
    respond_to do |format|
      if @order_detail.update(order_detail_params)
        format.html { redirect_to @order_detail, notice: I18n.t('controller.update_success_notice', model: '子订单') }
        format.json { head :no_content }
      else
        @source = params[:source]
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
      format.html { redirect_to request.referer  }
      format.json { head :no_content }
    end
  end

  #提交（审核）
  def to_check
    @order_detail.checking!
    redirect_to request.referer
  end

  #通过（审核）
  def to_recheck
    @order_detail.rechecking!
    redirect_to request.referer   
  end

  #驳回（审核）
  def check_decline
    @why_decline = params[:why_decline]    
    @order_detail.pending! @why_decline
    redirect_to request.referer
  end

  #下单
  def place
    @order_detail.receiving!
    redirect_to request.referer
  end

  #驳回（复核）
  def recheck_decline
    @why_decline = params[:why_decline] 
    @order_detail.declined! @why_decline
    redirect_to request.referer
  end

  #收货
  def confirm
    @order_detail.closed!
    redirect_to request.referer
  end

  #取消
  def cancel
    respond_to do |format|
      if @order_detail.canceled!
        format.html { redirect_to request.referer, notice: I18n.t('controller.cancel_success_notice', model: '子订单') }
        format.json { head :no_content }
      else
        @source = params[:source]
        format.html { render action: request.referer }
        format.json { render json: @order_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  

  private
    def logging
      order_detail_log = OrderDetailLog.create!(user: current_user, operation: params[:action], order_detail: @order_detail, desc: @why_decline)
    end
    # Use callbacks to share common setup or constraints between actions.
    # def set_order_detail
    #   @order_detail = OrderDetail.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_detail_params
      params.require(:order_detail).permit(:amount, :price, :commodity_id, :branch_name, :branch_no)
    end
end
