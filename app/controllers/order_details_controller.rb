class OrderDetailsController < ApplicationController
  load_and_authorize_resource

  # GET /order_details
  # GET /order_details.json
  def index
  end

  # GET /order_details/1
  # GET /order_details/1.json
  def show
  end

  # GET /order_details/new
  def new
  end

  # GET /order_details/1/edit
  def edit
  end

  # POST /order_details
  # POST /order_details.json
  def create
    respond_to do |format|
      if @order_detail.save
        format.html { redirect_to @order_detail, notice: 'Order detail was successfully created.' }
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
    respond_to do |format|
      if @order_detail.update(order_detail_params)
        format.html { redirect_to @order_detail, notice: 'Order detail was successfully updated.' }
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
    @order_detail.destroy
    respond_to do |format|
      format.html { redirect_to order_details_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_order_detail
    #   @order_detail = OrderDetail.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_detail_params
      params.require(:order_details).permit(:amount, :price, :commodities_id)
    end
end
