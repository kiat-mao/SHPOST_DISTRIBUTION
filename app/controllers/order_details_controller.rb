class OrderDetailsController < ApplicationController
  load_and_authorize_resource :order
  load_and_authorize_resource :order_detail, through: :order
  
  after_action :logging, only: [:create, :to_check, :to_recheck, :check_decline, :place, :recheck_decline, :confirm, :cancel]
  after_action :logging,  only: [:update], unless: -> {@order_detail.try :waiting?}

  # GET /order_details
  # GET /order_details.json
  def index
    # @order_details = initialize_grid(@order_details.accessible_by(current_ability))
  end

  #审核被驳回子订单
  def pending
    @status = "pending"
    @order_details = initialize_grid(@order_details.joins(:order).accessible_by(current_ability).where(status: OrderDetail.statuses[:pending]).order("orders.no, order_details.no"))
    render "index"
  end

  #待审核子订单
  def checking
    @status = "checking"
    @order_details = initialize_grid(@order_details.joins(:order).accessible_by(current_ability).where(status: OrderDetail.statuses[:checking]).order("orders.no, order_details.no"))
    render "index"
  end

  #复核被驳回子订单
  def declined
    @status = "declined"
    @order_details = initialize_grid(@order_details.joins(:order).accessible_by(current_ability).where(status: OrderDetail.statuses[:declined]).order("orders.no, order_details.no"))
    render "index"
  end

  #待复核子订单
  def rechecking
    @status = "rechecking"
    @order_details = initialize_grid(@order_details.joins(:order).accessible_by(current_ability).where(status: OrderDetail.statuses[:rechecking]).order("orders.no, order_details.no"))
    render "index"
  end

  #待收货子订单
  def receiving
    @status = "receiving"
    @order_details = initialize_grid(@order_details.joins(:order).accessible_by(current_ability).where(status: OrderDetail.statuses[:receiving]).order("orders.no, order_details.no"))
    render "index"
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
    @from_order = params[:format]
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
        if @order_detail.waiting?
          format.html { redirect_to fresh_orders_url, notice: I18n.t('controller.update_success_notice', model: '子订单') }
          format.json { head :no_content }
        else
          if params[:from_order].eql?"from_order"
            format.html { redirect_to pending_orders_url, notice: I18n.t('controller.update_success_notice', model: '子订单') }
            format.json { head :no_content }
          else
            format.html { redirect_to pending_order_details_url, notice: I18n.t('controller.update_success_notice', model: '子订单') }
            format.json { head :no_content }
          end
        end
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
    status = @order_detail.status
    @order_detail.rechecking!
    if params[:format].eql?"from_order"
      if status.eql?"declined"
        redirect_to declined_orders_url
      else
        redirect_to checking_orders_url
      end
    else
      if status.eql?"declined"
        redirect_to declined_order_details_url
      else
        redirect_to checking_order_details_url
      end
    end
  end

  #驳回（审核）
  def check_decline
    # binding.pry
    status = @order_detail.status
    @order_detail.update why_decline: params[:why_decline]    
    @order_detail.pending!
<<<<<<< HEAD
    if params[:format].eql?"from_order"
      if status.eql?"declined"
        redirect_to declined_orders_url
      else
        redirect_to checking_orders_url
      end
    else
      if status.eql?"declined"
        redirect_to declined_order_details_url
      else
        redirect_to checking_order_details_url
      end
    end
=======

    @why_decline = @order_detail.why_decline
>>>>>>> 36a5d7ef6566084c9263d06aa0bacae5b6b757c3
  end

  #下单
  def place
    @order_detail.receiving!
    if params[:format].eql?"from_order"
      redirect_to rechecking_orders_url
    else
      redirect_to rechecking_order_details_url
    end
  end

  #驳回（复核）
  def recheck_decline
    @order_detail.declined!
<<<<<<< HEAD
    if params[:format].eql?"from_order"
      redirect_to rechecking_orders_url
    else
      redirect_to rechecking_order_details_url
    end
=======

    @why_decline = @order_detail.why_decline
>>>>>>> 36a5d7ef6566084c9263d06aa0bacae5b6b757c3
  end

  #收货
  def confirm
    @order_detail.closed!
    if params[:format].eql?"from_order"
      redirect_to receiving_orders_url
    else
      redirect_to receiving_order_details_url
    end
  end

  #取消
  def cancel
    @order_detail.canceled!
    if params[:format].eql?"from_order"
      redirect_to receiving_orders_url
    else
      redirect_to receiving_order_details_url
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
      params.require(:order_detail).permit(:amount, :price, :commodity_id)
    end
end
