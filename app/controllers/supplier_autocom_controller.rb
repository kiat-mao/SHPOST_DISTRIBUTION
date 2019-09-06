class SupplierAutocomController < ApplicationController
	load_and_authorize_resource :supplier

	autocomplete :supplier, :name, :extra_data => [:obj]

	def c_autocomplete_supplier_name
		term = params[:term]
    obj_id = params[:objid]
    obj = params[:obj]
	    # binding.pry
	    
    suppliers = Supplier.where("suppliers.name like ?","%#{term}%").order(:sno).all
	      
	    # binding.pry
    render :json => suppliers.map { |supplier| {:id => supplier.id, :label => supplier.name, :value => supplier.name, :obj => obj_id} }

  end
end