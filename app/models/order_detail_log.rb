class OrderDetailLog < ApplicationRecord 
  belongs_to :user
  belongs_to :order_detail

  def single_log_info
  	info = "#{self.created_at.localtime.strftime('%Y-%m-%d %H:%M').to_s},#{self.user.try(:unit).try(:name)}-#{self.user.name}#{I18n.t('order_detail_log.' + self.operation)}了该子订单"
    if !self.desc.blank?
      info += ',驳回理由是:' + self.desc
    end
    return info
  end
end
