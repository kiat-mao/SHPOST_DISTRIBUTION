module ApplicationHelper
	def supplier_select_autocom(obj_id,obj)
       
       concat text_field_tag('supplier_name', @commodity.supplier.try(:name), 'data-autocomplete' => "/supplier_autocom/c_autocomplete_supplier_name?objid=#{obj_id}&obj=#{obj}")
       hidden_field(obj_id.to_sym,"supplier_id");
    end
end
