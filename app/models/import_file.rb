class ImportFile < ActiveRecord::Base
	belongs_to :user
	belongs_to :unit
	belongs_to :symbol, polymorphic: true

	CATEGORY = {commodity: '商品', supplier: '供应商'}

	def self.img_upload_path(file, symbol, category)
		if !file.original_filename.empty?
			direct = "/public/pic/#{category}/"
			filename = "#{Time.now.to_i}_#{file.original_filename}"

	  	    if !File.exist?("#{Rails.root}/public/pic/")
	          Dir.mkdir("#{Rails.root}/public/pic/")          
	        end
	        if !File.exist?("#{Rails.root}/public/pic/#{category}/")
	          Dir.mkdir("#{Rails.root}/public/pic/#{category}/") 
	        end
	        if !symbol.blank?
		    	if !File.exist?("#{Rails.root}/public/pic/#{category}/#{symbol.id}/")
		          Dir.mkdir("#{Rails.root}/public/pic/#{category}/#{symbol.id}/") 
		        end
		    	direct = "#{direct}#{symbol.id}/"
		    else
		    	if !File.exist?("#{Rails.root}/public/pic/#{category}/zip/")
			    	Dir.mkdir("#{Rails.root}/public/pic/#{category}/zip/") 
			    end
			    direct = "#{direct}zip/"
			end

		    file_path = direct + filename
		    File.open(Rails.root.to_s + file_path, "wb") do |f|
		      f.write(file.read)
		    end
		    file_path
		end
	end

	def self.image_import(file_path, symbol, user, category)
		ori_file_name = File.basename(file_path)
		file_name = File.basename(file_path, "r:ISO-8859-1")
        file_ext = File.extname(file_name)
        size = File.size(Rails.root.to_s + file_path) 

        import_file = ImportFile.create! file_name: file_name, file_path: File.join(file_path.split(ori_file_name), file_name), user_id: user.id, unit_id: user.unit.id, file_ext: file_ext, size: size, symbol_id: symbol.blank? ? nil : symbol.id, category: category, symbol_type: symbol.blank? ? nil : symbol.class.to_s

        return import_file
    end

	def image_destroy!
		file_path = Rails.root.to_s + self.file_path
		
	    if File.exist?(file_path)
	      File.delete(file_path)
	    end
	    
	    self.destroy!
	end

	def self.decompress(file_path, zip_direct, pic_direct, user, category)
		commodity_no = []
		desc = ""
		file_path = Rails.root.to_s + file_path
		
		Zip::File.open(file_path, "r:ISO-8859-1") do |zip|  
            zip.each do |folder| 
            	folder.extract(File.join(zip_direct,folder::name))  
                commodity_no << (folder::name).split('/')[0]
            end
            commodity_no.uniq.each do |f|
            	symbol = Commodity.find_by(no: f)
            	if !File.exist?("#{Rails.root}#{pic_direct}#{symbol.id}/")
					Dir.mkdir("#{Rails.root}#{pic_direct}#{symbol.id}/") 
				end
            	if !symbol.blank? and symbol.category.eql?category             
	                Dir.foreach(folder_direct = File.join(zip_direct,f)) do |pic|
	                	if pic !="." and pic !=".."
	                		if !(pic.include?('.jpg') or pic.include?('.jpeg') or pic.include?('.png') or pic.include?('.bmp'))
	                			desc += ",图片"+pic+"格式不正确"
	                			next
	                		end
	                		if (File.size(File.join(folder_direct,pic))/1024/1024) > I18n.t("pic_upload_param.pic_size")
	                			desc += ",图片"+pic+"大于#{I18n.t("pic_upload_param.pic_size")}M"
	                			next
	                		end	
		                    FileUtils.cp_r(File.join(folder_direct,pic), "#{Rails.root}#{pic_direct}#{symbol.id}/")
		                    new_pic_name = "#{Time.now.to_i}_#{pic}"
		                    File.rename("#{Rails.root}#{pic_direct}#{symbol.id}/#{pic}", "#{Rails.root}#{pic_direct}#{symbol.id}/#{new_pic_name}")
		                    self.image_import(File.join("#{pic_direct}#{symbol.id}/",new_pic_name), symbol, user, symbol.category)
		                end
	                end
	            else
	            	desc += ",文件夹"+f+"找不到对应商品大类的商品"
	            end
                FileUtils.rm_r(File.join(zip_direct,f))
            end
        end
        return desc
	end

	def img_relative_path
		file_path = self.file_path
		start = file_path.index("/pic")
		relative_path = file_path[start, file_path.length-1]
		
		return relative_path
	end

	def absolute_path
		self.file_path.blank? ? nil : Rails.root.to_s + self.file_path
	end

	
end
